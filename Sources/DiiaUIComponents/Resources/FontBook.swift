import UIKit

public protocol FontProtocol {
    var regular: FontStyleProtocol { get }
    var bold: FontStyleProtocol { get }
    var light: FontStyleProtocol { get }
    var medium: FontStyleProtocol { get }
}

public protocol FontStyleProtocol {
    func size(_ size: CGFloat) -> UIFont
}

private struct SystemFont: FontProtocol {
    
    private enum SystemFontType: FontStyleProtocol {
        case regular
        case bold
        case light
        case medium
        
        func size(_ size: CGFloat) -> UIFont {
            switch self {
            case .regular: return UIFont.systemFont(ofSize: size, weight: .regular)
            case .light: return UIFont.systemFont(ofSize: size, weight: .light)
            case .bold: return UIFont.systemFont(ofSize: size, weight: .bold)
            case .medium: return UIFont.systemFont(ofSize: size, weight: .medium)
            }
        }
    }
    
    var regular: FontStyleProtocol { SystemFontType.regular }
    var bold: FontStyleProtocol { SystemFontType.bold }
    var light: FontStyleProtocol { SystemFontType.light }
    var medium: FontStyleProtocol { SystemFontType.medium }
}

public struct FontBook {
    /// variable allows to set an object that provides main custom font with styles if need.
    public static var mainFont: FontProtocol = SystemFont()
    /// variable allows to set an object that provides heading custom font with styles if need.
    public static var headingFont: FontProtocol = SystemFont()
}

public extension FontBook {
    static let textFieldTitle = FontBook.mainFont.regular.size(9)
    
