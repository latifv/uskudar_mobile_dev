import UIKit

@available(iOS 13.0, *)
class LiveauthBoard: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func startFrontSideClicked(_ sender: Any) {

        let storyboard: UIStoryboard = UIStoryboard(name: "FrontSideSB", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FrontSideVC") as! FrontSideVC
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }

    @IBAction func startBackSideClicked(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "BackSideSB", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BackSideVC") as! BackSideVC
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)

    }

    @IBAction func startNfcClicked(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "NFCSideSB", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NFCSideVC") as! NFCSideVC
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }

    @IBAction func startFaceDetectionCliecked(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "FaceDetectionSB", bundle: nil)
        let vc =
            storyboard.instantiateViewController(withIdentifier: "FaceDetectionVC")
            as! FaceDetectionVC
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }

}
