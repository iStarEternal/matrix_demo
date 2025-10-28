import 'package:flutter_test/flutter_test.dart';
import 'package:x_quad/x_quad.dart';
import 'package:x_quad/x_quad_platform_interface.dart';
import 'package:x_quad/x_quad_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockXQuadPlatform
    with MockPlatformInterfaceMixin
    implements XQuadPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final XQuadPlatform initialPlatform = XQuadPlatform.instance;

  test('$MethodChannelXQuad is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelXQuad>());
  });

  test('getPlatformVersion', () async {
    XQuad xQuadPlugin = XQuad();
    MockXQuadPlatform fakePlatform = MockXQuadPlatform();
    XQuadPlatform.instance = fakePlatform;

    expect(await xQuadPlugin.getPlatformVersion(), '42');
  });
}
