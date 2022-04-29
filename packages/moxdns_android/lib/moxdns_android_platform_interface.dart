import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'moxdns_android_method_channel.dart';

abstract class MoxdnsAndroidPlatform extends PlatformInterface {
  /// Constructs a MoxdnsAndroidPlatform.
  MoxdnsAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoxdnsAndroidPlatform _instance = MethodChannelMoxdnsAndroid();

  /// The default instance of [MoxdnsAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelMoxdnsAndroid].
  static MoxdnsAndroidPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MoxdnsAndroidPlatform] when
  /// they register themselves.
  static set instance(MoxdnsAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
