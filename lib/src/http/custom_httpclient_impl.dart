import 'dart:io';

import 'package:flutter_download_manager/src/download_http_response.dart';
import 'package:flutter_download_manager/src/http/custom_http_client.dart';
import 'package:flutter_download_manager/src/idownloader.dart';

class CustomHttpClientImp implements CustomHttpClient {
  @override
  Future<DownloadHttpResponse> download(String urlPath, String savePath,
      {DownloadProgressCallback? onReceiveProgress,
      DownloadCancelToken? cancelToken,
      Map<String, dynamic>? options}) async {
    options ??= {};

    final int partialFileLength = options.containsKey('partialFileLength')
        ? options['partialFileLength'] as int
        : 0;
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(urlPath));
    if (partialFileLength != 0) {
      request.headers.set(HttpHeaders.rangeHeader, "bytes=$partialFileLength-");
    }

    final response = await request.close();
    final totalBytes = response.contentLength;

    var bytesReceived = 0;
    var file = File(savePath);
    var sink = file.openWrite();

    await for (var chunk in response) {
      if (cancelToken != null && cancelToken.isCancelled) {
        await sink.flush();
        await sink.close();
        //await file.delete();
        throw Exception('Download cancelled');
        //return DownloadHttpResponse(response.statusCode, response)
      } else {}

      bytesReceived += chunk.length;
      sink.add(chunk);

      if (onReceiveProgress != null) {
        onReceiveProgress(bytesReceived, totalBytes);
      }
    }

    await sink.flush();
    await sink.close();
    return DownloadHttpResponse(response.statusCode, response);
  }

  @override
  DownloadCancelToken generateToken() {
    return HttpClientCancelToken();
  }
}

class HttpClientCancelToken implements DownloadCancelToken {
  bool _isCancelled = false;

  bool get isCancelled => _isCancelled;

  void cancel([reason]) {
    _isCancelled = true;
  }

  @override
  get proxy => this;
}
