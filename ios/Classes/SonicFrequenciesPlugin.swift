import Flutter
import UIKit
import AVFoundation

public class SonicFrequenciesPlugin: NSObject, FlutterPlugin {
  private var audioEngine: AVAudioEngine?
  private var toneGenerator: AVAudioSourceNode?
  private var isPlaying = false
  private var phase: Double = 0.0
  private var frequency: Double = 440.0
  private var startFrequency: Double = 200.0
  private var endFrequency: Double = 2000.0
  private var isSweep = false
  private var startTime: TimeInterval = 0.0
  private var sweepDuration: TimeInterval = 3.0
  private var volume: Double = 1.0

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sonic_frequencies", binaryMessenger: registrar.messenger())
    let instance = SonicFrequenciesPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "generateTone":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
        return
      }

      let frequency = args["frequency"] as? Double ?? 440.0
      let volume = args["volume"] as? Double ?? 1.0
      let duration = args["duration"] as? Int

      generateTone(frequency: frequency, volume: volume, duration: duration)
      result(true)
    case "stopTone":
      stopTone()
      result(true)
    case "generateSweep":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
        return
      }

      let startFrequency = args["startFrequency"] as? Double ?? 200.0
      let endFrequency = args["endFrequency"] as? Double ?? 2000.0
      let duration = args["duration"] as? Int ?? 3000
      let volume = args["volume"] as? Double ?? 1.0

      generateSweep(startFrequency: startFrequency, endFrequency: endFrequency, duration: duration, volume: volume)
      result(true)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func generateTone(frequency: Double, volume: Double, duration: Int?) {
    stopTone()

    self.frequency = frequency
    self.volume = volume
    self.isSweep = false

    setupAudioEngine()

    if let duration = duration {
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(duration)) { [weak self] in
        self?.stopTone()
      }
    }
  }

  private func generateSweep(startFrequency: Double, endFrequency: Double, duration: Int, volume: Double) {
    stopTone()

    self.startFrequency = startFrequency
    self.endFrequency = endFrequency
    self.sweepDuration = Double(duration) / 1000.0
    self.volume = volume
    self.isSweep = true
    self.startTime = AVAudioTime.now().timeIntervalSinceNow

    setupAudioEngine()

    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(duration)) { [weak self] in
      self?.stopTone()
    }
  }

  private func setupAudioEngine() {
    audioEngine = AVAudioEngine()

    let mainMixer = audioEngine!.mainMixerNode
    let outputFormat = mainMixer.outputFormat(forBus: 0)
    let sampleRate = outputFormat.sampleRate

    toneGenerator = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
      guard let self = self else { return noErr }

      let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)

      for frame in 0..<Int(frameCount) {
        let value: Float

        if self.isSweep {
          let currentTime = AVAudioTime.now().timeIntervalSinceNow - self.startTime
          let ratio = min(max(currentTime / self.sweepDuration, 0.0), 1.0)
          let currentFrequency = self.startFrequency + (self.endFrequency - self.startFrequency) * ratio

          self.phase += 2.0 * Double.pi * currentFrequency / sampleRate
          if self.phase > 2.0 * Double.pi {
            self.phase -= 2.0 * Double.pi
          }

          value = Float(sin(self.phase) * self.volume)
        } else {
          self.phase += 2.0 * Double.pi * self.frequency / sampleRate
          if self.phase > 2.0 * Double.pi {
            self.phase -= 2.0 * Double.pi
          }

          value = Float(sin(self.phase) * self.volume)
        }

        for buffer in ablPointer {
          let bufferPointer = UnsafeMutableBufferPointer<Float>(
            start: buffer.mData?.assumingMemoryBound(to: Float.self),
            count: Int(buffer.mDataByteSize) / MemoryLayout<Float>.size
          )
          bufferPointer[frame] = value
        }
      }

      return noErr
    }

    audioEngine!.attach(toneGenerator!)

    audioEngine!.connect(
      toneGenerator!,
      to: mainMixer,
      format: AVAudioFormat(
        commonFormat: .pcmFormatFloat32,
        sampleRate: sampleRate,
        channels: 1,
        interleaved: false
      )!
    )

    do {
      try audioEngine!.start()
      isPlaying = true
    } catch {
      print("Could not start audio engine: \(error)")
    }
  }

  private func stopTone() {
    if isPlaying {
      audioEngine?.stop()
      if let toneGenerator = toneGenerator {
        audioEngine?.detach(toneGenerator)
      }
      audioEngine = nil
      toneGenerator = nil
      isPlaying = false
    }
  }
}
