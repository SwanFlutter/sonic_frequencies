import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sonic_frequencies/sonic_frequencies.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _sonicFrequenciesPlugin = SonicFrequencies();
  bool _isPlaying = false;
  double _frequency = 440.0;
  double _volume = 1.0;
  int _duration = 3000;
  double _startFrequency = 200.0;
  double _endFrequency = 2000.0;

  // Predefined frequencies for repelling different insects
  final Map<String, double> _insectFrequencies = {
    'Mosquitoes': 18000.0,
    'Flies': 15000.0,
    'Cockroaches': 20000.0,
    'Ants': 22000.0,
    'Rodents': 25000.0,
  };

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _stopTone();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _sonicFrequenciesPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _generateTone() async {
    if (_isPlaying) {
      await _stopTone();
    }

    try {
      final result = await _sonicFrequenciesPlugin.generateTone(
        frequency: _frequency,
        volume: _volume,
        duration: _duration,
      );

      setState(() {
        _isPlaying = result;
      });
    } on PlatformException catch (e) {
      debugPrint('Error generating tone: ${e.message}');
    }
  }

  Future<void> _generateSweep() async {
    if (_isPlaying) {
      await _stopTone();
    }

    try {
      final result = await _sonicFrequenciesPlugin.generateSweep(
        startFrequency: _startFrequency,
        endFrequency: _endFrequency,
        duration: _duration,
        volume: _volume,
      );

      setState(() {
        _isPlaying = result;
      });
    } on PlatformException catch (e) {
      debugPrint('Error generating sweep: ${e.message}');
    }
  }

  Future<void> _stopTone() async {
    try {
      final result = await _sonicFrequenciesPlugin.stopTone();
      setState(() {
        _isPlaying = !result;
      });
    } on PlatformException catch (e) {
      debugPrint('Error stopping tone: ${e.message}');
    }
  }

  Future<void> _playInsectRepellent(String insectType) async {
    if (_isPlaying) {
      await _stopTone();
    }

    final frequency = _insectFrequencies[insectType] ?? 440.0;

    try {
      final result = await _sonicFrequenciesPlugin.generateTone(
        frequency: frequency,
        volume: _volume,
      );

      setState(() {
        _isPlaying = result;
        _frequency = frequency;
      });
    } on PlatformException catch (e) {
      debugPrint('Error generating tone: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sonic Frequencies'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Running on: $_platformVersion'),
              const SizedBox(height: 20),

              // Tone Generator Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tone Generator',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Frequency Slider
                      Row(
                        children: [
                          const Text('Frequency (Hz): '),
                          Expanded(
                            child: Slider(
                              value: _frequency,
                              min: 20.0,
                              max: 20000.0,
                              onChanged: (value) {
                                setState(() {
                                  _frequency = value;
                                });
                              },
                            ),
                          ),
                          Text(_frequency.toStringAsFixed(1)),
                        ],
                      ),

                      // Volume Slider
                      Row(
                        children: [
                          const Text('Volume: '),
                          Expanded(
                            child: Slider(
                              value: _volume,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (value) {
                                setState(() {
                                  _volume = value;
                                });
                              },
                            ),
                          ),
                          Text(_volume.toStringAsFixed(2)),
                        ],
                      ),

                      // Duration Slider
                      Row(
                        children: [
                          const Text('Duration (ms): '),
                          Expanded(
                            child: Slider(
                              value: _duration.toDouble(),
                              min: 100.0,
                              max: 10000.0,
                              onChanged: (value) {
                                setState(() {
                                  _duration = value.toInt();
                                });
                              },
                            ),
                          ),
                          Text(_duration.toString()),
                        ],
                      ),

                      // Tone Control Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _generateTone,
                            child: const Text('Play Tone'),
                          ),
                          ElevatedButton(
                            onPressed: _stopTone,
                            child: const Text('Stop'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Sweep Generator Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Frequency Sweep',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Start Frequency Slider
                      Row(
                        children: [
                          const Text('Start (Hz): '),
                          Expanded(
                            child: Slider(
                              value: _startFrequency,
                              min: 20.0,
                              max: 20000.0,
                              onChanged: (value) {
                                setState(() {
                                  _startFrequency = value;
                                });
                              },
                            ),
                          ),
                          Text(_startFrequency.toStringAsFixed(1)),
                        ],
                      ),

                      // End Frequency Slider
                      Row(
                        children: [
                          const Text('End (Hz): '),
                          Expanded(
                            child: Slider(
                              value: _endFrequency,
                              min: 20.0,
                              max: 20000.0,
                              onChanged: (value) {
                                setState(() {
                                  _endFrequency = value;
                                });
                              },
                            ),
                          ),
                          Text(_endFrequency.toStringAsFixed(1)),
                        ],
                      ),

                      // Sweep Control Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _generateSweep,
                          child: const Text('Play Sweep'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Insect Repellent Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Insect Repellent Frequencies',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Insect Repellent Buttons
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children:
                            _insectFrequencies.keys.map((insect) {
                              return ElevatedButton(
                                onPressed: () => _playInsectRepellent(insect),
                                child: Text('Repel $insect'),
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Status and Controls
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Status: ${_isPlaying ? "Playing" : "Stopped"}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isPlaying ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_isPlaying)
                        ElevatedButton(
                          onPressed: _stopTone,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('STOP ALL SOUNDS'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
