import ArkNfcStatic
import UIKit

@available(iOS 13.0, *)
class NFCSideVC: UIViewController {

  @IBOutlet weak var arkNfcReader: ArkNfcDataReader!
  private var isDoneWithSuccess: Bool = false
  private var isStarted: Bool = false

  @IBOutlet weak var animationgif: UIImageView!
  override func viewDidLoad() {
    super.viewDidLoad()

    self.setup()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.main.async {
      self.arkNfcReader.start()
    }
    self.isStarted = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    DispatchQueue.main.async {
      self.isStarted = false
      self.arkNfcReader.stop()
    }
    NotificationCenter.default.removeObserver(self)
    animationgif.image = nil
  }

  fileprivate func setup() {

    self.arkNfcReader.delegate = self
    self.arkNfcReader.mrzString = AppData.sharedInstance.mrzFromCamera
    self.arkNfcReader.msgProgressEmpty = "⬜️"
    self.arkNfcReader.msgProgressFilled = "🟩"
    let gif = UIImage.ArkGifLoader("tckk_nfc")
    animationgif.image = gif
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

}

@available(iOS 13.0, *)
extension NFCSideVC: ArkNfcDataReaderDelegate {

  func onDataGroupRead(dgNumber: Int, totalNumberOfDgs: Int) {
    print("")
  }

  func onNfcReadTimeout() {
    DispatchQueue.main.async {
      self.arkNfcReader.stop()
      if self.isStarted == true {
        // AppData.sharedInstance.errorCallback!(["-1"])
      }
      self.isStarted = false

      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
          appDelegate.endLiveAuthStoryBoardsWithFail(result: -2)
        }
      }
    }

  }

  func onNfcReadFailed(statusCode: Int) {
    if self.isDoneWithSuccess {
      return
    }

    DispatchQueue.main.async {
      self.arkNfcReader.stop()
      if self.isStarted == true {
        //   AppData.sharedInstance.errorCallback!([statusCode])
      }
      self.isStarted = false

      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
          appDelegate.endLiveAuthStoryBoardsWithFail(result: statusCode)
        }
      }
    }
  }

  func onNfcReadSuccessfully() {

    debugPrint("onNfcReadSuccessfully")
    self.isDoneWithSuccess = true

    DispatchQueue.main.async {
      self.arkNfcReader.stop()
      self.isStarted = false
    }

    // AppData.sharedInstance.successCallback!([dataGroupsParameters])

    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.endLiveAuthStoryBoardsWithSuccess(result: DataGroupDict)
      }
    }
  }

}
