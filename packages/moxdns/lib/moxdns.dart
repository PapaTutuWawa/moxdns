import 'package:moxdns_platform_interface/moxdns_platform_interface.dart';
export 'package:moxdns_platform_interface/moxdns_platform_interface.dart' show SrvRecord;

class MoxdnsStubPlugin extends MoxdnsPlatform {
  @override
  Future<List<SrvRecord>> srvQuery(String domain, bool dnssec) async => const [];
}

abstract class MoxdnsPlugin {
  static MoxdnsPlatform platform = MoxdnsStubPlugin();

  /// Perform a DNS SRV query for [domain], optionally using DNSSEC if [dnssec] is true.
  /// The order of the results is abitrary.
  static Future<List<SrvRecord>> srvQuery(String domain, bool dnssec) async {
    return platform.srvQuery(domain, dnssec);
  }
}
