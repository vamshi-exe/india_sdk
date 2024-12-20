import Flutter
import UIKit
//import CCAvenueSDK

public class IndiaSdkPlugin: NSObject, FlutterPlugin {
    private var ccIndiaDelegate: CCIndiaDelegate?

    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugin_ccavenue", binaryMessenger: registrar.messenger())
    let instance = IndiaSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
                result(FlutterError(code: "NO_ACTIVITY",
                                  message: "Unable to get view controller",
                                  details: nil))
                return
            }
            
            if call.method == "pay" {
                guard let arguments = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "INVALID_ARGUMENTS",
                                      message: "Arguments expected",
                                      details: nil))
                    return
                }
                
                ccIndiaDelegate = CCIndiaDelegate(viewController: viewController)
                ccIndiaDelegate?.initiateSdk(arguments, result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
}
