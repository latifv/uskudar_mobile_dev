import Foundation

import UIKit

class AppData {
    static var sharedInstance = AppData()

    private init() {

    }

    public var mrzFromCamera: String = ""
    public var liveAuthResult: FlutterResult? = nil
    public var videoCallUrlRoot: String = ""
    public var fullName: String = ""
    public var tckn: String = ""
    public var transId: String = ""
    public var isInQueue: Bool = false

}
