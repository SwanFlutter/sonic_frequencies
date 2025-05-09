import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sonic_frequencies/sonic_frequencies.dart';
import 'package:sonic_frequencies/sonic_frequencies_method_channel.dart';
import 'package:sonic_frequencies/sonic_frequencies_platform_interface.dart';

class MockSonicFrequenciesPlatform
    with MockPlatformInterfaceMixin
    implements SonicFrequenciesPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> generateTone({
    double frequency = 440.0,
    double volume = 1.0,
    int? duration,
  }) => Future.value(true);

  @override
  Future<bool> generateSweep({
    double startFrequency = 200.0,
    double endFrequency = 2000.0,
    int duration = 3000,
    double volume = 1.0,
  }) => Future.value(true);

  @override
  Future<bool> stopTone() => Future.value(true);
}

void main() {
  final SonicFrequenciesPlatform initialPlatform =
      SonicFrequenciesPlatform.instance;

  test('$MethodChannelSonicFrequencies is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSonicFrequencies>());
  });

  test('getPlatformVersion', () async {
    SonicFrequencies sonicFrequenciesPlugin = SonicFrequencies();
    MockSonicFrequenciesPlatform fakePlatform = MockSonicFrequenciesPlatform();
    SonicFrequenciesPlatform.instance = fakePlatform;

    expect(await sonicFrequenciesPlugin.getPlatformVersion(), '42');
  });

  test('generateTone', () async {
    SonicFrequencies sonicFrequenciesPlugin = SonicFrequencies();
    MockSonicFrequenciesPlatform fakePlatform = MockSonicFrequenciesPlatform();
    SonicFrequenciesPlatform.instance = fakePlatform;

    expect(await sonicFrequenciesPlugin.generateTone(), true);
  });

  test('generateSweep', () async {
    SonicFrequencies sonicFrequenciesPlugin = SonicFrequencies();
    MockSonicFrequenciesPlatform fakePlatform = MockSonicFrequenciesPlatform();
    SonicFrequenciesPlatform.instance = fakePlatform;

    expect(await sonicFrequenciesPlugin.generateSweep(), true);
  });

  test('stopTone', () async {
    SonicFrequencies sonicFrequenciesPlugin = SonicFrequencies();
    MockSonicFrequenciesPlatform fakePlatform = MockSonicFrequenciesPlatform();
    SonicFrequenciesPlatform.instance = fakePlatform;

    expect(await sonicFrequenciesPlugin.stopTone(), true);
  });
}