    static let bigNumbers: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(159)
        case 320:
            return FontBook.mainFont.regular.size(123)
        default:
            return FontBook.mainFont.regular.size(144)
        }
    }()
    
    static let mediumNumbers: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.headingFont.regular.size(48)
        case 320:
            return FontBook.headingFont.regular.size(40)
        default:
            return FontBook.headingFont.regular.size(48)
        }
    }()
    
    /// Font: e-Ukraine Regular 36px
    static let bigHeading: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(40)
        case 320:
            return FontBook.mainFont.regular.size(30)
        default:
            return FontBook.mainFont.regular.size(36)
        }
    }()
    
    static let stubEmoji: UIFont = FontBook.mainFont.regular.size(48)
    
    /// Font: e-Ukraine Regular 32px
    static let bigEmoji: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(36)
        case 320:
            return FontBook.mainFont.regular.size(26)
        default:
            return FontBook.mainFont.regular.size(32)
        }
    }()
    
    /// Font: e-Ukraine Regular 24px
    static let smallEmoji: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(28)
        case 320:
            return FontBook.mainFont.regular.size(18)
        default:
            return FontBook.mainFont.regular.size(24)
        }
    }()
    
    static let bigEmojiLight: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.light.size(36)
        case 320:
            return FontBook.mainFont.light.size(26)
        default:
            return FontBook.mainFont.light.size(32)
        }
    }()
    
    static var pincodeDigitFont: UIFont = {
        return FontBook.mainFont.regular.size(30)
    }()
    
    /// Font: e-Ukraine Regular 29px
    static var numbersHeadingFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(32)
        case 320:
            return FontBook.mainFont.regular.size(24)
        default:
            return FontBook.mainFont.regular.size(29)
        }
    }()
    
    /// Font: e-Ukraine Regular 26px
    static var largeFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(29)
        case 320:
            return FontBook.mainFont.regular.size(22)
        default:
            return FontBook.mainFont.regular.size(26)
        }
    }()
    
    /// Font: e-Ukraine Regular 23px
    static var detailsTitleFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(26)
        case 320:
            return FontBook.mainFont.regular.size(20)
        default:
            return FontBook.mainFont.regular.size(23)
        }
    }()
    
    static var detailsTitleHeadFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.headingFont.regular.size(26)
        case 320:
            return FontBook.headingFont.regular.size(20)
        default:
            return FontBook.headingFont.regular.size(23)
        }
    }()
    
    /// Font: e-Ukraine Regular 21px
    static var cardsHeadingFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(24)
        case 320:
            return FontBook.mainFont.regular.size(18)
        default:
            return FontBook.mainFont.regular.size(21)
        }
    }()
    
    static var mediumTitleFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.medium.size(23)
        case 320:
            return FontBook.mainFont.medium.size(17)
        default:
            return FontBook.mainFont.medium.size(20)
        }
    }()
    
    /// Font: e-Ukraine Regular 20px
    static var largeTitleFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(23)
        case 320:
            return FontBook.mainFont.regular.size(17)
        default:
            return FontBook.mainFont.regular.size(20)
        }
    }()
    
    /// Font: e-Ukraine Regular 19px
    static var titleFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(22)
        case 320:
            return FontBook.mainFont.regular.size(16)
        default:
            return FontBook.mainFont.regular.size(19)
        }
    }()
    
    /// Font: e-Ukraine Regular 18px
    static var emptyStateTitleFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(24)
        case 320:
            return FontBook.mainFont.regular.size(16)
        default:
            return FontBook.mainFont.regular.size(18)
        }
    }()
    
    /// Font: e-Ukraine Regular 16px
    static var smallHeadingFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(18)
        case 320:
            return FontBook.mainFont.regular.size(14)
        default:
            return FontBook.mainFont.regular.size(16)
        }
    }()
    
    static var documentNumberHeadingFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.headingFont.regular.size(18)
        case 320:
            return FontBook.headingFont.regular.size(14)
        default:
            return FontBook.headingFont.regular.size(16)
        }
    }()
    
    static let lightSmallHeadingFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.light.size(18)
        case 320:
            return FontBook.mainFont.light.size(13)
        default:
            return FontBook.mainFont.light.size(16)
        }
    }()
    
    static var mediumHeadingFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.headingFont.regular.size(24)
        case 320:
            return FontBook.headingFont.regular.size(18)
        default:
            return FontBook.headingFont.regular.size(21)
        }
    }()
    
    /// Font: e-Ukraine Regular 14px
    static let bigText: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(16)
        case 320:
            return FontBook.mainFont.regular.size(12)
        default:
            return FontBook.mainFont.regular.size(14)
        }
    }()
    
    /// Font: e-Ukraine Regular 11px
    static var statusFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(12)
        case 320:
            return FontBook.mainFont.regular.size(10)
        default:
            return FontBook.mainFont.regular.size(11)
        }
    }()
    
    /// Font: e-Ukraine Regular 12px
    static var usualFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(13)
        case 320:
            return FontBook.mainFont.regular.size(10)
        default:
            return FontBook.mainFont.regular.size(12)
        }
    }()
    
    static var lightUsualFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.light.size(13)
        case 320:
            return FontBook.mainFont.light.size(10)
        default:
            return FontBook.mainFont.light.size(12)
        }
    }()
    
    static var lightNumberFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.light.size(26)
        case 320:
            return FontBook.mainFont.light.size(20)
        default:
            return FontBook.mainFont.light.size(23)
        }
    }()
    
    static var usualBoldFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.bold.size(13)
        case 320:
            return FontBook.mainFont.bold.size(10)
        default:
            return FontBook.mainFont.bold.size(12)
        }
    }()
    
    /// Font: e-Ukraine Regular 10px
    static var tabBarTitle: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(11)
        case 320:
            return FontBook.mainFont.regular.size(10)
        default:
            return FontBook.mainFont.regular.size(10)
        }
    }()
    
    /// Font: e-Ukraine Regular 9px
    static var smallTitle: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(11)
        case 320:
            return FontBook.mainFont.regular.size(8)
        default:
            return FontBook.mainFont.regular.size(9)
        }
    }()
    
    /// Font: e-Ukraine Regular 13px
    static let emojiFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(14)
        case 320:
            return FontBook.mainFont.regular.size(11)
        default:
            return FontBook.mainFont.regular.size(13)
        }
    }()
    
    /// Font: e-Ukraine Regular 38px
    static let grandTextFont: UIFont = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return FontBook.mainFont.regular.size(42)
        case 320:
            return FontBook.mainFont.regular.size(34)
        default:
            return FontBook.mainFont.regular.size(38)
        }
    }()
}
