enum AuthMode { signup, login }

enum GameAction { finish, delete }

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

enum UrlType {
  //Login
  login,
  googleLogin,
  appleLogin,
  facebookLogin,
  //SignUp
  signup,
  resignup,
  resendemailverification,

  //Forgot password
  forgotPasswordRequest,
  verifyNewPassword,

  userProfileDataFetch,
  userProfileUpdate,
  userProfilePhotoUpdate,

  //New round
  courseList,
  createNewGameEntry,
  createGameShot,
  updateGameShot,
  updateLastShot,
  checkLastGameStatus,
  checkShotStatus,
  checkSavedCoursePrefilledDetails,
  checkGameDetailsByHole,
  deleteGame,

  //Fetch course by location
  courseListByLocation,

  //Fetch course in DB
  courseListFromDB,

  //Fetch round data
  fetchRoundDataForHome,
  //Fetch user game list
  fetchUserGame,

  //Fetch each round data
  fetchRoundScoreDetails,
  fetchRoundScoreResult,

  //Range
  fetchSubHeadings,
  fetchArticlesOfsubHeading,
}
