import "package:moxdns/moxdns.dart";
import "package:moxdns_platform_interface/moxdns_platform_interface.dart";
import "package:flutter/services.dart";

class MoxdnsAndroidPlugin extends MoxdnsPlatform {
  final MethodChannel _channel;

  MoxdnsAndroidPlugin() : _channel = MethodChannel("me.polynom.moxdns_android"), super();

  static void registerWith() {
    print("MoxdnsAndroidPlugin: Registering implementation");
    MoxdnsPlugin.platform = MoxdnsAndroidPlugin();
  }
  
  @override
  Future<List<SrvRecord>> srvQuery(String domain, bool dnssec) async {
    try {
      final List<dynamic> results = await _channel.invokeMethod("srvQuery", [ domain, dnssec ]);
      final records = List<SrvRecord>.empty(growable: true);
      for (var record in results) {
        if (record == null) {
          continue;
        }
        final rr = Map<String, String>.from(record);
        records.add(SrvRecord(
            rr["target"]!,
            int.parse(rr["port"]!),
            int.parse(rr["priority"]!),
            int.parse(rr["weight"]!)
        ));
      }
      return records;
    } on PlatformException catch(e) {
      print("moxdns_android: $e");
      return const [];
    }
  }
}
