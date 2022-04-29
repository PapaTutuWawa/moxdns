import "package:plugin_platform_interface/plugin_platform_interface.dart";

class SrvRecord {
  final String target;
  final int port;
  final int priority;
  final int weight;

  const SrvRecord(
    this.target, 
    this.port,
    this.priority,
    this.weight
  );
}

abstract class MoxdnsPlatform extends PlatformInterface {
  static final Object _token = Object();

  MoxdnsPlatform() : super(token: _token);

  /// Perform the SRV query for [domain]. Use DNSSEC if [dnssec] is true.
  Future<List<SrvRecord>> srvQuery(String domain, bool dnssec);
}
