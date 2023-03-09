import UIKit
import Flutter
import flutter_downloader

import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
//      if FirebaseApp.app() == nil {
//                   FirebaseApp.configure()
//                 }
//                 if #available(iOS 10.0, *) {
//                   UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//                 }
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    GMSServices.provideAPIKey("AIzaSyB07GK4in7QPDNP7W-0GWkUEcp6KtPB28A")             
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}