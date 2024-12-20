import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'india_sdk_platform_interface.dart';

/// An implementation of [IndiaSdkPlatform] that uses method channels.
class MethodChannelIndiaSdk extends IndiaSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('india_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
