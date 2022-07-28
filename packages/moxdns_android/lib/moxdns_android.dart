// ignore_for_file: avoid_print
import 'package:flutter/services.dart';
import 'package:moxdns/moxdns.dart';
import 'package:moxdns_platform_interface/moxdns_platform_interface.dart';

class MoxdnsAndroidPlugin extends MoxdnsPlatform {

  MoxdnsAndroidPlugin()
    : _channel = const MethodChannel('me.polynom.moxdns_android'), super();
  final MethodChannel _channel;
  
  static void registerWith() {
    print('MoxdnsAndroidPlugin: Registering implementation');
    MoxdnsPlugin.platform = MoxdnsAndroidPlugin();
  }
  
  @override
  Future<List<SrvRecord>> srvQuery(String domain, bool dnssec) async {
    try {
      // TODO(PapaTutuWawa): Check for null
      final results = (await _channel.invokeMethod<List<dynamic>>('srvQuery', [ domain, dnssec ]))!;
      final records = List<SrvRecord>.empty(growable: true);
      for (final record in results) {
        if (record == null) {
          continue;
        }
        // ignore: argument_type_not_assignable
        final rr = Map<String, String>.from(record);
        records.add(
          SrvRecord(
            rr['target']!,
            int.parse(rr['port']!),
            int.parse(rr['priority']!),
            int.parse(rr['weight']!),
          ),
        );
      }
      return records;
    } on PlatformException catch(e) {
      print('moxdns_android: $e');
      return const [];
    }
  }
}
