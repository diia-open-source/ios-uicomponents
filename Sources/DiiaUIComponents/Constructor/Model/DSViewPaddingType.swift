
import UIKit

public enum DSViewPaddingType: Equatable {
    case `default`
    case firstComponent
    case custom(paddings: UIEdgeInsets)
    
    public func defaultPadding() -> UIEdgeInsets {
        switch self {
        case .default:
            return .init(top: 24, left: 24, bottom: 0, right: 24)
        case .firstComponent:
            return .init(top: 8, left: 24, bottom: 0, right: 24)
        case .custom(let paddings):
            return paddings
        }
    }
    
    public func shortPadding() -> UIEdgeInsets {
        switch self {
        case .default:
            return .init(top: 16, left: 24, bottom: 0, right: 24)
        case .firstComponent:
            return .init(top: 8, left: 24, bottom: 0, right: 24)
        case .custom(let paddings):
            return paddings
        }
    }
    
    public func defaultCollectionPadding() -> UIEdgeInsets {
        switch self {
        case .default:
            return .init(top: 24, left: 0, bottom: 0, right: 0)
        case .firstComponent:
            return .init(top: 8, left: 0, bottom: 0, right: 0)
        case .custom(let paddings):
            return paddings
        }
    }
}
