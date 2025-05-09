import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sonic_frequencies_platform_interface.dart';

/// An implementation of [SonicFrequenciesPlatform] that uses method channels.
class MethodChannelSonicFrequencies extends SonicFrequenciesPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sonic_frequencies');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<bool> generateTone({
    double frequency = 440.0,
    double volume = 1.0,
    int? duration,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('generateTone', {
      'frequency': frequency,
      'volume': volume,
      'duration': duration,
    });
    return result ?? false;
  }

  @override
  Future<bool> generateSweep({
    double startFrequency = 200.0,
    double endFrequency = 2000.0,
    int duration = 3000,
    double volume = 1.0,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('generateSweep', {
      'startFrequency': startFrequency,
      'endFrequency': endFrequency,
      'duration': duration,
      'volume': volume,
    });
    return result ?? false;
  }

  @override
  Future<bool> stopTone() async {
    final result = await methodChannel.invokeMethod<bool>('stopTone');
    return result ?? false;
  }
}
