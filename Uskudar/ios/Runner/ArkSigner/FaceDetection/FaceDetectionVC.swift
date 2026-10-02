import ArkFace

import UIKit

@available(iOS 13.0, *)
class FaceDetectionVC: UIViewController {

  @IBOutlet weak var arkFaceReader: ArkTckkUiFaceCapture!
  private var isStarted: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.arkFaceReader.stop()
      self.isStarted = true
      self.arkFaceReader.start()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    DispatchQueue.main.async {
      self.arkFaceReader.stop()
    }
  }

  fileprivate func setup() {

    self.arkFaceReader.delegate = self
    self.arkFaceReader.eyeOpenProbability = 0.8
    self.arkFaceReader.photoQualityThreshold = 0.20
    self.arkFaceReader.timeoutDurationInMilliseconds = 60000
    self.arkFaceReader.livenessActionCount = 3
    self.arkFaceReader.livenessEnableEyeDetection = false
    self.arkFaceReader.useEyeDetection = false
    self.arkFaceReader.livenessImgAlpha = 0.8
    if UIDevice.modelName != "others" {
      self.arkFaceReader.cameraPreset = .iFrame1280x720
    } else {
      self.arkFaceReader.cameraPreset = .hd1280x720
    }
    self.arkFaceReader.jpegQuality = 20
    self.arkFaceReader.photoCount = 3
    self.arkFaceReader.cutoutOpacity = 90
    self.arkFaceReader.faceCaptureMode = .withLivenessCheck
    self.arkFaceReader.imageBrigthnessThreshold = 15.0

  }

}
@available(iOS 13.0, *)

extension FaceDetectionVC: ArkTckkUiFaceCaptureDelegate {

  func onFaceCaptureWarning(message: String) {
    print("onFaceCaptureWarning")
  }

  func onFaceCaptureWrongFace() {
    print("onFaceCaptureWrongFace")
  }

  func onFaceCaptureNewMessage(message: String) {
    print("onFaceCaptureNewMessage")
  }

  func onFaceCaptureTimeout() {
    DispatchQueue.main.async {
      self.arkFaceReader.stop()

      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.endLiveAuthStoryBoardsWithFail(result: -2)
      }
    }

  }

  func onFaceCaptureFailed(statusCode: Int) {
    DispatchQueue.main.async {
      self.arkFaceReader.stop()

      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.endLiveAuthStoryBoardsWithFail(result: statusCode)
      }
    }
  }

  func onFaceCapturedSuccessfully() {
    print("onFaceCapturedSuccessfully")

    DispatchQueue.main.async {
      self.arkFaceReader.stop()
    }

    let photos = self.arkFaceReader.getCompressedPhotoSequenceBase64()

    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      appDelegate.endLiveAuthStoryBoardsWithSuccess(result: ["photos": photos])
    }
  }
}
