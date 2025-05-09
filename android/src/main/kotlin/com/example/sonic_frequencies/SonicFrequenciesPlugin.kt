package com.example.sonic_frequencies

import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.math.PI
import kotlin.math.sin

/** SonicFrequenciesPlugin */
class SonicFrequenciesPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private var audioTrack: AudioTrack? = null
  private var isPlaying = false
  private val handler = Handler(Looper.getMainLooper())
  private var generationThread: Thread? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sonic_frequencies")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "generateTone" -> {
        val frequency = call.argument<Double>("frequency") ?: 440.0
        val volume = call.argument<Double>("volume") ?: 1.0
        val duration = call.argument<Int>("duration")

        generateTone(frequency, volume, duration)
        result.success(true)
      }
      "stopTone" -> {
        stopTone()
        result.success(true)
      }
      "generateSweep" -> {
        val startFrequency = call.argument<Double>("startFrequency") ?: 200.0
        val endFrequency = call.argument<Double>("endFrequency") ?: 2000.0
        val duration = call.argument<Int>("duration") ?: 3000
        val volume = call.argument<Double>("volume") ?: 1.0

        generateSweep(startFrequency, endFrequency, duration, volume)
        result.success(true)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun generateTone(frequency: Double, volume: Double, duration: Int?) {
    try {
      stopTone()

      // Ensure frequency is within a reasonable range
      val safeFrequency = frequency.coerceIn(20.0, 22000.0)

      val sampleRate = 44100
      val bufferSize = AudioTrack.getMinBufferSize(
        sampleRate,
        AudioFormat.CHANNEL_OUT_MONO,
        AudioFormat.ENCODING_PCM_16BIT
      )

      audioTrack = AudioTrack.Builder()
        .setAudioAttributes(
          AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_MEDIA)
            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
            .build()
        )
        .setAudioFormat(
          AudioFormat.Builder()
            .setSampleRate(sampleRate)
            .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
            .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
            .build()
        )
        .setBufferSizeInBytes(bufferSize)
        .setTransferMode(AudioTrack.MODE_STREAM)
        .build()

      audioTrack?.play()
      isPlaying = true

      generationThread = Thread {
        val buffer = ShortArray(bufferSize)
        var phase = 0.0
        val twoPi = 2.0 * PI
        val phaseIncrement = twoPi * safeFrequency / sampleRate
        val maxVolume = Short.MAX_VALUE * volume.coerceIn(0.0, 1.0)

        val startTime = System.currentTimeMillis()

        while (isPlaying && (duration == null || System.currentTimeMillis() - startTime < duration)) {
          for (i in buffer.indices) {
            buffer[i] = (sin(phase) * maxVolume).toInt().coerceIn(Short.MIN_VALUE.toInt(), Short.MAX_VALUE.toInt()).toShort()
            phase += phaseIncrement
            if (phase > twoPi) {
              phase -= twoPi
            }
          }
          audioTrack?.write(buffer, 0, buffer.size)
        }

        if (duration != null && isPlaying) {
          handler.post { stopTone() }
        }
      }

      generationThread?.start()
    } catch (e: Exception) {
      // Log the error and ensure resources are cleaned up
      println("Error in generateTone: ${e.message}")
      e.printStackTrace()
      stopTone()
    }
  }

  private fun generateSweep(startFrequency: Double, endFrequency: Double, duration: Int, volume: Double) {
    try {
      stopTone()

      // Ensure frequencies are within a reasonable range
      val safeStartFrequency = startFrequency.coerceIn(20.0, 22000.0)
      val safeEndFrequency = endFrequency.coerceIn(20.0, 22000.0)
      val safeDuration = duration.coerceAtLeast(100) // Ensure duration is at least 100ms

      val sampleRate = 44100
      val bufferSize = AudioTrack.getMinBufferSize(
        sampleRate,
        AudioFormat.CHANNEL_OUT_MONO,
        AudioFormat.ENCODING_PCM_16BIT
      )

      audioTrack = AudioTrack.Builder()
        .setAudioAttributes(
          AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_MEDIA)
            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
            .build()
        )
        .setAudioFormat(
          AudioFormat.Builder()
            .setSampleRate(sampleRate)
            .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
            .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
            .build()
        )
        .setBufferSizeInBytes(bufferSize)
        .setTransferMode(AudioTrack.MODE_STREAM)
        .build()

      audioTrack?.play()
      isPlaying = true

      generationThread = Thread {
        val buffer = ShortArray(bufferSize)
        var phase = 0.0
        val twoPi = 2.0 * PI
        val maxVolume = Short.MAX_VALUE * volume.coerceIn(0.0, 1.0)

        val startTime = System.currentTimeMillis()
        val totalTime = safeDuration.toDouble()

        while (isPlaying && System.currentTimeMillis() - startTime < safeDuration) {
          val elapsedTime = System.currentTimeMillis() - startTime
          val ratio = elapsedTime / totalTime
          val currentFrequency = safeStartFrequency + (safeEndFrequency - safeStartFrequency) * ratio
          val phaseIncrement = twoPi * currentFrequency / sampleRate

          for (i in buffer.indices) {
            buffer[i] = (sin(phase) * maxVolume).toInt().coerceIn(Short.MIN_VALUE.toInt(), Short.MAX_VALUE.toInt()).toShort()
            phase += phaseIncrement
            if (phase > twoPi) {
              phase -= twoPi
            }
          }
          audioTrack?.write(buffer, 0, buffer.size)
        }

        if (isPlaying) {
          handler.post { stopTone() }
        }
      }

      generationThread?.start()
    } catch (e: Exception) {
      // Log the error and ensure resources are cleaned up
      println("Error in generateSweep: ${e.message}")
      e.printStackTrace()
      stopTone()
    }
  }

  private fun stopTone() {
    try {
      isPlaying = false
      generationThread?.join(500)
      audioTrack?.stop()
      audioTrack?.release()
      audioTrack = null
    } catch (e: Exception) {
      // Log the error but don't rethrow
      println("Error in stopTone: ${e.message}")
      e.printStackTrace()
      // Ensure audioTrack is null even if there was an error
      audioTrack = null
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    stopTone()
    channel.setMethodCallHandler(null)
  }
}