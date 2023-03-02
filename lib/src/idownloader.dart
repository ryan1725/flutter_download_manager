import 'package:flutter/cupertino.dart';
import 'package:flutter_download_manager/src/http/custom_httpclient_impl.dart';

import '../flutter_download_manager.dart';
import 'download_status.dart';
import 'download_task.dart';
import 'downloader.dart';
import 'http/custom_dio_impl.dart';

abstract class DownloadCancelToken {
  bool get isCancelled => false;
  void cancel([dynamic reason]);
  dynamic get proxy;
}

abstract class IDownloader {
  factory IDownloader() => createObject(
        //customHttpClient: CustomDioImpl(),
        customHttpClient: CustomHttpClientImp(),
      );

  Future<void> download(
    String url,
    String savePath,
    DownloadCancelToken cancelToken, {
    bool forceDownload = false,
  });

  Future<DownloadTask?> addDownload(String url, String savedDir);

  Future<void> pauseDownload(String url);

  Future<void> cancelDownload(String url);

  Future<void> resumeDownload(String url);

  Future<void> removeDownload(String url);

  Future<DownloadStatus> whenDownloadComplete(String url,
      {Duration timeout = const Duration(hours: 2)});

  List<DownloadTask> getAllDownloads();

  DownloadTask? getDownload(String url);

  Future<void> addBatchDownloads(List<String> urls, String savedDir);

  List<DownloadTask?> getBatchDownloads(List<String> urls);

  Future<void> pauseBatchDownloads(List<String> urls);

  Future<void> cancelBatchDownloads(List<String> urls);

  Future<void> resumeBatchDownloads(List<String> urls);

  ValueNotifier<double> getBatchDownloadProgress(List<String> urls);

  Future<List<DownloadTask?>?> whenBatchDownloadsComplete(List<String> urls,
      {Duration timeout = const Duration(hours: 2)});

  String getFileNameFromUrl(String url);
}
