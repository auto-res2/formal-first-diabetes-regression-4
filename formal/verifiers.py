"""検証器。確かめてから値を返す。claims の形は知らない。

問い合わせは (repository, mode, 変数名, **args) を受ける。mode は "full"（本番）か "sanity"（試運転）。
値の元になる run は、その mode の成功した最新の run。番号は claims に書かない。
"""
import functools
import hashlib
import io
import json
import subprocess
import zipfile
from fractions import Fraction
from pathlib import Path

BRANCH = "main"
EXPERIMENT_WORKFLOW = "run_experiment.yml"
ARTIFACT = "run-output"
OUTPUT_PATH = "outputs/results/metrics.json"


def _gh(*args: str) -> str:
    return subprocess.run(["gh", *args], check=True, capture_output=True, text=True).stdout


@functools.cache
def _runs(repository: str, mode: str) -> list[dict]:
    """実験のワークフローの、その mode の run（失敗したものも含む）。新しい順。mode は起動時の入力で、run の名前の末尾に入っている。"""
    # ponytail: run が 100 件を超えたら、ページをめくる必要がある
    runs = json.loads(_gh("api", f"repos/{repository}/actions/workflows/{EXPERIMENT_WORKFLOW}/runs?branch={BRANCH}&per_page=100"))
    return [run for run in runs["workflow_runs"] if run["display_title"].split()[-1] == mode]


def _succeeded_runs(repository: str, mode: str) -> list[dict]:
    succeeded = [run for run in _runs(repository, mode) if run["conclusion"] == "success"]
    if not succeeded:
        raise ValueError(f"成功した {mode} の run が無い")
    return succeeded


def _evidence_run(repository: str, mode: str) -> dict:
    return _succeeded_runs(repository, mode)[0]


@functools.cache
def _artifact(repository: str, run: int) -> zipfile.ZipFile:
    """artifact がその run のもので、中身が GitHub の記録した digest と一致することを確かめて開く。"""
    artifacts = json.loads(_gh("api", f"repos/{repository}/actions/runs/{run}/artifacts"))["artifacts"]
    matches = [a for a in artifacts if a["name"] == ARTIFACT and not a["expired"]]
    if len(matches) != 1:
        raise ValueError(f"run {run} に artifact {ARTIFACT!r} が {len(matches)} 個ある")
    archive = subprocess.run(["gh", "api", f"repos/{repository}/actions/artifacts/{matches[0]['id']}/zip"],
                             check=True, capture_output=True).stdout
    if "sha256:" + hashlib.sha256(archive).hexdigest() != matches[0]["digest"]:
        raise ValueError(f"artifact {ARTIFACT!r} の中身が、GitHub の記録した digest と一致しない")
    return zipfile.ZipFile(io.BytesIO(archive))


def _output(repository: str, run: int) -> dict:
    """実験の出力。小数は書かれた桁のままの有理数で読む。"""
    return json.loads(_artifact(repository, run).read(OUTPUT_PATH), parse_float=Fraction)


def experiment_output(repository: str, mode: str, variable: str, key: str):
    """実験の出力の、キーの値。"""
    return _output(repository, _evidence_run(repository, mode)["id"])[key]


def succeeded_runs_experiment_output(repository: str, mode: str, variable: str, key: str) -> list:
    """その mode の成功した run すべての、実験の出力のキーの値。"""
    return [_output(repository, run["id"])[key] for run in _succeeded_runs(repository, mode)]


def artifact_file_sha256(repository: str, mode: str, variable: str, path: str) -> str:
    """artifact にあるファイルの SHA-256。"""
    return hashlib.sha256(_artifact(repository, _evidence_run(repository, mode)["id"]).read(path)).hexdigest()


def artifact_json(repository: str, mode: str, variable: str, path: str, key: str):
    """artifact にある JSON の、キーの値。"""
    return json.loads(_artifact(repository, _evidence_run(repository, mode)["id"]).read(path), parse_float=Fraction)[key]


def artifact_json_only_key(repository: str, mode: str, variable: str, path: str) -> str:
    """artifact にある JSON の、ただ 1 つのキー。"""
    keys = list(json.loads(_artifact(repository, _evidence_run(repository, mode)["id"]).read(path)))
    if len(keys) != 1:
        raise ValueError(f"{path} のキーが 1 つではない: {keys}")
    return keys[0]


def artifact_json_only_value(repository: str, mode: str, variable: str, path: str):
    """artifact にある JSON の、ただ 1 つのキーの値。"""
    return artifact_json(repository, mode, variable, path, artifact_json_only_key(repository, mode, variable, path))


def artifact_rows_sha256(repository: str, mode: str, variable: str, path: str, index: str, columns: list[str]) -> str:
    """artifact にあるデータのファイルから、実験の出力が記録した番号の行を取り出したものの SHA-256。実験コードと同じ表記（JSON）でまとめる。"""
    run = _evidence_run(repository, mode)["id"]
    table = [[float(value) for value in line.split()] for line in _artifact(repository, run).read(path).decode().splitlines()[1:]]
    rows = [table[i] for i in json.loads(_artifact(repository, run).read(OUTPUT_PATH))[index]]
    parts = {"features": [row[:-1] for row in rows], "target": [row[-1] for row in rows]}
    return hashlib.sha256(json.dumps([parts[column] for column in columns]).encode()).hexdigest()


def runner_label(repository: str, mode: str, variable: str) -> str:
    """run の job が走った runner の種類。"""
    run = _evidence_run(repository, mode)["id"]
    jobs = json.loads(_gh("api", f"repos/{repository}/actions/runs/{run}/jobs"))["jobs"]
    labels = {label for job in jobs for label in job["labels"]}
    if len(labels) != 1:
        raise ValueError(f"run {run} の runner の種類が 1 つに決まらない: {sorted(labels)}")
    return labels.pop()


def _json_sha256(content: bytes, drop_keys: list[str]) -> str:
    """JSON から、指定したキーをどの深さでも除いたものの SHA-256。キーの順と空白によらない。"""
    def strip(value):
        if isinstance(value, dict):
            return {key: strip(item) for key, item in value.items() if key not in drop_keys}
        return [strip(item) for item in value] if isinstance(value, list) else value
    return hashlib.sha256(json.dumps(strip(json.loads(content)), sort_keys=True, ensure_ascii=False).encode()).hexdigest()


@functools.cache
def _file_at(repository: str, commit: str, path: str) -> bytes:
    return subprocess.run(["gh", "api", f"repos/{repository}/contents/{path}?ref={commit}",
                           "-H", "Accept: application/vnd.github.raw"], check=True, capture_output=True).stdout


def all_runs_json_sha256(repository: str, mode: str, variable: str, path: str, drop_keys: list[str]) -> list[str]:
    """その mode の run（失敗したものも含む）を起動した commit ごとの、JSON のファイルから指定したキーを除いたものの SHA-256。"""
    _evidence_run(repository, mode)
    return [_json_sha256(_file_at(repository, run["head_sha"], path), drop_keys) for run in _runs(repository, mode)]


def local_json_sha256(repository: str, mode: str, variable: str, path: str, drop_keys: list[str]) -> str:
    """判定に使う（いま手元にある）JSON のファイルから、指定したキーを除いたものの SHA-256。"""
    return _json_sha256(Path(path).read_bytes(), drop_keys)


QUERIES = {"GitHub": {f.__name__: f for f in (
    experiment_output, succeeded_runs_experiment_output, artifact_file_sha256, artifact_json, artifact_json_only_key, artifact_json_only_value, artifact_rows_sha256, runner_label,
    all_runs_json_sha256, local_json_sha256)}}
