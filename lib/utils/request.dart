import 'package:dio/dio.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_music_app/constants/app_config.dart';
import 'package:flutter_music_app/utils/toast_util.dart';

class Request {
  static final _dio =
      Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            sendTimeout: const Duration(milliseconds: 10000),
            connectTimeout: const Duration(milliseconds: 10000),
            receiveTimeout: const Duration(milliseconds: 10000),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.addAll([
          LogInterceptor(
            requestBody: true,
            responseBody: true,
          ), // 打印请求信息和响应信息，方便调试
          InterceptorsWrapper(
            onRequest: (options, handler) => handler.next(options),
            onResponse: (response, handler) {
              if (response.data?['code'] == 200) {
                return handler.next(response);
              } else {
                ToastUtil.showToast(response.data?['message'] ?? '操作失败');
                handler.reject(
                  DioException(requestOptions: response.requestOptions),
                );
              }
            },
            onError: (error, handler) {
              print('error: $error');
              ToastUtil.showToast(error.response?.data?['message'] ?? '操作失败');
              handler.next(error);
            },
          ),
        ]);

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    return await _dio.get(path, queryParameters: params);
  }

  static Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
}
