import Flutter
import UIKit
import YandexMapsMobile


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      YMKMapKit.setLocale("ru_RU") // Your preferred language. Not required, defaults to system language
         YMKMapKit.setApiKey("ec9c9734-d6cf-48a8-8d7b-bfb81ee96e2a") // Your generated API key
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
