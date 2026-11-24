import Spec
/-! 検証済みの値。parse_claims.py が生成する。手で編集しない。 -/
namespace Values
open Spec
def outputTestMse : ℚ := ((8560648335746739 : ℚ) / 2500000000000)
def observedDataset : Dataset := { url := "https://www4.stat.ncsu.edu/~boos/var.select/diabetes.tab.txt", sha256 := "4733febee697862c22139cdac87478a300ce0d101593deb07ed6c0f3328a99cd", sampleCount := 442, featureCount := 10, featureColumns := ["AGE", "SEX", "BMI", "BP", "S1", "S2", "S3", "S4", "S5", "S6"], targetColumn := "Y" }
def fetchedSha256 : String := "4733febee697862c22139cdac87478a300ce0d101593deb07ed6c0f3328a99cd"
def observedLoad : Load := { functionName := "numpy.loadtxt", arguments := [("skiprows", "1")] }
def observedSplit : Split := { functionName := "sklearn.model_selection.train_test_split", arguments := [("test_size", "0.2"), ("random_state", "0")] }
def observedTrainIndex : List ℕ := [74, 26, 45, 389, 154, 4, 386, 225, 327, 264, 8, 190, 5, 371, 200, 313, 7, 325, 366, 22, 68, 437, 20, 353, 281, 14, 300, 240, 175, 405, 153, 75, 64, 55, 135, 329, 81, 316, 369, 328, 414, 421, 361, 415, 232, 224, 252, 254, 418, 106, 278, 63, 336, 378, 387, 430, 89, 93, 245, 272, 241, 92, 18, 145, 150, 322, 393, 297, 231, 66, 380, 412, 140, 101, 345, 247, 363, 17, 146, 315, 220, 30, 114, 235, 103, 219, 274, 176, 191, 116, 168, 367, 120, 218, 112, 303, 136, 308, 221, 126, 196, 332, 424, 133, 33, 419, 162, 34, 44, 97, 85, 61, 167, 199, 173, 229, 236, 433, 376, 250, 108, 407, 46, 357, 372, 263, 73, 137, 422, 246, 253, 29, 181, 374, 301, 51, 365, 391, 217, 432, 27, 2, 259, 156, 255, 417, 346, 138, 212, 104, 310, 306, 311, 215, 348, 189, 214, 35, 230, 204, 234, 293, 239, 210, 67, 24, 295, 216, 223, 129, 111, 166, 349, 40, 317, 79, 431, 350, 13, 364, 436, 228, 161, 83, 439, 416, 110, 149, 152, 16, 299, 109, 312, 139, 237, 260, 318, 355, 248, 342, 19, 269, 226, 340, 3, 309, 125, 280, 286, 77, 184, 354, 420, 275, 294, 384, 182, 395, 80, 307, 258, 11, 331, 86, 266, 36, 423, 58, 41, 270, 50, 209, 352, 351, 368, 123, 222, 62, 379, 130, 187, 23, 43, 0, 201, 377, 98, 304, 429, 178, 256, 94, 409, 95, 390, 169, 69, 305, 48, 341, 207, 279, 227, 148, 143, 334, 180, 356, 131, 425, 440, 262, 324, 203, 84, 121, 383, 406, 91, 82, 267, 119, 358, 291, 57, 321, 257, 394, 42, 105, 408, 273, 392, 38, 53, 385, 128, 290, 28, 183, 370, 163, 151, 244, 202, 31, 32, 127, 185, 413, 288, 398, 402, 147, 285, 410, 177, 99, 338, 335, 197, 243, 115, 404, 265, 72, 333, 25, 165, 337, 426, 174, 428, 39, 193, 314, 396, 88, 70, 87, 292, 242, 277, 211, 9, 359, 195, 251, 323, 192, 117, 47, 172]
def observedTestIndex : List ℕ := [362, 249, 271, 435, 400, 403, 12, 399, 198, 205, 78, 144, 298, 171, 268, 21, 194, 1, 10, 208, 76, 37, 388, 411, 289, 100, 261, 401, 319, 206, 375, 283, 373, 344, 287, 360, 179, 238, 434, 302, 158, 118, 339, 397, 330, 296, 164, 54, 157, 71, 284, 6, 343, 326, 159, 15, 320, 60, 282, 142, 56, 124, 107, 132, 382, 102, 160, 141, 186, 441, 90, 59, 347, 233, 427, 65, 438, 155, 122, 276, 188, 96, 170, 113, 381, 213, 134, 49, 52]
def observedFit : Fit := { functionName := "sklearn.linear_model.LinearRegression.fit", parameters := [("copy_X", "True"), ("fit_intercept", "True"), ("n_jobs", "None"), ("positive", "False"), ("tol", "1e-06")], featureCount := 10 }
def observedFitInputSha256 : String := "d57c74eecafecaa2ebde2ad29a8448d4d4ecc6a1fb2d29e9db8d2e9dbd5a07bb"
def loadedTrainRowsSha256 : String := "d57c74eecafecaa2ebde2ad29a8448d4d4ecc6a1fb2d29e9db8d2e9dbd5a07bb"
def observedPredict : Predict := { functionName := "sklearn.linear_model.LinearRegression.predict" }
def observedPredictInputSha256 : String := "5a4aff1d4cb89adddd50ccac97a5abfcfc7a6e27cc5a856b14bb56c9fb4f95ec"
def loadedTestFeaturesSha256 : String := "5a4aff1d4cb89adddd50ccac97a5abfcfc7a6e27cc5a856b14bb56c9fb4f95ec"
def observedMse : Mse := { functionName := "sklearn.metrics.mean_squared_error" }
def observedMseTargetSha256 : String := "cb71121e14086e4d121991039da2ae8799c362cbe11431dc80027189a9a19e18"
def loadedTestTargetSha256 : String := "cb71121e14086e4d121991039da2ae8799c362cbe11431dc80027189a9a19e18"
def observedMsePredictionSha256 : String := "11a35b4a2397fa5b85d846f3cbd50486e9dd9bc32f95e2675bb9d7e5da84da0c"
def observedPredictOutputSha256 : String := "11a35b4a2397fa5b85d846f3cbd50486e9dd9bc32f95e2675bb9d7e5da84da0c"
def observedEnvironment : Environment := { operatingSystem := "ubuntu-24.04", cpuArchitecture := "x86_64", cpuCount := 4, memoryGibibytes := 16 }
def observedRepositoryCommit : String := "156ce2c43a6ced9830f25e769e0d382184dbf674"
def fullRunDeclarationSha256s : List String := ["c8ed044ce368f359288d3a73daa32fa496cef073b305ecd83cb48d2384338444"]
def verifiedDeclarationSha256 : String := "c8ed044ce368f359288d3a73daa32fa496cef073b305ecd83cb48d2384338444"
def fullRunTestMses : List ℚ := [((8560648335746739 : ℚ) / 2500000000000)]
end Values
