# Sonic Frequencies Example

This example app demonstrates how to use the sonic_frequencies plugin to generate tones, frequency sweeps, and ultrasonic sounds for repelling insects.

## Features

The example app showcases all the features of the sonic_frequencies plugin:

### Tone Generator
- Generate pure tones at any frequency between 20Hz and 20,000Hz
- Adjust volume (0.0 to 1.0)
- Set duration in milliseconds
- Play and stop controls

### Frequency Sweep Generator
- Create sweeps from one frequency to another
- Adjust start and end frequencies
- Control duration and volume
- Visualize the sweep effect

### Insect Repellent Presets
- One-touch buttons for generating frequencies to repel:
  - Mosquitoes (18,000Hz)
  - Flies (15,000Hz)
  - Cockroaches (20,000Hz)
  - Ants (22,000Hz)
  - Rodents (25,000Hz)

### Status Display
- Shows whether sound is currently playing
- Emergency stop button for all sounds

## Running the Example

1. Connect your device or start an emulator
2. Navigate to the example directory
3. Run the app:

```bash
flutter run
```

## Notes

- Ultrasonic frequencies (above 20,000Hz) may not be audible to humans but can still be effective for repelling insects
- The actual output frequency depends on your device's speaker capabilities
- Some devices may not be able to produce frequencies at the upper range
- For best results with insect repellent frequencies, use a device with good speaker quality

## Getting Started with Flutter

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
