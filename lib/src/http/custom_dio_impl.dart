import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_download_manager/src/download_http_response.dart';
import 'package:flutter_download_manager/src/idownloader.dart';

import '../download_token_proxy.dart';
import 'custom_http_client.dart';

Dio dio = Dio();

class CustomDioImpl implements CustomHttpClient {
  @override
  Future<DownloadHttpResponse> download(
    String urlPath,
    String savePath, {
    DownloadProgressCallback? onReceiveProgress,
    DownloadCancelToken? cancelToken,
    Map<String, dynamic>? options,
  }) async {
    options ??= {};

    final deleteOnError = options.containsKey('deleteOnError') &&
        options['deleteOnError'] as bool;

    late Response response;
    if (options.containsKey('partialFileLength')) {
      final int partialFileLength = options.containsKey('partialFileLength')
          ? options['partialFileLength'] as int
          : 0;
      response = await dio.download(
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
      response = await dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        deleteOnError: deleteOnError,
        cancelToken: cancelToken?.proxy,
      );
    }
    return DownloadHttpResponse(response.statusCode ?? -1, response);
  }

  @override
  DownloadCancelToken generateToken() {
    return DownloadTokenProxy(CancelToken());
  }
}
