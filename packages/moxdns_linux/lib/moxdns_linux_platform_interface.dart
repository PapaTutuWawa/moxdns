import 'package:moxdns_linux/moxdns_linux_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class MoxdnsLinuxPlatform extends PlatformInterface {
  /// Constructs a MoxdnsLinuxPlatform.
  MoxdnsLinuxPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoxdnsLinuxPlatform _instance = MethodChannelMoxdnsLinux();

  /// The default instance of [MoxdnsLinuxPlatform] to use.
  ///
  /// Defaults to [MethodChannelMoxdnsLinux].
  static MoxdnsLinuxPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MoxdnsLinuxPlatform] when
  /// they register themselves.
  static set instance(MoxdnsLinuxPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
