import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'moxdns_linux_platform_interface.dart';

/// An implementation of [MoxdnsLinuxPlatform] that uses method channels.
class MethodChannelMoxdnsLinux extends MoxdnsLinuxPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('moxdns_linux');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
