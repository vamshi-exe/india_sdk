import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'india_sdk_method_channel.dart';

abstract class IndiaSdkPlatform extends PlatformInterface {
  /// Constructs a IndiaSdkPlatform.
  IndiaSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static IndiaSdkPlatform _instance = MethodChannelIndiaSdk();

  /// The default instance of [IndiaSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelIndiaSdk].
  static IndiaSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IndiaSdkPlatform] when
  /// they register themselves.
  static set instance(IndiaSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
