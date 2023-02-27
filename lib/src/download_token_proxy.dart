
import 'idownloader.dart';

class DownloadTokenProxy implements DownloadCancelToken {
  @override
  dynamic proxy;

  DownloadTokenProxy(this.proxy);

  @override
  void cancel([reason]) {
    if (proxy != null) {
      Function.apply(proxy?.cancel, [reason]);
    }
  }
}
