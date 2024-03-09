import UIKit

public enum DocumentsLayoutProvider {
    
    public static var topInset: CGFloat = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return 32
        case 320:
            return 24
        default:
            return 28
        }
    }()
    
    public static var interitemInset: CGFloat = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return 10
        case 320:
            return 7
        default:
            return 8
        }
    }()
    
    public static let sideSpacing: CGFloat = 16
    public static let buttonHeight: CGFloat = 48
    
    public static let cardBottomShadowOffset: CGFloat = 30
    public static let cardHeightToWidthProportion: CGFloat = 1.528
    public static let cardWidth = UIScreen.main.bounds.width - 4 * cardInteritemSpacing
    public static let columnProportion = 0.4308
    public static let docPhotoProportion: CGFloat = 4/3
    public static let cardHeight = cardWidth * cardHeightToWidthProportion
    public static var cardInteritemSpacing: CGFloat  = {
        switch UIScreen.main.bounds.width {
        case 414, 428, 430:
            return 18
        default:
            return 16
        }
    }()
    public static let centeredButtonInset: CGFloat = 3 * topInset
    
    public static let cardCornerRadius: CGFloat = 24
    
    public static var moreButtonIconHeight: CGFloat {
        switch UIDevice.size() {
        case .screen4Inch, .screen_zoomed:
            return 24
        case .screen6_7Inch, .screen6_5Inch, .screen5_5Inch:
            return 31
        default:
            return 28
        }
    }
    
    public static var moreButtonBottomInset: CGFloat {
        switch UIDevice.size() {
        case .screen4Inch, .screen_zoomed:
            return 26
        case .screen6_7Inch, .screen6_5Inch, .screen5_5Inch:
            return 32
        default:
            return 30
        }
    }
    
    public static let moreButtonHeight: CGFloat = moreButtonIconHeight + 2 * moreButtonBottomInset
    public static let moreButtonContentInsets: UIEdgeInsets = .init(
        top: moreButtonBottomInset,
        left: 44 - moreButtonIconHeight,
        bottom: moreButtonBottomInset,
        right: 16
    )
}
