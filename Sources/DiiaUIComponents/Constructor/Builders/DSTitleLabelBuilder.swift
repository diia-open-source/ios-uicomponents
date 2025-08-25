
import UIKit
import DiiaCommonTypes

/// design_system_code: titleLabelMlc
public struct DSTitleLabelBuilder: DSViewBuilderProtocol {
    public let modelKey = "titleLabelMlc"
    
    public let padding: UIEdgeInsets?
    
    public init(padding: UIEdgeInsets? = nil) {
        self.padding = padding
    }
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTitleLabelMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let label = UILabel().withParameters(font: FontBook.cardsHeadingFont)
        label.text = data.label
        label.accessibilityIdentifier = data.componentId
        let insets = padding ?? paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: label).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSTitleLabelBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTitleLabelMlc(label: "label", componentId: "componentId")
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

/// design_system_code: subtitleLabelMlc
public struct DSSubtitleLabelBuilder: DSViewBuilderProtocol {
    public let modelKey = "subtitleLabelMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSubtitleLabelMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSSubtitleLabelMlcView()
        view.accessibilityIdentifier = data.componentId
        view.configure(model: data)
        
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSSubtitleLabelBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSSubtitleLabelMlc(
            label: "label",
            icon: "icon",
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

/// design_system_code: sectionTitleAtm
public struct DSSectionTitleBuilder: DSViewBuilderProtocol {
    public let modelKey = "sectionTitleAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTitleLabelMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let label = UILabel().withParameters(font: FontBook.bigText)
        label.text = data.label
        
        label.isAccessibilityElement = true
        label.accessibilityTraits = .header
        label.accessibilityLabel = data.label
        
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: label).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSSectionTitleBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTitleLabelMlc(label: "label", componentId: "componentId")
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
