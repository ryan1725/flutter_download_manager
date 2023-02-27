import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_download_manager/src/idownloader.dart';

import '../download_token_proxy.dart';
import 'custom_http_client.dart';

Dio dio = Dio();

class CustomHttpClientImpl implements CustomHttpClient {
  @override
  Future<Response> download(
    String urlPath,
    String savePath, {
    DownloadProgressCallback? onReceiveProgress,
    DownloadCancelToken? cancelToken,
    Map<String, dynamic>? options,
  }) async {
    options ??= {};

    final deleteOnError = options.containsKey('deleteOnError') &&
        options['deleteOnError'] as bool;

    if (options.containsKey('partialFileLength')) {
      final int partialFileLength = options.containsKey('partialFileLength')
          ? options['partialFileLength'] as int
          : 0;
      return dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: {HttpHeaders.rangeHeader: 'bytes=$partialFileLength-'},
        ),
        deleteOnError: deleteOnError,
        cancelToken: cancelToken?.proxy,
      );
    } else {
      return dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        deleteOnError: deleteOnError,
        cancelToken: cancelToken?.proxy,
      );
    }
  }

  @override
  DownloadCancelToken generateToken() {
    return DownloadTokenProxy(CancelToken());
  }
}
