import 'package:flutter_test/flutter_test.dart';
import 'package:india_sdk/india_sdk.dart';
import 'package:india_sdk/india_sdk_platform_interface.dart';
import 'package:india_sdk/india_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIndiaSdkPlatform
    with MockPlatformInterfaceMixin
    implements IndiaSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final IndiaSdkPlatform initialPlatform = IndiaSdkPlatform.instance;

  test('$MethodChannelIndiaSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIndiaSdk>());
  });

  test('getPlatformVersion', () async {
    IndiaSdk indiaSdkPlugin = IndiaSdk();
    MockIndiaSdkPlatform fakePlatform = MockIndiaSdkPlatform();
    IndiaSdkPlatform.instance = fakePlatform;

    expect(await indiaSdkPlugin.getPlatformVersion(), '42');
  });
}
