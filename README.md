# Sonic Frequencies

A Flutter plugin for generating sounds at different frequencies. This plugin can be used to create tones at specific frequencies, generate frequency sweeps, and produce ultrasonic sounds for purposes like repelling insects (mosquitoes, cockroaches, ants, etc.).

## Features

- Generate pure tones at specific frequencies (20Hz - 20,000Hz+)
- Create frequency sweeps from one frequency to another
- Control volume and duration of sounds
- Predefined frequencies for repelling various insects
- Works on both Android and iOS

<img src="https://github.com/user-attachments/assets/00ff91a3-9965-4d8f-bb11-79ea48ac6fbf" alt="Capture7" width="300">



## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  sonic_frequencies: ^0.0.1
```

## Usage

### Import the package

```dart
import 'package:sonic_frequencies/sonic_frequencies.dart';
```

### Initialize the plugin

```dart
final _sonicFrequenciesPlugin = SonicFrequencies();
```

### Generate a tone

```dart
// Generate a 440Hz tone (A4 note) at full volume for 3 seconds
await _sonicFrequenciesPlugin.generateTone(
  frequency: 440.0,
  volume: 1.0,
  duration: 3000,
);

// Generate a continuous tone (will play until stopped)
await _sonicFrequenciesPlugin.generateTone(
  frequency: 440.0,
  volume: 0.5,
);
```

### Generate a frequency sweep

```dart
// Generate a sweep from 200Hz to 2000Hz over 3 seconds
await _sonicFrequenciesPlugin.generateSweep(
  startFrequency: 200.0,
  endFrequency: 2000.0,
  duration: 3000,
  volume: 0.8,
);
```

### Stop any playing sound

```dart
await _sonicFrequenciesPlugin.stopTone();
```

## Insect Repellent Frequencies

The plugin can be used to generate ultrasonic frequencies that may help repel certain insects:

| Insect/Pest | Frequency (Hz) |
|-------------|---------------|
| Mosquitoes  | 18,000 - 22,000 |
| Flies       | 15,000 - 20,000 |
| Cockroaches | 20,000 - 25,000 |
| Ants        | 22,000 - 28,000 |
| Rodents     | 25,000 - 30,000 |

Example usage:

```dart
// Generate a tone to repel mosquitoes
await _sonicFrequenciesPlugin.generateTone(
  frequency: 18000.0,
  volume: 1.0,
);
```

**Note**: The effectiveness of ultrasonic repellents varies and depends on many factors including the device's speaker capabilities. Most mobile devices can produce frequencies up to around 20,000Hz, but the actual output may vary by device.

## Example App

Check out the example app in the `example` directory for a complete demonstration of all features, including:

- Tone generator with adjustable frequency, volume, and duration
- Frequency sweep generator
- Insect repellent presets
- Play/stop controls

## Platform Support

| Android | iOS |
|:-------:|:---:|
|    ✅    |  ✅  |


