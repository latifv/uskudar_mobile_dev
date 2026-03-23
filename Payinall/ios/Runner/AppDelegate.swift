import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    var controller = FlutterViewController()
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        controller = window?.rootViewController as! FlutterViewController
        let liveAuth = FlutterMethodChannel(
            name: "com.erpapay.payinall/liveauth",
            binaryMessenger: controller.binaryMessenger)
        liveAuth.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

            AppData.sharedInstance.liveAuthResult = result
            if #available(iOS 13.0, *) {
                if call.method == "frontside" {
                    self.StartFrontSide()
                } else if call.method == "backside" {
                    self.StartBackSide()
                } else if call.method == "nfc" {

                    self.StartNFC(encodedMrz: AppData.sharedInstance.mrzFromCamera)
                } else if call.method == "selfie" {
                    self.StartFace()
                }
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    @available(iOS 13.0, *)
    private func StartFrontSide() {
        let storyBoard = UIStoryboard(
            name: "FrontSideSB", bundle: Bundle(identifier: "com.arksigner.flutter"))
        let vc = storyBoard.instantiateViewController(withIdentifier: "FrontSideVC")
        vc.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = vc
    }

    private func StartBackSide() {
        let storyBoard = UIStoryboard(
            name: "BackSideSB", bundle: Bundle(identifier: "com.arksigner.flutter"))
        let vc = storyBoard.instantiateViewController(withIdentifier: "BackSideVC")
        vc.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = vc
    }

    private func StartNFC(encodedMrz: String) {
        AppData.sharedInstance.mrzFromCamera = encodedMrz
        let storyBoard = UIStoryboard(
            name: "NFCsideSB", bundle: Bundle(identifier: "com.arksigner.flutter"))
        let vc = storyBoard.instantiateViewController(withIdentifier: "NFCSideVC")
        vc.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = vc
    }

    private func StartFace() {
        let storyBoard = UIStoryboard(
            name: "FaceDetectionSB", bundle: Bundle(identifier: "com.arksigner.flutter"))

        let vc = storyBoard.instantiateViewController(withIdentifier: "FaceDetectionVC")
        vc.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = vc
    }

    private func StartVideoCall(
        videoCallUrlRoot: String, tckn: String, fullName: String, transId: String
    ) {

        AppData.sharedInstance.fullName = fullName
        AppData.sharedInstance.tckn = tckn
        AppData.sharedInstance.videoCallUrlRoot = videoCallUrlRoot

        let storyBoard = UIStoryboard(
            name: "VideoCallSB", bundle: Bundle(identifier: "com.arksigner.flutter"))
        let vc = storyBoard.instantiateViewController(withIdentifier: "VideoCallVC")
        vc.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = vc
    }

    public func endLiveAuthStoryBoardsWithSuccess(result: [String: Any]) {

        AppData.sharedInstance.liveAuthResult!(result)
        self.window?.rootViewController = controller
    }

    public func endLiveAuthStoryBoardsWithFail(result: Int) {

        AppData.sharedInstance.liveAuthResult!(
            FlutterError(code: "\(result)", message: nil, details: nil))
        self.window?.rootViewController = controller
    }

    override func applicationWillTerminate(_ application: UIApplication) {
        if AppData.sharedInstance.isInQueue == true {
            debugPrint("applicationWillTerminate finished")
            debugPrint("applicationWillTerminate")

            AppData.sharedInstance.liveAuthResult!(
                FlutterError(code: "\(-3)", message: nil, details: nil))
        }
    }
}
