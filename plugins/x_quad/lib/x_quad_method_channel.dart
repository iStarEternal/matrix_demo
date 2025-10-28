import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'x_quad_platform_interface.dart';

/// An implementation of [XQuadPlatform] that uses method channels.
class MethodChannelXQuad extends XQuadPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('x_quad');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
