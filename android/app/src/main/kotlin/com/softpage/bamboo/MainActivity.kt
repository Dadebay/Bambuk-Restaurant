package com.softpage.bamboo

import android.annotation.SuppressLint
import android.content.Context
import android.location.Location
import android.os.Looper
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationAvailability
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.softpage.bamboo/location"
    private lateinit var fusedClient: FusedLocationProviderClient

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        fusedClient = LocationServices.getFusedLocationProviderClient(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getLocation") {
                    getLocation(result)
                } else {
                    result.notImplemented()
                }
            }
    }

    @SuppressLint("MissingPermission")
    private fun getLocation(result: MethodChannel.Result) {
        var responded = false
        val handler = android.os.Handler(Looper.getMainLooper())

        fun respond(loc: Location, source: String) {
            if (!responded) {
                responded = true
                result.success(mapOf(
                    "latitude" to loc.latitude,
                    "longitude" to loc.longitude,
                    "accuracy" to loc.accuracy.toDouble(),
                    "source" to source
                ))
            }
        }

        fun onFail(msg: String) {
            if (!responded) {
                responded = true
                result.error("TIMEOUT", msg, null)
            }
        }

        // Doğrudan taze HIGH_ACCURACY konum iste (lastKnown yanlış yeri gösterebilir)
        requestFreshLocation(result, handler, ::respond, ::onFail)
    }

    @SuppressLint("MissingPermission")
    private fun requestFreshLocation(
        result: MethodChannel.Result,
        handler: android.os.Handler,
        respond: (Location, String) -> Unit,
        onFail: (String) -> Unit
    ) {
        // PRIORITY_HIGH_ACCURACY = GPS + Wi-Fi + hücresel, daha isabetli konum
        val request = LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 1000)
            .setMinUpdateIntervalMillis(500)
            .setMaxUpdates(1)
            .setWaitForAccurateLocation(false)
            .build()

        var callbackRegistered = false
        val callback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                val loc = locationResult.lastLocation
                if (loc != null) {
                    fusedClient.removeLocationUpdates(this)
                    respond(loc, "fresh_balanced")
                }
            }

            override fun onLocationAvailability(availability: LocationAvailability) {
                if (!availability.isLocationAvailable) {
                    // Switch to high accuracy (GPS) if network is unavailable
                    if (callbackRegistered) {
                        fusedClient.removeLocationUpdates(this)
                        requestHighAccuracy(respond, onFail, handler)
                    }
                }
            }
        }

        try {
            fusedClient.requestLocationUpdates(request, callback, Looper.getMainLooper())
            callbackRegistered = true
        } catch (e: Exception) {
            onFail("Failed to request location: ${e.message}")
            return
        }

        // Timeout after 15 seconds, then try GPS
        handler.postDelayed({
            fusedClient.removeLocationUpdates(callback)
            if (callbackRegistered) {
                requestHighAccuracy(respond, onFail, handler)
            }
        }, 15000)
    }

    @SuppressLint("MissingPermission")
    private fun requestHighAccuracy(
        respond: (Location, String) -> Unit,
        onFail: (String) -> Unit,
        handler: android.os.Handler
    ) {
        val request = LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 1000)
            .setMinUpdateIntervalMillis(500)
            .setMaxUpdates(1)
            .setWaitForAccurateLocation(false)
            .build()

        val callback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                val loc = locationResult.lastLocation
                if (loc != null) {
                    fusedClient.removeLocationUpdates(this)
                    respond(loc, "fresh_gps")
                }
            }
        }

        try {
            fusedClient.requestLocationUpdates(request, callback, Looper.getMainLooper())
        } catch (e: Exception) {
            onFail("GPS failed: ${e.message}")
            return
        }

        // Final timeout after 15 more seconds
        handler.postDelayed({
            fusedClient.removeLocationUpdates(callback)
            onFail("Could not get location within timeout")
        }, 15000)
    }
}
