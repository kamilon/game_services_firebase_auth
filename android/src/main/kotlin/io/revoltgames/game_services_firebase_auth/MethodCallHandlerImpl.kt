package io.revoltgames.game_services_firebase_auth

import android.app.Activity
import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import com.google.android.gms.games.AuthenticationResult
import com.google.android.gms.games.PlayGames
import com.google.android.gms.games.PlayGamesSdk
import com.google.android.gms.tasks.Task
import io.flutter.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler


class MethodCallHandlerImpl(
    private val activity: Activity,
    binaryMessenger: BinaryMessenger,
) : MethodCallHandler {
    private var channel: MethodChannel =
        MethodChannel(binaryMessenger, "game_services_firebase_auth")

    private var context: Context? = null;

    init {
        channel.setMethodCallHandler(this)
        PlayGamesSdk.initialize(activity)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        when (call.method) {
            PluginConstants.METHOD_SIGN_IN_WITH_GAME_SERVICE -> signInWithGameService(call, result)

            PluginConstants.METHOD_IS_ALREADY_SIGN_IN_WITH_GAME_SERVICE -> isAlreadySignInWithGameService(
                call,
                result
            )

            PluginConstants.METHOD_GET_ANDROID_SERVER_AUTH_CODE -> getAndroidServerAuthCode(
                call,
                result
            )

            else -> result.notImplemented()
        }
    }

    companion object {
        @JvmStatic
        fun getResourceFromContext(context: Context, resName: String): String {
            val stringRes = context.resources.getIdentifier(resName, "string", context.packageName)
            if (stringRes == 0) {
                throw IllegalArgumentException(
                    String.format(
                        "The 'R.string.%s' value it's not defined in your project's resources file.",
                        resName
                    )
                )
            }
            return context.getString(stringRes)
        }

    }

    private fun signInWithGameService(call: MethodCall, result: MethodChannel.Result) {

        val gamesSignInClient = PlayGames.getGamesSignInClient(activity)

        Log.i("[Game Services]", "signInWithGameService - Login requested")

        val app: ApplicationInfo = activity.packageManager
            .getApplicationInfo(activity.packageName, PackageManager.GET_META_DATA)

        val projectId = app.metaData.getString("com.google.android.gms.games.APP_ID")

        if(projectId == null) {
            result.error(
                "invalid-config",
                "Using firebase_auth_games_services plugin requires a metadata tag with the name \"com.google.android.gms.games.APP_ID\" in the application tag of your manifest.",
                null
            )
            return
        }

        gamesSignInClient.isAuthenticated()
            .addOnCompleteListener CheckAuthentication@{ isAuthenticatedTask: Task<AuthenticationResult> ->
                val isAuthenticated =
                    (isAuthenticatedTask.isSuccessful &&
                            isAuthenticatedTask.result.isAuthenticated)

                if (isAuthenticated) {
                    Log.i("[Game Services]", "signInWithGameService - Play Games sign-in succeeded")
                    result.success(true)
                    return@CheckAuthentication
                }

                Log.i("[Game Services]", "signInWithGameService - ${isAuthenticatedTask.isSuccessful} - ${isAuthenticatedTask.result.isAuthenticated}")

                gamesSignInClient.signIn()
                    .addOnCompleteListener SignIn@{ signInTask: Task<AuthenticationResult> ->

                        val isSignedIn =
                            (signInTask.isSuccessful &&
                                    signInTask.result.isAuthenticated)

                        Log.i("[Game Services]", "signInWithGameService - ${signInTask.isSuccessful} - ${signInTask.result.isAuthenticated}")

                        if (!isSignedIn) {
                            // Check for the error if the sign-in task failed
                            if (signInTask.exception != null) {
                                Log.e("[Game Services]", "signInWithGameService - Error during sign-in",
                                    signInTask.exception!!
                                )
                            } else {
                                Log.e("[Game Services]", "signInWithGameService - Unknown error occurred")
                            }

                            Log.i("[Game Services]", "signInWithGameService - Play Games sign-in failed")
                            result.success(false)
                            return@SignIn
                        }

                        Log.i(
                            "[Game Services]",
                            "signInWithGameService - Play Games sign-in succeed"
                        )
                        result.success(true)
                        return@SignIn
                    }
            }

    }

    private fun isAlreadySignInWithGameService(call: MethodCall, result: MethodChannel.Result) {
        val gamesSignInClient = PlayGames.getGamesSignInClient(activity)

        Log.i("[Game Services]", "signInWithGameService - Check if already authenticated")

        gamesSignInClient.isAuthenticated()
            .addOnCompleteListener CheckAuthentication@{ isAuthenticatedTask: Task<AuthenticationResult> ->

                val isAuthenticated =
                    (isAuthenticatedTask.isSuccessful &&
                            isAuthenticatedTask.result.isAuthenticated)

                result.success(isAuthenticated)
            }

    }

    private fun getAndroidServerAuthCode(call: MethodCall, result: MethodChannel.Result) {
        val gamesSignInClient = PlayGames.getGamesSignInClient(activity)

        gamesSignInClient.isAuthenticated()
            .addOnCompleteListener AuthCheck@{ isAuthenticatedTask: Task<AuthenticationResult> ->
                val isAuthenticated =
                    (isAuthenticatedTask.isSuccessful &&
                            isAuthenticatedTask.result.isAuthenticated)


                if (!isAuthenticated) {
                    result.error(
                        "not_authenticated",
                        "Your are not authenticated to Play Games, call signInWithGameService before",
                        null
                    )
                    return@AuthCheck
                }

                val app: ApplicationInfo = activity.packageManager
                    .getApplicationInfo(activity.packageName, PackageManager.GET_META_DATA)

                val oAuthClientId = app.metaData.getString(
                    PluginConstants.OAUTH_2_CLIENT_ID_KEY
                )

                if (oAuthClientId == null) {
                    result.error(
                        "invalid-config",
                        "Using firebase_auth_games_services plugin requires a metadata tag with the name \"${PluginConstants.OAUTH_2_CLIENT_ID_KEY}\" in the application tag of your manifest.",
                        null
                    )
                    return@AuthCheck
                }

                gamesSignInClient.requestServerSideAccess(
                    oAuthClientId,
                    false
                ).addOnCompleteListener GetAuthCode@{ authCodeTask: Task<String> ->
                    if (!authCodeTask.isSuccessful) {
                        Log.i("[Game Services]", "getAndroidServerAuthCode - GetAuthCode failed")
                        result.success(null)
                        return@GetAuthCode
                    }

                    val authCode = authCodeTask.result
                    if (authCode.isBlank()) {
                        Log.i(
                            "[Game Services]",
                            "getAndroidServerAuthCode - Received empty auth code"
                        )
                        result.success(null)
                        return@GetAuthCode
                    } else {
                        Log.i(
                            "[Game Services]",
                            "getAndroidServerAuthCode - Auth code=$authCode"
                        )
                    }

                    result.success(authCode)
                }
            }
    }

    fun stopListening() {
        channel.setMethodCallHandler(null)
    }

    fun setContext(newContext: Context) {
        context = newContext
    }
}
