
import 'india_sdk_plugin_platform_interface.dart';

class IndiaSdkPlugin {
  Future<String?> getPlatformVersion() {
    return IndiaSdkPluginPlatform.instance.getPlatformVersion();
  }
}
