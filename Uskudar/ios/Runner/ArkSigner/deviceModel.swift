import Foundation

import UIKit

extension UIDevice {
    public static let deviceModel: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String {
            switch identifier {
            case "iPhone12,1":
                return "iPhone 11"

            case "iPhone12,3":
                return "iPhone 11 Pro"

            case "iPhone12,5":
                return "iPhone 11 Pro Max"

            case "iPhone13,1":
                return "iPhone 12 mini"

            case "iPhone13,2":
                return "iPhone 12"

            case "iPhone13,3":
                return "iPhone 12 Pro"

            case "iPhone13,4":
                return "iPhone 12 Pro Max"

            case "iPhone14,4":
                return "iPhone 13 mini"

            case "iPhone14,5":
                return "iPhone 13"

            case "iPhone14,2":
                return "iPhone 13 Pro"

            case "iPhone14,3":
                return "iPhone 13 Pro Max"

            case "iPhone14,6":
                return "iPhone SE (3rd generation)"

            case "iPhone14,7":
                return "iPhone 14"

            case "iPhone14,8":
                return "iPhone 14 Plus"

            case "iPhone15,2":
                return "iPhone 14 Pro"

            case "iPhone15,3":
                return "iPhone 14 Pro Max"

            case "iPhone15,4":
                return "iPhone 15"

            case "iPhone15,5":
                return "iPhone 15 Plus"

            case "iPhone16,1":
                return "iPhone 15 Pro"

            case "iPhone16,2":
                return "iPhone 15 Pro Max"

            case "iPhone17,1":
                return "iPhone 16 Pro"

            case "iPhone17,2":
                return "iPhone 16 Pro Max"

            case "iPhone17,3":
                return "iPhone 16"

            case "iPhone17,4":
                return "iPhone 16 Plus"

            case "iPhone18,1":
                return "iPhone 16e"

            default:
                return "others"
            }
        }
        return mapToDevice(identifier: identifier)
    }()
}
