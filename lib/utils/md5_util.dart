import 'dart:convert';

import 'package:crypto/crypto.dart';

class Md5Util {
  static String md5Hash(String input) {
    final bytes = utf8.encode(input); // 字符串转为bytes
    final digest = md5.convert(bytes); // MD5计算
    return digest.toString(); // 转成16进制字符串
  }
}
