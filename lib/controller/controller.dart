class Controller {
  static String formatDate(String date) {
    return date
        .substring(0, 10)
        .split('-')
        .reversed
        .join()
        .replaceAll('-', '/');
  }
}
