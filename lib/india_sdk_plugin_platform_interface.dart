import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'india_sdk_plugin_method_channel.dart';

abstract class IndiaSdkPluginPlatform extends PlatformInterface {
  /// Constructs a IndiaSdkPluginPlatform.
  IndiaSdkPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static IndiaSdkPluginPlatform _instance = MethodChannelIndiaSdkPlugin();

  /// The default instance of [IndiaSdkPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelIndiaSdkPlugin].
  static IndiaSdkPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IndiaSdkPluginPlatform] when
  /// they register themselves.
  static set instance(IndiaSdkPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
