import Flutter
import UIKit
import GameKit
import os
import FirebaseAuth

/// A Flutter plugin class that facilitates signing in with Game Center (iOS) and managing
/// Game Services for Firebase Authentication. It communicates with the native GameKit framework
/// and returns results to Flutter via method channels.
public class SwiftGameServicesFirebaseAuthPlugin: NSObject, FlutterPlugin {
    
    // Provides the current view controller to present Game Center sign-in UI.
    // This is required because GameKit needs to present the authentication UI in some cases.
    var viewController: UIViewController {
        return UIApplication.shared.windows.first!.rootViewController!
    }
    
    /// Registers the plugin with the Flutter plugin registrar.
    ///
    /// - Parameter registrar: The FlutterPluginRegistrar used to register the plugin with the Flutter engine.
    public static func register(with registrar: FlutterPluginRegistrar) {
        // Create a method channel to communicate with Flutter. The name of the channel must match with
        // what is used in the Flutter Dart code.
        let channel = FlutterMethodChannel(name: "game_services_firebase_auth", binaryMessenger: registrar.messenger())
        // Create an instance of the plugin and register it to handle method calls from Flutter.
        let instance = SwiftGameServicesFirebaseAuthPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    /// Handles the incoming method calls from Flutter and invokes the appropriate function.
    ///
    /// - Parameters:
    ///   - call: The Flutter method call, containing the method name and any arguments.
    ///   - result: The callback to send data or errors back to the Flutter side.
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "signInWithGameService":
            // Handle Game Center sign-in when Flutter calls "signInWithGameService".
            signInWithGameService(result: result)
        case "isAlreadySignInWithGameService":
            // Check if the user is already signed in when Flutter calls "isAlreadySignInWithGameService".
            isAlreadySignInWithGameService(result: result)
        default:
            // Return 'not implemented' for unrecognized method calls.
            result(FlutterMethodNotImplemented)
        }
    }
    
    /// Checks whether the user is already signed into Game Center.
    ///
    /// - Parameter result: A FlutterResult callback that sends `true` if the user is signed in,
    ///   or `false` if not signed in.
    func isAlreadySignInWithGameService(result: @escaping FlutterResult) {
        // GKLocalPlayer.local.isAuthenticated returns `true` if the user is signed into Game Center.
        let playerSignedIn = GKLocalPlayer.local.isAuthenticated
        result(playerSignedIn) // Send the result back to Flutter.
    }
    
    /// Attempts to sign in with Game Center.
    ///
    /// This method triggers Game Center sign-in using `GKLocalPlayer`. If Game Center needs to
    /// present a UI for authentication, it will be displayed. Upon completion, the method
    /// returns either success (`true`) or failure (`false`) to Flutter.
    ///
    /// - Parameter result: A FlutterResult callback that sends `true` if sign-in is successful,
    ///   or `false` if the sign-in fails. It also sends a `FlutterError` if an error occurs.
    func signInWithGameService(result: @escaping FlutterResult) {
        // Log the start of the Game Center sign-in process.
        NSLog("[Game Services] - signInWithGameService - Login requested")
        
        // The authenticateHandler is called to authenticate the local player.
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            
            // If Game Center needs to present a sign-in UI, this view controller is provided.
            if let viewController = viewController {
                // Log that a UI prompt is required for sign-in.
                NSLog("[Game Services] - signInWithGameService - Show login pop up")
                // Present the Game Center login view to the user.
                self.viewController.present(viewController, animated: true, completion: nil)
                return
            }
            
            // Handle errors during Game Center authentication.
            if let error = error {
                // Log the error and return it as a FlutterError to Flutter.
                NSLog("[Game Services] - signInWithGameService - ERROR - %@", error.localizedDescription)
                result(FlutterError(code: "sign_in_failed", message: error.localizedDescription, details: nil))
                return
            }
            
            // If authentication fails but no error is thrown.
            if !GKLocalPlayer.local.isAuthenticated {
                // Log that no user is authenticated and return false to Flutter.
                NSLog("[Game Services] - signInWithGameService - No user is authenticated")
                result(false)
                return
            }
            
            // If the player is successfully authenticated.
            NSLog("[Game Services] - signInWithGameService - Game Center sign-in succeeded")
            result(true) // Send success back to Flutter.
        }
    }
}
