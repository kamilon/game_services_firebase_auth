import Flutter
import UIKit
import GameKit
import os
import FirebaseAuth


public class SwiftGameServicesFirebaseAuthPlugin: NSObject, FlutterPlugin {
    
    
    var viewController: UIViewController {
        return UIApplication.shared.windows.first!.rootViewController!
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "game_services_firebase_auth", binaryMessenger: registrar.messenger())
        let instance = SwiftGameServicesFirebaseAuthPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "signInWithGameService":
            signInWithGameService(result: result)
        case "isAlreadySignInWithGameService":
            isAlreadySignInWithGameService(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    func isAlreadySignInWithGameService(result: @escaping FlutterResult) {
        let playerSignedIn = GKLocalPlayer.local.isAuthenticated
        result(playerSignedIn);
    }
    
    func signInWithGameService(result: @escaping FlutterResult) {
        NSLog("[Game Services] - signInWithGameService - Login requested")
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            
            // Show the sign in pop up to the user
            if let viewController = viewController {
                NSLog("[Game Services] - signInWithGameService - Show login pop up")
                self.viewController.present(viewController, animated: true, completion: nil)
                return
            }
            
            if error != nil {
                // Player could not be authenticated.
                // Disable Game Center in the game.
                return
            }
            
            if !GKLocalPlayer.local.isAuthenticated {
                NSLog("[Game Services] - signInWithGameService - No user is authenticated")
                result(nil)
            }
            
            NSLog("[Game Services] - signInWithGameService - Game Center sign in succeded")
            result("")
        }
    }
}

