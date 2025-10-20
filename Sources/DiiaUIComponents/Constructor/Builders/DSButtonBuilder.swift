
import UIKit
import DiiaCommonTypes

public struct DSPrimaryButtonBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnPrimaryDefaultAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let button = DSPrimaryDefaultButton()
        button.titleLabel?.font = FontBook.bigText
        let vm = DSLoadingButtonViewModel(title: data.label, state: .enabled)
        vm.callback = { [weak vm] in
            guard let action = data.action, let vm = vm else { return }
            eventHandler(.buttonAction(parameters: action, viewModel: vm))
        }
        button.configure(viewModel: vm)
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        button.withHeight(Constants.buttonHeight)
        let paddingBox = BoxView(subview: button).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey), centeredX: true)
        return paddingBox
    }
}

extension DSPrimaryButtonBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSButtonModel(
            label: "label",
            state: DSButtonState.enabled,
            action: DSActionParameter(
                type: "type",
                subtype: "subtype",
                resource: "resource",
                subresource: "subresource"),
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

public struct DSPrimaryWideButtonBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnPrimaryWideAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let button = DSPrimaryDefaultButton()
        button.titleLabel?.font = FontBook.bigText
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        let vm = DSLoadingButtonViewModel(title: data.label, state: .enabled)
        vm.callback = { [weak vm] in
            guard let action = data.action, let vm = vm else { return }
            eventHandler(.buttonAction(parameters: action, viewModel: vm))
        }
        button.configure(viewModel: vm)
        button.withHeight(Constants.buttonHeight)
        let insets = (paddingType == .default) ? Constants.defaultPaddings : Constants.smallPaddings
        let paddingBox = BoxView(subview: button).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSPrimaryWideButtonBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSButtonModel(
            label: "label",
            state: DSButtonState.enabled,
            action: DSActionParameter(
                type: "type",
                subtype: "subtype",
                resource: "resource",
                subresource: "subresource"),
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

public struct DSPrimaryLargeButtonBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnPrimaryLargeAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let button = DSPrimaryDefaultButton()
        button.accessibilityIdentifier = data.componentId
        button.titleLabel?.font = FontBook.smallHeadingFont
        let vm = DSLoadingButtonViewModel(title: data.label, state: .enabled)
        vm.callback = { [weak vm] in
            guard let action = data.action, let vm = vm else { return }
            eventHandler(.buttonAction(parameters: action, viewModel: vm))
        }
        button.configure(viewModel: vm)
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        button.withHeight(Constants.buttonLargeHeight)
        let insets = (paddingType == .default) ? Constants.defaultPaddings : Constants.smallPaddings
        let paddingBox = BoxView(subview: button).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSPrimaryLargeButtonBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSButtonModel(
            label: "label",
            state: DSButtonState.enabled,
            action: DSActionParameter(
                type: "type",
                subtype: "subtype",
                resource: "resource",
                subresource: "subresource"),
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

public struct DSStrokeButtonBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnStrokeDefaultAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let button = ActionLoadingStateButton()
        button.accessibilityIdentifier = data.componentId
        button.setStyle(style: .light)
        button.setLoadingState(.enabled, withTitle: data.label)
        button.titleLabel?.font = FontBook.bigText
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        button.withHeight(Constants.buttonHeight)
        button.onClick = {
            guard let action = data.action else { return }
            eventHandler(.action(action))
        }
        
        let insets = (paddingType == .default) ? Constants.defaultPaddings : Constants.smallPaddings
        let paddingBox = BoxView(subview: button).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSStrokeButtonBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSButtonModel(
            label: "label",
            state: DSButtonState.enabled,
            action: DSActionParameter(
                type: "type",
                subtype: "subtype",
                resource: "resource",
                subresource: "subresource"),
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

public struct DSPlainButtonBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnPlainAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let button = ActionLoadingStateButton()
        button.setStyle(style: .plain)
        button.setLoadingState(.enabled, withTitle: data.label)
        button.titleLabel?.font = FontBook.bigText
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        button.withHeight(Constants.buttonHeight)
        button.onClick = {
            guard let action = data.action else { return }
            eventHandler(.action(action))
        }
        
        let insets = (paddingType == .default) ? Constants.defaultPaddings : Constants.smallPaddings
        let paddingBox = BoxView(subview: button).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSPlainButtonBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSButtonModel(
            label: "label",
            state: DSButtonState.enabled,
            action: DSActionParameter(
                type: "type",
                subtype: "subtype",
                resource: "resource",
                subresource: "subresource"),
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

public struct DSButtonLinkBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnLinkAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let button = DSLinkButton()
        button.setTitle(data.label)
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        button.withHeight(Constants.buttonHeight)
        button.onClick = {
            guard let action = data.action else { return }
            eventHandler(.action(action))
        }
        
        let insets = (paddingType == .default) ? Constants.defaultPaddings : Constants.smallPaddings
        let paddingBox = BoxView(subview: button).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSButtonLinkBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSButtonModel(
            label: "label",
            state: DSButtonState.enabled,
            action: DSActionParameter(
                type: "type",
                subtype: "subtype",
                resource: "resource",
                subresource: "subresource"),
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

public struct DSWhiteLargeButtonBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnWhiteLargeAtm"
    
    public let padding: UIEdgeInsets?
    
    public init(padding: UIEdgeInsets? = nil) {
        self.padding = padding
    }
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let button = DSPrimaryDefaultButton()
        button.titleLabel?.font = FontBook.smallHeadingFont
        let vm = DSLoadingButtonViewModel(title: data.label, state: .enabled)
        vm.callback = { [weak vm] in
            guard let action = data.action, let vm = vm else { return }
            eventHandler(.buttonAction(parameters: action, viewModel: vm))
        }
        button.configure(viewModel: vm)
        button.setStyle(style: .white)
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        button.withHeight(Constants.buttonLargeHeight)
        let buttonPadding = padding ?? paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: button).withConstraints(insets: buttonPadding)
        return paddingBox
    }
}

extension DSWhiteLargeButtonBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSButtonModel(
            label: "label",
            state: DSButtonState.enabled,
            action: DSActionParameter(
                type: "type",
                subtype: "subtype",
                resource: "resource",
                subresource: "subresource"),
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

public struct BtnStrokeWideAtmBuilder: DSViewBuilderProtocol {
    public let modelKey = "btnStrokeWideAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let button = ActionLoadingStateButton()
        button.accessibilityIdentifier = data.componentId
        button.setStyle(style: .light)
        button.setLoadingState(.enabled, withTitle: data.label)
        button.titleLabel?.font = FontBook.bigText
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        button.withHeight(Constants.buttonHeight)
        button.onClick = {
            guard let action = data.action else { return }
            eventHandler(.action(action))
        }
        
        let insets = (paddingType == .default) ? Constants.defaultPaddings : Constants.smallPaddings
        let paddingBox = BoxView(subview: button).withConstraints(insets: insets, centeredX: true)
        return paddingBox
    }
}

extension BtnStrokeWideAtmBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSButtonModel(
            label: "label",
            state: DSButtonState.enabled,
            action: DSActionParameter(
                type: "type",
                subtype: "subtype",
                resource: "resource",
                subresource: "subresource"),
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

// MARK: - Constants
private enum Constants {
    static let defaultPaddings = UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 24)
    static let smallPaddings = UIEdgeInsets(top: 8, left: 24, bottom: 0, right: 24)
    static let buttonEdgeInsets = UIEdgeInsets(top: 0, left: 62, bottom: 0, right: 62)
    static let buttonHeight: CGFloat = 48
    static let buttonLargeHeight: CGFloat = 56
    static let plainButtonHeight: CGFloat = 36
    static let buttonBorder: CGFloat = 2
}
