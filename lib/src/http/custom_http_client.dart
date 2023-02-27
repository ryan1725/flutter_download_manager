import '../idownloader.dart';

typedef DownloadProgressCallback = Function(int count, int total);

abstract class CustomHttpClient {
  Future<dynamic> download(
    String urlPath,
    String savePath, {
    DownloadProgressCallback? onReceiveProgress,
    DownloadCancelToken? cancelToken,
    Map<String, dynamic> options,
  });

  DownloadCancelToken generateToken();
}
