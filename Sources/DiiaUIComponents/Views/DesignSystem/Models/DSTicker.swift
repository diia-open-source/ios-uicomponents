
import UIKit
import DiiaCommonTypes

public struct DSTickerAtom: Codable, Equatable {
    public let usage: DSTickerUsage
    public let type: DSTickerType
    public let value: String
    public let action: DSActionParameter?
    public let componentId: String?

    public init(usage: DSTickerUsage, type: DSTickerType, value: String, action: DSActionParameter? = nil, componentId: String? = nil) {
        self.usage = usage
        self.type = type
        self.value = value
        self.action = action
        self.componentId = componentId
    }
}

public enum DSTickerUsage: String, Codable, Equatable {
    case document, stackedCard, bodyOrg, grand

    var height: CGFloat {
        switch self {
        case .document, .bodyOrg, .grand:
            return 32
        case .stackedCard:
            return 24
        }
    }
}

public enum DSTickerType: String, Codable, EnumDecodable, Equatable {
    public static var defaultValue: DSTickerType = .neutral
    
    case neutral, positive, informative, warning, negative, pink, rainbow, blue
    
    var backgroundImage: UIImage {
        switch self {
        case .neutral:
            return UIImage.from(color: UIColor(AppConstants.Colors.tickerGrayColor))
        case .positive:
            return R.image.insuranceBar.image ?? UIImage()
        case .informative:
            return UIImage.from(color: UIColor(AppConstants.Colors.tickerBlueColor))
        case .warning:
            return UIImage.from(color: UIColor(AppConstants.Colors.yellowErrorColor))
        case .negative:
            return UIImage.from(color: UIColor(AppConstants.Colors.tickerRedColor))
        case .blue:
            return UIImage.gradientImage(with: Constants.gradientBlueColors,
                                         size: Constants.tickerSize)
        case .rainbow:
            return UIImage.gradientImage(with: Constants.gradientRainbowColors,
                                         size: Constants.tickerSize)
        case .pink:
            return UIImage.gradientImage(with: Constants.gradientPinkColors,
                                         size: Constants.tickerSize)
        }
    }
    
    var textColor: UIColor {
        if self == .negative {
            return .white
        }
        return .black
    }
}

extension DSTickerType {
    enum Constants {
        static let gradientBlueColors = [UIColor("#A9CEE7"),UIColor("#4BB3FE")]
        static let gradientPinkColors = [UIColor("#FF3974"),UIColor("#FF6262")]
        static let gradientRainbowColors = [UIColor("#FC2C78"),UIColor("#FFD15C"), UIColor("#4EE89E"), UIColor("#993FC3")]
        static let tickerSize = CGSize(width: 300, height: 32)
    }
}
