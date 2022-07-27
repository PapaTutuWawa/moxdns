import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:moxdns_android/moxdns_android_platform_interface.dart';

/// An implementation of [MoxdnsAndroidPlatform] that uses method channels.
class MethodChannelMoxdnsAndroid extends MoxdnsAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('moxdns_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
