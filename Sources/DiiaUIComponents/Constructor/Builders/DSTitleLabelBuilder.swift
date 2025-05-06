
import UIKit
import DiiaCommonTypes

/// design_system_code: titleLabelMlc
public struct DSTitleLabelBuilder: DSViewBuilderProtocol {
    public static let modelKey = "titleLabelMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTitleLabelMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let label = UILabel().withParameters(font: FontBook.detailsTitleFont)
        label.text = data.label
        label.accessibilityIdentifier = data.componentId
        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: label).withConstraints(insets: insets)
        return paddingBox
    }
}

/// design_system_code: subtitleLabelMlc
public struct DSSubtitleLabelBuilder: DSViewBuilderProtocol {
    public static let modelKey = "subtitleLabelMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSubtitleLabelMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSSubtitleLabelMlcView()
        view.accessibilityIdentifier = data.componentId
        view.configure(model: data)
        
        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

/// design_system_code: sectionTitleAtm
public struct DSSectionTitleBuilder: DSViewBuilderProtocol {
    public static let modelKey = "sectionTitleAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTitleLabelMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let label = UILabel().withParameters(font: FontBook.bigText)
        label.text = data.label
        
        label.isAccessibilityElement = true
        label.accessibilityTraits = .header
        label.accessibilityLabel = data.label
        
        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: label).withConstraints(insets: insets)
        return paddingBox
    }
}
