import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'india_sdk_plugin_platform_interface.dart';

/// An implementation of [IndiaSdkPluginPlatform] that uses method channels.
class MethodChannelIndiaSdkPlugin extends IndiaSdkPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('india_sdk_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
