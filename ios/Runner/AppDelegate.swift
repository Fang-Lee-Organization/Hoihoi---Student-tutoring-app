import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyD1sRLh3eYI2svfLJ0hreKM5Yr7gEjOUxA")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
