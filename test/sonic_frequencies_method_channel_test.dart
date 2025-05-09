import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_frequencies/sonic_frequencies_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSonicFrequencies platform = MethodChannelSonicFrequencies();
  const MethodChannel channel = MethodChannel('sonic_frequencies');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getPlatformVersion':
              return '42';
            case 'generateTone':
            case 'generateSweep':
            case 'stopTone':
              return true;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('generateTone', () async {
    expect(await platform.generateTone(), true);
  });

  test('generateSweep', () async {
    expect(await platform.generateSweep(), true);
  });

  test('stopTone', () async {
    expect(await platform.stopTone(), true);
  });
}
