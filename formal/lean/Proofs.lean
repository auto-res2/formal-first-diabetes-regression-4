import Spec
/-! 証明に必要なもの（宣言が成り立つことの証明，claims を導く定理，値を含まない公理の宣言）。claims の形式化（claims.json）とは別に置く。 -/

namespace Spec

theorem C03_holds : C03 := rfl

theorem C04_holds : C04 := ⟨rfl, rfl, rfl⟩

theorem C05_holds : C05 := ⟨rfl, rfl, rfl⟩

theorem C06_holds : C06 := ⟨rfl, rfl⟩

theorem C07_holds : C07 := ⟨rfl, rfl⟩

theorem C08_holds : C08 := ⟨rfl, rfl⟩

theorem C09_holds : C09 := rfl

theorem C10_holds : C10 := rfl

theorem C02_holds : C02 :=
  ⟨C03_holds, C04_holds, C05_holds, C06_holds, C07_holds, C08_holds, C09_holds, C10_holds, _, rfl⟩

/-- C02 と，出力された MSE が 3400 を下回ることから，C01 を導く。 -/
theorem C01_of_C02 (outputTestMse : ℚ) :
    C02 → outputTestMse < 3400 → C01 outputTestMse :=
  fun _ below => below

/-- C02 と，出力された MSE が 3400 を下回らないことから，C01 の否定を導く。 -/
theorem not_C01_of_C02 (outputTestMse : ℚ) :
    C02 → ¬ outputTestMse < 3400 → ¬ C01 outputTestMse :=
  fun _ notBelow => notBelow

/-- R06〜R20 から R05 を導く。 -/
theorem R05_of_R06_to_R20 (observedDataset : Dataset) (fetchedSha256 : String) (observedLoad : Load)
    (observedSplit : Split) (observedTrainIndex observedTestIndex : List ℕ) (observedFit : Fit)
    (observedFitInputSha256 loadedTrainRowsSha256 : String) (observedPredict : Predict)
    (observedPredictInputSha256 loadedTestFeaturesSha256 : String) (observedMse : Mse)
    (observedMseTargetSha256 loadedTestTargetSha256 observedMsePredictionSha256 observedPredictOutputSha256 : String)
    (observedEnvironment : Environment) (observedRepositoryCommit : String) :
    R06 C03.value observedDataset → R07 C03.value fetchedSha256 → R08 observedDataset →
    R09 C04.value observedLoad →
    R10 C05.value observedSplit → R11 C03.value observedTrainIndex observedTestIndex →
    R12 C06.value observedFit → R13 observedFitInputSha256 loadedTrainRowsSha256 →
    R14 C07.value observedPredict → R15 observedPredictInputSha256 loadedTestFeaturesSha256 →
    R16 C08.value observedMse → R17 observedMseTargetSha256 loadedTestTargetSha256 →
    R18 observedMsePredictionSha256 observedPredictOutputSha256 →
    R19 C09.value observedEnvironment → R20 C10.value observedRepositoryCommit →
    R05 observedDataset fetchedSha256 observedLoad observedSplit observedTrainIndex observedTestIndex
      observedFit observedFitInputSha256 loadedTrainRowsSha256 observedPredict observedPredictInputSha256
      loadedTestFeaturesSha256 observedMse observedMseTargetSha256 loadedTestTargetSha256 observedMsePredictionSha256
      observedPredictOutputSha256 observedEnvironment observedRepositoryCommit := by
  intro r06 r07 r08 r09 r10 r11 r12 r13 r14 r15 r16 r17 r18 r19 r20 declaration
  cases declaration
  · exact And.intro r06 (And.intro r07 r08)
  · exact r09
  · exact And.intro r10 r11
  · exact And.intro r12 r13
  · exact And.intro r14 r15
  · exact And.intro r16 (And.intro r17 r18)
  · exact r19
  · exact r20

/-- R02（公理），R06，R07 から R08 を導く。 -/
theorem R08_of_R02_R06_R07 (observedDataset : Dataset) (fetchedSha256 : String) :
    R02 fetchedSha256 → R06 C03.value observedDataset → R07 C03.value fetchedSha256 → R08 observedDataset :=
  fun r02 r06 r07 => (congrArg Dataset.sha256 r06).symm.trans (r07.trans r02.symm)

axiom R03_axiom : R03

