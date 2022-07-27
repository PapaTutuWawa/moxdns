import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class SrvRecord {

  const SrvRecord(
    this.target, 
    this.port,
    this.priority,
    this.weight,
  );
  final String target;
  final int port;
  final int priority;
  final int weight;
}

abstract class MoxdnsPlatform extends PlatformInterface {

  MoxdnsPlatform() : super(token: _token);
  static final Object _token = Object();

  /// Perform the SRV query for [domain]. Use DNSSEC if [dnssec] is true.
  Future<List<SrvRecord>> srvQuery(String domain, bool dnssec);
}
