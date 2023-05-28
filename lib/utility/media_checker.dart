class MediaChecker {
  static bool isVideo(String path) {
    if (path.toLowerCase().contains('mp4') ||
        path.toLowerCase().contains('3gp') ||
        path.toLowerCase().contains('mkv') ||
        path.toLowerCase().contains('avi') ||
        path.toLowerCase().contains('webm') ||
        path.toLowerCase().contains('gif') ||
        path.toLowerCase().contains('wmv')) {
      return true;
    } else {
      return false;
    }
  }
}
