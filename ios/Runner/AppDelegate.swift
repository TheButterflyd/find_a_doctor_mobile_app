import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let configChannel = FlutterMethodChannel(
      name: "com.example.doctorAplicattion/config",
      binaryMessenger: controller.binaryMessenger
    )
    
    configChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "setGoogleMapsKey" {
        if let args = call.arguments as? [String: Any],
           let apiKey = args["apiKey"] as? String {
          GMSServices.provideAPIKey(apiKey)
          result(nil)
        }
      }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
