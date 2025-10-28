import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'x_quad_method_channel.dart';

abstract class XQuadPlatform extends PlatformInterface {
  /// Constructs a XQuadPlatform.
  XQuadPlatform() : super(token: _token);

  static final Object _token = Object();

  static XQuadPlatform _instance = MethodChannelXQuad();

  /// The default instance of [XQuadPlatform] to use.
  ///
  /// Defaults to [MethodChannelXQuad].
  static XQuadPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [XQuadPlatform] when
  /// they register themselves.
  static set instance(XQuadPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
