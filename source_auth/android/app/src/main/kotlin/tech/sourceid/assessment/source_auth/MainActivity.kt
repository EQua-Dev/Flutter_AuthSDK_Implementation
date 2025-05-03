package tech.sourceid.assessment.source_auth

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


import android.content.Intent
import tech.sourceid.assessment.authsdk.data.AuthConfig
import tech.sourceid.assessment.authsdk.data.AuthConfigHolder
import tech.sourceid.assessment.authsdk.AuthActivity
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.sp
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.TextUnit
import androidx.core.graphics.toColorInt



class MainActivity: FlutterActivity(){

    private val CHANNEL = "auth_sdk_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "launchAuthSDK") {
                val config = call.argument<Map<String, Any>>("config")
                launchAuthScreen(config, result)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun launchAuthScreen(configMap: Map<String, Any>?, result: MethodChannel.Result) {
        // Set config values
        val config = AuthConfig(
            primaryColor = Color(configMap?.get("primaryColor").toString().toColorInt()),
            backgroundColor = Color(configMap?.get("backgroundColor").toString().toColorInt()),
            textColor = Color(configMap?.get("textColor").toString().toColorInt()),
            fontSize = 16.sp,
            fontFamily = FontFamily.Default,
            submitButtonText = configMap?.get("submitButtonText") as String,
            showUsername = configMap["showUsername"] as Boolean
        )
        AuthConfigHolder.config = config

        // Set the callback
        AuthConfigHolder.callback = { user ->
            val userMap = mapOf(
                "email" to user.email,
                "password" to user.password,
                "username" to user.username,
                "firstName" to user.firstName,
                "lastName" to user.lastName
            )
            result.success(userMap)
        }

        // Start the SDK screen
        startActivity(Intent(this, AuthActivity::class.java))
    }
}
