import 'dart:io';

import 'package:dio/dio.dart';
import 'package:navatech/repositories/network/network_manger.dart';
import 'package:navatech/utils/logger.dart';
import 'package:uuid/uuid.dart';

class DioManager extends NetworkManager {
  static const tag = 'DioNetworkService';
  final Dio _dio;
  final _uuid = const Uuid();
  final _networkRequestMap = <String, CancelToken>{};
  static bool _isErrorCase(int? status) {
    final isUnauthorized = status == HttpStatus.unauthorized;
    final isLocked = status == HttpStatus.locked;
    final isSeeOther = status == HttpStatus.seeOther;

    return isUnauthorized || isLocked || isSeeOther;
  }

  DioManager()
      : _dio = Dio(
          BaseOptions(
            baseUrl: "https://jsonplaceholder.typicode.com",
            connectTimeout: const Duration(seconds: 5),
            sendTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
            validateStatus: (status) {
              final isOk = status == HttpStatus.ok;
              final isErrorCase = _isErrorCase(status);

              return isOk || isErrorCase;
            },
            responseType: ResponseType.json,
            contentType: Headers.jsonContentType,
          ),
        );

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onReceiveProgress,
  }) async {
    final key = _uuid.v4();

    final cancelToken = CancelToken();
    _networkRequestMap[key] = cancelToken;

    try {
      Logger.info('$tag: >>> [GET] $path');

      final sw = Stopwatch()..start();
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      sw.stop();

      _networkRequestMap.remove(key);

      Logger.info('$tag: <<< [${response.statusCode}] $path, took ${sw.elapsedMilliseconds} ms');
      return _handleResponse(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        Logger.info('$tag: <<< $path [Cancelled]');
        rethrow;
      }

      Logger.error('$tag: <<< $path threw error: $e');
      rethrow;
    } catch (e) {
      Logger.error('$tag: <<< $path threw error: $e');
      rethrow;
    }
  }

  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final key = _uuid.v4();

    final cancelToken = CancelToken();
    _networkRequestMap[key] = cancelToken;

    try {
      Logger.info('$tag: >>> [POST] $path');

      final sw = Stopwatch()..start();
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      sw.stop();

      _networkRequestMap.remove(key);

      Logger.info('$tag: <<< [${response.statusCode}] $path, took ${sw.elapsedMilliseconds} ms');
      return _handleResponse(response);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        Logger.info('$tag: <<< $path Cancelled');
        rethrow;
      }

      Logger.error('$tag: <<< $path threw error: $e');
      rethrow;
    } catch (e) {
      Logger.error('$tag: <<< $path threw error: $e');
      rethrow;
    }
  }

  Future<Response> _handleResponse(Response response) async {
    // we have got an error response, cancel all ongoing network requests
    if (_isErrorCase(response.statusCode)) {
      Logger.info('$tag: we got an error response, cancelling ongoing ${_networkRequestMap.length} requests');

      for (final item in _networkRequestMap.entries) {
        item.value.cancel();
      }

      // clear the entire map, no need to keep any record
      _networkRequestMap.clear();
      throw Exception("Invalid response, please try again after sometime");
    }

    return response;
  }
}
