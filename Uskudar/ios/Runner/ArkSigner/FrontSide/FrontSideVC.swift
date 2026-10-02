import ArkTCKK

import UIKit

@available(iOS 13.0, *)
class FrontSideVC: UIViewController {

  @IBOutlet weak var arkFrontScanView: ArkTckkUiFrontReader!
  private var isStarted: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.arkFrontScanView?.start()
    self.isStarted = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    DispatchQueue.main.async {
      self.arkFrontScanView.stop()
    }
  }

  fileprivate func setup() {

    self.arkFrontScanView.delegate = self
    self.arkFrontScanView.timeoutDurationInMillisecond = 15000
    self.arkFrontScanView.cameraPreset = .hd1920x1080
    self.arkFrontScanView.cameraPerformanceMode = false
    self.arkFrontScanView.jpegQuality = 99
    self.arkFrontScanView.svgOverlayImage = self.resizeImage(
      image: UIImage(named: "frontSvg")!,
      targetSize: CGSize(
        width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.7))
    self.arkFrontScanView.numberPhrasesToFind = 4
    self.arkFrontScanView.setShowScanAnimation(value: true)
    self.arkFrontScanView.setScanAnimationAspectRatioEnable(value: false)
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

}
@available(iOS 13.0, *)
extension FrontSideVC: ArkTckkUiFrontSideReaderDelegate {

  func onFrontScanTimedOut() {
    DispatchQueue.main.async {
      self.arkFrontScanView.stop()
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.endLiveAuthStoryBoardsWithFail(result: -2)
      }
    }
  }

  func onFrontScanFailed(statusCode: Int) {
    DispatchQueue.main.async {
      self.arkFrontScanView.stop()
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.endLiveAuthStoryBoardsWithFail(result: statusCode)
      }
    }
  }

  func onFrontScanReadSuccessfully(image imageBase64: UIImage) {
    DispatchQueue.main.async {
      self.arkFrontScanView.stop()
    }

    let imgBase64 = self.convertImageToBase64String(img: imageBase64)
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      appDelegate.endLiveAuthStoryBoardsWithSuccess(result: ["image": imgBase64])
    }
  }

}
