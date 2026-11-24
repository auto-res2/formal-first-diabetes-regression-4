import Spec
import Proofs
import Values
open Spec Values
open Lean Elab Term in
elab "proved% " theoremName:ident : term => do
  let name ← realizeGlobalConstNoOverloadWithInfo theoremName
  if (← collectAxioms name).contains ``sorryAx then throwError "{name} は証明されていない"
  return mkConst name
/-! 各命題の判定。parse_claims.py が生成する。手で編集しない。 -/
axiom R02_axiom : R02 fetchedSha256
theorem R06_holds : R06 C03.value observedDataset := by decide +kernel
theorem R07_holds : R07 C03.value fetchedSha256 := by decide +kernel
theorem R09_holds : R09 C04.value observedLoad := by decide +kernel
theorem R10_holds : R10 C05.value observedSplit := by decide +kernel
theorem R11_holds : R11 C03.value observedTrainIndex observedTestIndex := by decide +kernel
theorem R12_holds : R12 C06.value observedFit := by decide +kernel
theorem R13_holds : R13 observedFitInputSha256 loadedTrainRowsSha256 := by decide +kernel
theorem R14_holds : R14 C07.value observedPredict := by decide +kernel
theorem R15_holds : R15 observedPredictInputSha256 loadedTestFeaturesSha256 := by decide +kernel
theorem R16_holds : R16 C08.value observedMse := by decide +kernel
theorem R17_holds : R17 observedMseTargetSha256 loadedTestTargetSha256 := by decide +kernel
theorem R18_holds : R18 observedMsePredictionSha256 observedPredictOutputSha256 := by decide +kernel
theorem R19_holds : R19 C09.value observedEnvironment := by decide +kernel
theorem R20_holds : R20 C10.value observedRepositoryCommit := by decide +kernel
theorem R21_holds : R21 fullRunDeclarationSha256s verifiedDeclarationSha256 := by decide +kernel
theorem R22_holds : R22 fullRunTestMses outputTestMse := by decide +kernel
theorem R08_holds : R08 observedDataset := R08_of_R02_R06_R07 _ _ R02_axiom R06_holds R07_holds
theorem R05_holds : R05 observedDataset fetchedSha256 observedLoad observedSplit observedTrainIndex observedTestIndex observedFit observedFitInputSha256 loadedTrainRowsSha256 observedPredict observedPredictInputSha256 loadedTestFeaturesSha256 observedMse observedMseTargetSha256 loadedTestTargetSha256 observedMsePredictionSha256 observedPredictOutputSha256 observedEnvironment observedRepositoryCommit := R05_of_R06_to_R20 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ R06_holds R07_holds R08_holds R09_holds R10_holds R11_holds R12_holds R13_holds R14_holds R15_holds R16_holds R17_holds R18_holds R19_holds R20_holds
theorem C01_fails : ¬ (C01 outputTestMse) := not_C01_of_C02 _ C02_holds (by decide +kernel)
theorem R01_holds : R01 observedDataset fetchedSha256 observedLoad observedSplit observedTrainIndex observedTestIndex observedFit observedFitInputSha256 loadedTrainRowsSha256 observedPredict observedPredictInputSha256 loadedTestFeaturesSha256 observedMse observedMseTargetSha256 loadedTestTargetSha256 observedMsePredictionSha256 observedPredictOutputSha256 observedEnvironment observedRepositoryCommit outputTestMse fullRunDeclarationSha256s verifiedDeclarationSha256 fullRunTestMses := R01_of_R02_R03_R04_R05_R21_R22 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ R02_axiom R03_axiom R04_axiom R05_holds R21_holds R22_holds
theorem C00_fails : ¬ (C00 observedDataset fetchedSha256 observedLoad observedSplit observedTrainIndex observedTestIndex observedFit observedFitInputSha256 loadedTrainRowsSha256 observedPredict observedPredictInputSha256 loadedTestFeaturesSha256 observedMse observedMseTargetSha256 loadedTestTargetSha256 observedMsePredictionSha256 observedPredictOutputSha256 observedEnvironment observedRepositoryCommit outputTestMse fullRunDeclarationSha256s verifiedDeclarationSha256 fullRunTestMses) := fun h => by first | exact (proved% C01_fails) h.1 | exact (proved% R01_fails) h.2
