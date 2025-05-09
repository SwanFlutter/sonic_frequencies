import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sonic_frequencies_method_channel.dart';

abstract class SonicFrequenciesPlatform extends PlatformInterface {
  /// Constructs a SonicFrequenciesPlatform.
  SonicFrequenciesPlatform() : super(token: _token);

  static final Object _token = Object();

  static SonicFrequenciesPlatform _instance = MethodChannelSonicFrequencies();

  /// The default instance of [SonicFrequenciesPlatform] to use.
  ///
  /// Defaults to [MethodChannelSonicFrequencies].
  static SonicFrequenciesPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SonicFrequenciesPlatform] when
  /// they register themselves.
  static set instance(SonicFrequenciesPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Generates a tone with the specified frequency, volume, and duration.
  ///
  /// [frequency] - The frequency of the tone in Hz (default: 440.0)
  /// [volume] - The volume of the tone from 0.0 to 1.0 (default: 1.0)
  /// [duration] - The duration of the tone in milliseconds (optional, if null the tone plays until stopped)
  Future<bool> generateTone({
    double frequency = 440.0,
    double volume = 1.0,
    int? duration,
  }) {
    throw UnimplementedError('generateTone() has not been implemented.');
  }

  /// Generates a frequency sweep from startFrequency to endFrequency.
  ///
  /// [startFrequency] - The starting frequency in Hz (default: 200.0)
  /// [endFrequency] - The ending frequency in Hz (default: 2000.0)
  /// [duration] - The duration of the sweep in milliseconds (default: 3000)
  /// [volume] - The volume of the sweep from 0.0 to 1.0 (default: 1.0)
  Future<bool> generateSweep({
    double startFrequency = 200.0,
    double endFrequency = 2000.0,
    int duration = 3000,
    double volume = 1.0,
  }) {
    throw UnimplementedError('generateSweep() has not been implemented.');
  }

  /// Stops any currently playing tone or sweep.
  Future<bool> stopTone() {
    throw UnimplementedError('stopTone() has not been implemented.');
  }
}
