import "package:moxdns/moxdns.dart";
import "package:moxdns_platform_interface/moxdns_platform_interface.dart";
import "package:flutter/services.dart";

class MoxdnsLinuxPlugin extends MoxdnsPlatform {
  final MethodChannel _channel;

  MoxdnsLinuxPlugin() : _channel = MethodChannel("me.polynom.moxdns_linux"), super();

  static void registerWith() {
    print("MoxdnsLinuxPlugin: Registering implementation");
    MoxdnsPlugin.platform = MoxdnsLinuxPlugin();
  }
  
  @override
  Future<List<SrvRecord>> srvQuery(String domain, bool dnssec) async {
    try {
      final List<dynamic> results = await _channel.invokeMethod("srvQuery", {
          "domain": domain,
          "dnssec": dnssec
      });
      final records = List<SrvRecord>.empty(growable: true);
      for (var record in results) {
        if (record == null) {
          continue;
        }
        final rr = Map<String, dynamic>.from(record);
        records.add(SrvRecord(
            rr["target"]!,
            rr["port"]! as int,
            rr["priority"]! as int,
            rr["weight"]! as int
        ));
      }
      return records;
    } on PlatformException catch(e) {
      print("moxdns_linux: $e");
      return const [];
    }
  }
}
