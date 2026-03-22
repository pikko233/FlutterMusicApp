class TimeUtil {
  TimeUtil._();
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "$minutes:$seconds";
  }
}
