import 'sonic_frequencies_platform_interface.dart';

/// A Flutter plugin for generating sonic frequencies.
///
/// This plugin allows you to generate tones at specific frequencies,
/// create frequency sweeps, and control playback.
///
/// Example usage:
/// ```dart
/// final sonicFrequencies = SonicFrequencies();
///
/// // Generate a tone at 440 Hz with full volume for 1 second
/// sonicFrequencies.generateTone(frequency: 440.0, volume: 1.0, duration: 1000);
///
/// // Generate a frequency sweep from 200 Hz to 2000 Hz over 3 seconds
/// sonicFrequencies.generateSweep(startFrequency: 200.0, endFrequency: 2000.0, duration: 3000);
///
/// // Stop any currently playing tone or sweep
/// sonicFrequencies.stopTone();
/// ```
class SonicFrequencies {
  /// Returns the platform version.
  Future<String?> getPlatformVersion() {
    return SonicFrequenciesPlatform.instance.getPlatformVersion();
  }

  /// Generates a tone with the specified frequency, volume, and duration.
  ///
  /// [frequency] - The frequency of the tone in Hz (default: 440.0)
  /// [volume] - The volume of the tone from 0.0 to 1.0 (default: 1.0)
  /// [duration] - The duration of the tone in milliseconds (optional, if null the tone plays until stopped)
  ///
  /// Returns a Future that completes with true if the tone generation was successful.
  ///
  /// Example:
  /// ```dart
  /// // Generate a tone at 1000 Hz with half volume for 2 seconds
  /// generateTone(frequency: 1000.0, volume: 0.5, duration: 2000);
  ///
  ///
  /// ```
  Future<bool> generateTone({
    double frequency = 440.0,
    double volume = 1.0,
    int? duration,
  }) {
    return SonicFrequenciesPlatform.instance.generateTone(
      frequency: frequency,
      volume: volume,
      duration: duration,
    );
  }

  /// Generates a frequency sweep from startFrequency to endFrequency.
  ///
  /// [startFrequency] - The starting frequency in Hz (default: 200.0)
  /// [endFrequency] - The ending frequency in Hz (default: 2000.0)
  /// [duration] - The duration of the sweep in milliseconds (default: 3000)
  /// [volume] - The volume of the sweep from 0.0 to 1.0 (default: 1.0)
  ///
  /// Returns a Future that completes with true if the sweep generation was successful.
  ///
  /// Example:
  /// ```dart
  /// // Generate a sweep from 500 Hz to 1500 Hz over 5 seconds with 70% volume
  /// generateSweep(startFrequency: 500.0, endFrequency: 1500.0, duration: 5000, volume: 0.7);
  ///
  ///
  /// ```
  Future<bool> generateSweep({
    double startFrequency = 200.0,
    double endFrequency = 2000.0,
    int duration = 3000,
    double volume = 1.0,
  }) {
    return SonicFrequenciesPlatform.instance.generateSweep(
      startFrequency: startFrequency,
      endFrequency: endFrequency,
      duration: duration,
      volume: volume,
    );
  }

  /// Stops any currently playing tone or sweep.
  ///
  /// Returns a Future that completes with true if the tone was successfully stopped.
  ///
  /// Example:
  /// ```dart
  /// // Stop the currently playing tone or sweep
  /// stopTone();
  ///
  ///
  /// ```
  Future<bool> stopTone() {
    return SonicFrequenciesPlatform.instance.stopTone();
  }
}
