import UIKit
import Flutter
import GoogleMaps // Asegúrate de tener esta línea

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyA94TvRM4Q2o0MqJVPXGKWAopWbWCYl03E") // Añade esta línea con tu NUEVA clave
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}