import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // identifierForVendor: estable mientras la app esté instalada.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AsistlyDevice") {
      let channel = FlutterMethodChannel(name: "asistly/device", binaryMessenger: registrar.messenger())
      channel.setMethodCallHandler { call, result in
        if call.method == "getDeviceId" {
          result(UIDevice.current.identifierForVendor?.uuidString)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }
}
