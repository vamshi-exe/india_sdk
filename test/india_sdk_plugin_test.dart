import 'package:flutter_test/flutter_test.dart';
import 'package:india_sdk_plugin/india_sdk_plugin.dart';
import 'package:india_sdk_plugin/india_sdk_plugin_platform_interface.dart';
import 'package:india_sdk_plugin/india_sdk_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIndiaSdkPluginPlatform
    with MockPlatformInterfaceMixin
    implements IndiaSdkPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IndiaSdkPluginPlatform initialPlatform = IndiaSdkPluginPlatform.instance;

  test('$MethodChannelIndiaSdkPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIndiaSdkPlugin>());
  });

  test('getPlatformVersion', () async {
    IndiaSdkPlugin indiaSdkPlugin = IndiaSdkPlugin();
    MockIndiaSdkPluginPlatform fakePlatform = MockIndiaSdkPluginPlatform();
    IndiaSdkPluginPlatform.instance = fakePlatform;

    expect(await indiaSdkPlugin.getPlatformVersion(), '42');
  });
}
