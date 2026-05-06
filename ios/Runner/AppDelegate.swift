import UIKit
import Flutter
import MessageUI

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MFMessageComposeViewControllerDelegate {
  private var flutterResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let smsChannel = FlutterMethodChannel(name: "com.example.sms_sender/sms",
                                              binaryMessenger: controller.binaryMessenger)
    
    smsChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "sendSms" {
        guard let args = call.arguments as? [String: Any],
              let phone = args["phone"] as? String,
              let message = args["message"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing phone or message", details: nil))
          return
        }
        self?.sendSms(phone: phone, message: message, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func sendSms(phone: String, message: String, result: @escaping FlutterResult) {
    if !MFMessageComposeViewController.canSendText() {
      result(FlutterError(code: "CANNOT_SEND", message: "Device cannot send SMS", details: nil))
      return
    }

    self.flutterResult = result
    let composeVC = MFMessageComposeViewController()
    composeVC.messageComposeDelegate = self
    composeVC.recipients = [phone]
    composeVC.body = message

    window?.rootViewController?.present(composeVC, animated: true, completion: nil)
  }

  func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    controller.dismiss(animated: true, completion: nil)
    
    guard let flutterResult = self.flutterResult else { return }
    
    switch (result) {
    case .cancelled:
        flutterResult(FlutterError(code: "CANCELLED", message: "SMS Cancelled", details: nil))
    case .failed:
        flutterResult(FlutterError(code: "FAILED", message: "SMS Failed", details: nil))
    case .sent:
        flutterResult("SMS Sent Successfully")
    @unknown default:
        flutterResult(FlutterError(code: "UNKNOWN", message: "Unknown error", details: nil))
    }
    self.flutterResult = nil
  }
}
