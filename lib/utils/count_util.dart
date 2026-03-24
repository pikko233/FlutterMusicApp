import 'package:intl/intl.dart';

class CountUtil {
  static String formatCount(int count) {
    if (count >= 100000000) {
      return '${_format(count / 100000000)}亿';
    } else if (count >= 10000) {
      return '${_format(count / 10000)}万';
    } else {
      return NumberFormat('#,###').format(count);
    }
  }

  static String _format(double value) {
    // 去掉尾部多余的.0 比如1.0亿 转为 1亿
    return value == value.truncate()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }
}
