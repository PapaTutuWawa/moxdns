// ignore_for_file: avoid_print
import 'package:flutter/services.dart';
import 'package:moxdns/moxdns.dart';
import 'package:moxdns_platform_interface/moxdns_platform_interface.dart';

class MoxdnsLinuxPlugin extends MoxdnsPlatform {

  MoxdnsLinuxPlugin() : _channel = const MethodChannel('me.polynom.moxdns_linux'), super();
  final MethodChannel _channel;

  static void registerWith() {
    print('MoxdnsLinuxPlugin: Registering implementation');
    MoxdnsPlugin.platform = MoxdnsLinuxPlugin();
  }
  
  @override
  Future<List<SrvRecord>> srvQuery(String domain, bool dnssec) async {
    try {
      // TODO(PapaTutuWawa): Handle the result being null
      final results = (await _channel.invokeMethod<List<dynamic>>('srvQuery', {
          'domain': domain,
          'dnssec': dnssec
      }))!;
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
            rr['port']! as int,
            rr['priority']! as int,
            rr['weight']! as int,
          ),
        );
      }
      return records;
    } on PlatformException catch(e) {
      print('moxdns_linux: $e');
      return const [];
    }
  }
}
