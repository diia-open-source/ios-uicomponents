
import UIKit
import DiiaCommonTypes

public enum DSViewPaddingType: Equatable {
    case `default`
    case firstComponent
    case fixed(paddings: UIEdgeInsets)
    
    public func defaultPadding(object: AnyCodable? = nil, modelKey: String? = nil) -> UIEdgeInsets {
        let model = DSPaddingsModel.createFromJSON(object, modelKey: modelKey)
        return defaultPadding(paddingsModel: model)
    }
    
    public func defaultPadding(paddingsModel: DSPaddingsModel?) -> UIEdgeInsets {
        switch self {
        case .default:
            return calculatedInsets(for: paddingsModel, defaultInsets: .init(top: 24, left: 24, bottom: 0, right: 24))
        case .firstComponent:
            return calculatedInsets(for: paddingsModel, defaultInsets: .init(top: 8, left: 24, bottom: 0, right: 24))
        case .fixed(let paddings):
            return paddings
        }
    }
    
    public func shortPadding(object: AnyCodable? = nil, modelKey: String?) -> UIEdgeInsets {
        let model = DSPaddingsModel.createFromJSON(object, modelKey: modelKey)
        return shortPadding(paddingsModel: model)
    }
    
    public func shortPadding(paddingsModel: DSPaddingsModel?) -> UIEdgeInsets {
        switch self {
        case .default:
            return calculatedInsets(for: paddingsModel, defaultInsets: .init(top: 16, left: 24, bottom: 0, right: 24))
        case .firstComponent:
            return calculatedInsets(for: paddingsModel, defaultInsets: .init(top: 8, left: 24, bottom: 0, right: 24))
        case .fixed(let paddings):
            return paddings
        }
    }
    
    public func defaultPaddingV2(object: AnyCodable? = nil, modelKey: String? = nil) -> UIEdgeInsets {
        let model = DSPaddingsModel.createFromJSON(object, modelKey: modelKey)
        return defaultPaddingV2(paddingsModel: model)
    }
    
    public func defaultPaddingV2(paddingsModel: DSPaddingsModel?) -> UIEdgeInsets {
        switch self {
        case .default, .firstComponent:
            return calculatedInsets(for: paddingsModel, defaultInsets: .init(top: 8, left: 16, bottom: 0, right: 16))
        case .fixed(let paddings):
            return paddings
        }
    }
    
    public func defaultCollectionPadding(object: AnyCodable? = nil, modelKey: String?) -> UIEdgeInsets {
        let model = DSPaddingsModel.createFromJSON(object, modelKey: modelKey)
        return defaultCollectionPadding(paddingsModel: model)
    }
    
    public func defaultCollectionPadding(paddingsModel: DSPaddingsModel?) -> UIEdgeInsets {
        var insets = UIEdgeInsets.zero
        switch self {
        case .default:
            insets = .init(top: 24, left: 0, bottom: 0, right: 0)
        case .firstComponent:
            insets = .init(top: 8, left: 0, bottom: 0, right: 0)
        case .fixed(let paddings):
            return paddings
        }
        
        if let topPaddingSize: DSSizingType = paddingsModel?.top {
            insets.top = topPaddingSize.verticalSize
        }
        
        return insets
    }
    
    public func insets(for object: AnyCodable?, modelKey: String?, defaultInsets: UIEdgeInsets) -> UIEdgeInsets {
        let model: DSPaddingsModel?
        if let modelKey {
            model = object?.getValue(forKey: modelKey)?.parseValue(forKey: Constants.paddingsKey)
        } else {
            model = object?.parseValue(forKey: Constants.paddingsKey)
        }
        return calculatedInsets(for: model, defaultInsets: defaultInsets)
    }
    
    private func calculatedInsets(for paddingsModel: DSPaddingsModel?, defaultInsets: UIEdgeInsets) -> UIEdgeInsets {
        var leftInset = defaultInsets.left
        var rightInset = defaultInsets.right
        var topInset = defaultInsets.top
        let bottomInset = defaultInsets.bottom
        
        if let sidePaddingSize: DSSizingType = paddingsModel?.side {
            leftInset = sidePaddingSize.horizontalSize
            rightInset = sidePaddingSize.horizontalSize
        }
        
        if let topPaddingSize: DSSizingType = paddingsModel?.top {
            topInset = topPaddingSize.verticalSize
        }
        
        return .init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
    
    private enum Constants {
        static let paddingsKey = "paddingMode"
    }
}

public enum DSSizingType: String, Codable {
    case none, medium, large
    
    var horizontalSize: CGFloat {
        switch self {
        case .none:
            return 0
        case .medium:
            return 16
        case .large:
            return 24
        }
    }
    
    var verticalSize: CGFloat {
        switch self {
        case .none:
            return 0
        case .medium:
            return 8
        case .large:
            return 16
        }
    }
}

public struct DSPaddingsModel: Codable {
    public let top: DSSizingType?
    public let side: DSSizingType?
    
    public init(top: DSSizingType?, side: DSSizingType?) {
        self.top = top
        self.side = side
    }
    
    static func createFromJSON(_ json: AnyCodable?, modelKey: String? = nil) -> DSPaddingsModel? {
        let model: DSPaddingsModel?
        if let modelKey {
            model = json?.getValue(forKey: modelKey)?.parseValue(forKey: Constants.paddingsKey)
        } else {
            model = json?.parseValue(forKey: Constants.paddingsKey)
        }
        return model
    }
    
    private enum Constants {
        static let paddingsKey = "paddingMode"
    }
}

protocol DSPaddingModeDependedViewProtocol {
    func setupPaddingMode(_ padding: DSPaddingsModel)
}