axiom R04_axiom : R04

/-- R02〜R05，R21，R22 から R01 を導く。 -/
theorem R01_of_R02_R03_R04_R05_R21_R22 (observedDataset : Dataset) (fetchedSha256 : String) (observedLoad : Load)
    (observedSplit : Split) (observedTrainIndex observedTestIndex : List ℕ) (observedFit : Fit)
    (observedFitInputSha256 loadedTrainRowsSha256 : String) (observedPredict : Predict)
    (observedPredictInputSha256 loadedTestFeaturesSha256 : String) (observedMse : Mse)
    (observedMseTargetSha256 loadedTestTargetSha256 observedMsePredictionSha256 observedPredictOutputSha256 : String)
    (observedEnvironment : Environment) (observedRepositoryCommit : String) (outputTestMse : ℚ)
    (fullRunDeclarationSha256s : List String) (verifiedDeclarationSha256 : String) (fullRunTestMses : List ℚ) :
    R02 fetchedSha256 → R03 → R04 →
    R05 observedDataset fetchedSha256 observedLoad observedSplit observedTrainIndex observedTestIndex
      observedFit observedFitInputSha256 loadedTrainRowsSha256 observedPredict observedPredictInputSha256
      loadedTestFeaturesSha256 observedMse observedMseTargetSha256 loadedTestTargetSha256 observedMsePredictionSha256
      observedPredictOutputSha256 observedEnvironment observedRepositoryCommit →
    R21 fullRunDeclarationSha256s verifiedDeclarationSha256 → R22 fullRunTestMses outputTestMse →
    R01 observedDataset fetchedSha256 observedLoad observedSplit observedTrainIndex observedTestIndex
      observedFit observedFitInputSha256 loadedTrainRowsSha256 observedPredict observedPredictInputSha256
      loadedTestFeaturesSha256 observedMse observedMseTargetSha256 loadedTestTargetSha256 observedMsePredictionSha256
      observedPredictOutputSha256 observedEnvironment observedRepositoryCommit outputTestMse
      fullRunDeclarationSha256s verifiedDeclarationSha256 fullRunTestMses :=
  fun r02 r03 r04 r05 r21 r22 => ⟨r02, r03, r04, r05, r21, r22⟩

/-- C01，R01 から C00 を導く。 -/
theorem C00_of_C01_R01 (observedDataset : Dataset) (fetchedSha256 : String) (observedLoad : Load)
    (observedSplit : Split) (observedTrainIndex observedTestIndex : List ℕ) (observedFit : Fit)
    (observedFitInputSha256 loadedTrainRowsSha256 : String) (observedPredict : Predict)
    (observedPredictInputSha256 loadedTestFeaturesSha256 : String) (observedMse : Mse)
    (observedMseTargetSha256 loadedTestTargetSha256 observedMsePredictionSha256 observedPredictOutputSha256 : String)
    (observedEnvironment : Environment) (observedRepositoryCommit : String) (outputTestMse : ℚ)
    (fullRunDeclarationSha256s : List String) (verifiedDeclarationSha256 : String) (fullRunTestMses : List ℚ) :
    C01 outputTestMse →
    R01 observedDataset fetchedSha256 observedLoad observedSplit observedTrainIndex observedTestIndex
      observedFit observedFitInputSha256 loadedTrainRowsSha256 observedPredict observedPredictInputSha256
      loadedTestFeaturesSha256 observedMse observedMseTargetSha256 loadedTestTargetSha256 observedMsePredictionSha256
      observedPredictOutputSha256 observedEnvironment observedRepositoryCommit outputTestMse
      fullRunDeclarationSha256s verifiedDeclarationSha256 fullRunTestMses →
    C00 observedDataset fetchedSha256 observedLoad observedSplit observedTrainIndex observedTestIndex
      observedFit observedFitInputSha256 loadedTrainRowsSha256 observedPredict observedPredictInputSha256
      loadedTestFeaturesSha256 observedMse observedMseTargetSha256 loadedTestTargetSha256 observedMsePredictionSha256
      observedPredictOutputSha256 observedEnvironment observedRepositoryCommit outputTestMse
      fullRunDeclarationSha256s verifiedDeclarationSha256 fullRunTestMses :=
  fun c01 r01 => ⟨c01, r01⟩

end Spec
