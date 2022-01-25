import "package:flutter/material.dart";
import "dart:async";
import "dart:io";

import "package:moxdns/moxdns.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    performLookup();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> performLookup() async {
    final records = await Moxdns.srvQuery("_xmpps-client._tcp.server.example", false);
    // ignore: avoid_print
    print("Got ${records.length.toString()} records");

    if (records.isNotEmpty) {
      final addrs = await InternetAddress.lookup(records[0].target);
      for (var addr in addrs) {
        // ignore: avoid_print
        print(addr.address);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
