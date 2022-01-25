import "dart:async";
import "dart:collection";

import "package:flutter/services.dart";

class SrvRecord {
  final String target;
  final int port;
  final int priority;
  final int weight;

  const SrvRecord({ required this.target, required this.port, required this.priority, required this.weight });
}

class Moxdns {
  static const MethodChannel _channel = MethodChannel("moxdns");

  static Future<List<SrvRecord>> srvQuery(String domain, bool dnssec) async {
    try {
      final List<dynamic> results = await _channel.invokeMethod("srvQuery", [ domain, dnssec ]);
    } on PlatformException catch(e) {
      return const [];
    }

    final records = List<SrvRecord>.empty(growable: true);
    for (var record in results) {
      if (record == null) {
        continue;
      }

      final rr = Map<String, String>.from(record);
      records.add(SrvRecord(
          target: rr["target"]!,
          port: int.parse(rr["port"]!),
          priority: int.parse(rr["priority"]!),
          weight: int.parse(rr["weight"]!)
      ));
    }

    return records;
  }
}
