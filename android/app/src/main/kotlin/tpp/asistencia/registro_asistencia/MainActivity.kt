package tpp.asistencia.registro_asistencia

import android.app.ActivityManager
import android.app.admin.DevicePolicyManager
import android.media.AudioManager
import android.media.ToneGenerator
import android.content.ComponentName
import android.content.Context
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val devicePolicyManager by lazy {
		getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
	}
	private val adminComponent by lazy {
		ComponentName(this, KioskDeviceAdminReceiver::class.java)
	}
	private val scanTone by lazy {
		ToneGenerator(AudioManager.STREAM_MUSIC, 95)
	}

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(
			flutterEngine.dartExecutor.binaryMessenger,
			KIOSK_CHANNEL,
		).setMethodCallHandler { call, result ->
			when (call.method) {
				"startKiosk" -> result.success(startKioskMode())
				"stopKiosk" -> result.success(stopKioskMode())
				"isInKiosk" -> result.success(isInKioskMode())
				"isLockTaskPermitted" -> result.success(isLockTaskPermitted())
				"isDeviceOwner" -> result.success(devicePolicyManager.isDeviceOwnerApp(packageName))
				"playScanBeep" -> result.success(playScanBeep())
				else -> result.notImplemented()
			}
		}
	}

	private fun playScanBeep(): Boolean {
		return runCatching {
			scanTone.startTone(ToneGenerator.TONE_PROP_BEEP, 120)
			true
		}.getOrDefault(false)
	}

	override fun onResume() {
		super.onResume()
		applyDeviceOwnerPolicies()
		// Keep activity in lock task when app returns to foreground.
		startKioskMode()
	}

	private fun applyDeviceOwnerPolicies() {
		if (!devicePolicyManager.isDeviceOwnerApp(packageName)) {
			return
		}

		runCatching {
			devicePolicyManager.setLockTaskPackages(adminComponent, arrayOf(packageName))
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
				devicePolicyManager.setStatusBarDisabled(adminComponent, true)
			}
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
				devicePolicyManager.setKeyguardDisabled(adminComponent, true)
			}
		}
	}

	private fun startKioskMode(): Boolean {
		if (isInKioskMode()) {
			return true
		}

		return runCatching {
			startLockTask()
			true
		}.getOrDefault(false)
	}

	private fun stopKioskMode(): Boolean {
		if (!isInKioskMode()) {
			return true
		}

		return runCatching {
			stopLockTask()
			if (devicePolicyManager.isDeviceOwnerApp(packageName)) {
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
					devicePolicyManager.setStatusBarDisabled(adminComponent, false)
				}
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
					devicePolicyManager.setKeyguardDisabled(adminComponent, false)
				}
			}
			true
		}.getOrDefault(false)
	}

	private fun isInKioskMode(): Boolean {
		val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
		return activityManager.lockTaskModeState != ActivityManager.LOCK_TASK_MODE_NONE
	}

	private fun isLockTaskPermitted(): Boolean {
		return devicePolicyManager.isLockTaskPermitted(packageName)
	}

	companion object {
		private const val KIOSK_CHANNEL = "registro_asistencia/kiosk"
	}
}
