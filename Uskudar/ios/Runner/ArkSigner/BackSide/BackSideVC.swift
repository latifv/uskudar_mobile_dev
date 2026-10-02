import ArkTCKK

import UIKit

@available(iOS 13.0, *)
class BackSideVC: UIViewController {

  @IBOutlet weak var arkMrzReader: ArkTckkUiMrzReader!
  private var isStarted: Bool = false
  private var mrzDocumentSerialNumberFromCamera: String?
  private var mrzDateOfBirthFromCamera: Date?
  private var mrzDateOfExpireFromCamera: Date?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.arkMrzReader?.start()
    self.isStarted = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    DispatchQueue.main.async {
      self.arkMrzReader.stop()
    }

  }

  fileprivate func setup() {

    self.arkMrzReader.delegate = self
    self.arkMrzReader.timeoutDurationInMillisecond = 15000
    self.arkMrzReader.cameraPreset = .hd1920x1080
    self.arkMrzReader.cameraPerformanceMode = false
    self.arkMrzReader.jpegQuality = 99
    self.arkMrzReader.svgOverlayImage = self.resizeImage(
      image: UIImage(named: "backSvg")!,
      targetSize: CGSize(
        width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.7))
    self.arkMrzReader.mrzSampleCount = 3
    self.arkMrzReader.setShowScanAnimation(value: true)
    self.arkMrzReader.setScanAnimationAspectRatioEnable(value: false)

  }

  func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size
    let widthRatio = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height
    var newSize: CGSize

    if widthRatio > heightRatio {
      newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
      newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }

    let rect = CGRect(origin: .zero, size: newSize)
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }

  func convertImageToBase64String(img: UIImage) -> String {
    return img.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
  }

  private func getMrzString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd"
    return MrzHelper.getMRZKey(
      id: mrzDocumentSerialNumberFromCamera!,
      dateOfBirth: formatter.string(from: mrzDateOfBirthFromCamera!),
      expiryDate: formatter.string(from: mrzDateOfExpireFromCamera!))
  }

}
@available(iOS 13.0, *)
extension BackSideVC: ArkTckkUiMrzReaderDelegate {

  func onMrzReadTimeout() {
    DispatchQueue.main.async {
      self.arkMrzReader.stop()
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.endLiveAuthStoryBoardsWithFail(result: -2)
      }
    }
  }

  func onMrzReadFailed(statusCode: Int) {
    DispatchQueue.main.async {
      self.arkMrzReader.stop()
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.endLiveAuthStoryBoardsWithFail(result: statusCode)
      }
    }
  }

  func onMrzReadSuccessfully(
    documentSerialNumber: String, dateOfBirth: Date, dateOfExpiration: Date, mrz: String
  ) {
    DispatchQueue.main.async {
      self.arkMrzReader.stop()
    }
    self.mrzDocumentSerialNumberFromCamera = documentSerialNumber
    self.mrzDateOfBirthFromCamera = dateOfBirth
    self.mrzDateOfExpireFromCamera = dateOfExpiration

    AppData.sharedInstance.mrzFromCamera = self.getMrzString()
    let imgBase64 = self.arkMrzReader.getTckkBackImg()
    let mrzString = getMrzString()
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      appDelegate.endLiveAuthStoryBoardsWithSuccess(result: [
        "image": imgBase64, "mrzString": mrzString,
      ])
    }

  }
}
