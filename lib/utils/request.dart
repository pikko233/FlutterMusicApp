import 'package:dio/dio.dart';
import 'package:flutter_music_app/constants/app_config.dart';
import 'package:flutter_music_app/utils/toast_util.dart';
import 'package:flutter_music_app/utils/user_storage.dart';

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
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final cookie = await UserStorage.getCookie();
              if (cookie != null) options.headers['Cookie'] = cookie;
              handler.next(options);
            },
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
          LogInterceptor(requestBody: true, responseBody: true),
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

  // 不经过 code 拦截器，用于 QR 轮询等需要读取非 200 状态码的接口
  static final _rawDio =
      Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: const Duration(milliseconds: 10000),
            receiveTimeout: const Duration(milliseconds: 10000),
          ),
        )
        ..interceptors.addAll([
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final cookie = await UserStorage.getCookie();
              if (cookie != null) options.headers['Cookie'] = cookie;
              handler.next(options);
            },
          ),
          LogInterceptor(requestBody: true, responseBody: true),
        ]);

  static Future<Response> getRaw(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    return await _rawDio.get(path, queryParameters: params);
  }
}
