import UIKit
import CoreNFC

// swiftlint:disable all
public extension UIDevice {
    static fileprivate func getVersionCode() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let versionCode: String = String(
            validatingUTF8: NSString(
                bytes: &systemInfo.machine,
                length: Int(_SYS_NAMELEN),
                encoding: String.Encoding.ascii.rawValue
                )!.utf8String!
            )!
        
        return versionCode
    }
    
    static fileprivate func getVersion(code: String) -> Version {
        switch code {
            /*** iPhone ***/
        case "iPhone5,1":                       return .iPhone5
        case "iPhone6,1", "iPhone6,2":          return .iPhone5S
        case "iPhone7,2":                       return .iPhone6
        case "iPhone7,1":                       return .iPhone6Plus
        case "iPhone8,1":                       return .iPhone6S
        case "iPhone8,2":                       return .iPhone6SPlus
        case "iPhone8,3", "iPhone8,4":          return .iPhoneSE
        case "iPhone9,1", "iPhone9,3":          return .iPhone7
        case "iPhone9,2", "iPhone9,4":          return .iPhone7Plus
        case "iPhone10,1", "iPhone10,4":        return .iPhone8
        case "iPhone10,2", "iPhone10,5":        return .iPhone8Plus
        case "iPhone10,3", "iPhone10,6":        return .iPhoneX
        case "iPhone11,2":                      return .iPhoneXS
        case "iPhone11,4", "iPhone11,6":        return .iPhoneXS_Max
        case "iPhone11,8":                      return .iPhoneXR
        case "iPhone12,1":                      return .iPhone11
        case "iPhone12,3":                      return .iPhone11_Pro
        case "iPhone12,5":                      return .iPhone11_Pro_Max
        case "iPhone12,8":                      return .iPhoneSE_2020
        case "iPhone13,1":                      return .iPhone12_mini
        case "iPhone13,2":                      return .iPhone12
        case "iPhone13,3":                      return .iPhone12_Pro
        case "iPhone13,4":                      return .iPhone12_Pro_Max
        case "iPhone14,4":                      return .iPhone13_mini
        case "iPhone14,5":                      return .iPhone13
        case "iPhone14,2":                      return .iPhone13_Pro
        case "iPhone14,3":                      return .iPhone13_Pro_Max
        case "iPhone14,6":                      return .iPhoneSE_2022
        case "iPhone14,7":                      return .iPhone14
        case "iPhone14,8":                      return .iPhone14_Plus
        case "iPhone15,2":                      return .iPhone14_Pro
        case "iPhone15,3":                      return .iPhone14_Pro_Max
            
            /*** Simulator ***/
        case "i386", "x86_64":                           return .simulator
            
        default:                                         return .unknown
        }
    }
    
    static fileprivate func getType(code: String) -> DeviceType {
        let versionCode = getVersionCode()
        
        if versionCode.contains("iPhone") {
            return .iPhone
        } else if versionCode == "i386" || versionCode == "x86_64" {
            return .simulator
        } else {
            return .unknown
        }
    }
    
    static func deviceVersion() -> Version {
        return getVersion(code: getVersionCode())
    }
    
    static func size() -> Size {
        let w: Double = Double(UIScreen.main.bounds.width)
        let h: Double = Double(UIScreen.main.bounds.height)
        let screenHeight: Double = max(w, h)
        
        switch screenHeight {
        case 568:
            return .screen4Inch
        case 667:
            return UIScreen.main.scale == 3.0 ? .screen5_5Inch : .screen4_7Inch
        case 693:
            return .screen_zoomed
        case 736:
            return .screen5_5Inch
        case 780:
            return .screen5_4Inch
        case 812:
            return .screen5_8Inch
        case 844, 852:
            return .screen6_1Inch_2020
        case 896:
            return UIScreen.main.scale == 3.0 ? .screen6_5Inch : .screen6_1Inch
        case 926, 932:
            return .screen6_7Inch
        default:
            return .unknownSize
        }
    }
    
    static func type() -> DeviceType {
        return getType(code: getVersionCode())
    }
    
    static func isRetina() -> Bool {
        return UIScreen.main.scale > 1.0
    }
    
    static func isPhone() -> Bool {
        return type() == .iPhone
    }
    
    static func isSimulator() -> Bool {
        return type() == .simulator
    }
}

extension UIDevice {
    public enum DeviceType: String {
        case iPhone
        case simulator
        case unknown
    }
    
    public enum Version: String {
        /*** iPhone ***/
        case iPhone5
        case iPhone5S
        case iPhone6
        case iPhone6Plus
        case iPhone6S
        case iPhone6SPlus
        case iPhoneSE
        case iPhone7
        case iPhone7Plus
        case iPhone8
        case iPhone8Plus
        case iPhoneX
        case iPhoneXS
        case iPhoneXS_Max
        case iPhoneXR
        case iPhone11
        case iPhone11_Pro
        case iPhone11_Pro_Max
        case iPhoneSE_2020
        case iPhone12_mini
        case iPhone12
        case iPhone12_Pro
        case iPhone12_Pro_Max
        case iPhone13_mini
        case iPhone13
        case iPhone13_Pro
        case iPhone13_Pro_Max
        case iPhoneSE_2022
        case iPhone14
        case iPhone14_Plus
        case iPhone14_Pro
        case iPhone14_Pro_Max
        
        /*** simulator ***/
        case simulator
        
        /*** unknown ***/
        case unknown
    }
    
    public enum Size: Int, Comparable {
        case unknownSize = 0
        /// iPhone 5, 5s, 5c, SE, iPod Touch 5-6th gen.
        case screen4Inch
        /// iPhone 6, 6s, 7, 8, SE 2020
        case screen4_7Inch
        /// Zoomed screen on X, Xs, 11 Pro, 12, 12 Pro, 12 mini
        case screen_zoomed
        /// iPhone 12 mini
        case screen5_4Inch
        /// iPhone 6+, 6s+, 7+, 8+
        case screen5_5Inch
        /// iPhone X, Xs, 11 Pro
        case screen5_8Inch
        /// iPhone Xr, 11, 12, 12 Pro
        case screen6_1Inch
        /// iPhone 12, 12 Pro
        case screen6_1Inch_2020
        /// iPhone Xs Max, 11 Pro Max
        case screen6_5Inch
        /// iPhone  12 Pro Max
        case screen6_7Inch
        
        public static func < (lhs: Size, rhs: Size) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        public static func == (lhs: Size, rhs: Size) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }
}

public extension UIDevice {
    static var isNFCAvailable: Bool {
        return NFCReaderSession.readingAvailable
    }
}
// swiftlint:enable all
