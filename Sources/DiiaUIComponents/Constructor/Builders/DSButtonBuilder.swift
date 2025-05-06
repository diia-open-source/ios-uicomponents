
import UIKit
import DiiaCommonTypes

public struct DSPrimaryButtonBuilder: DSViewBuilderProtocol {
    public static let modelKey = "btnPrimaryDefaultAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
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
        let stackView = UIStackView.create(.vertical, alignment: .center)
        stackView.addArrangedSubview(button)
        let insets = (paddingType == .default) ? Constants.defaultPaddings : Constants.smallPaddings
        let paddingBox = BoxView(subview: stackView).withConstraints(insets: insets)
        return paddingBox
    }
}

public struct DSPrimaryWideButtonBuilder: DSViewBuilderProtocol {
    public static let modelKey = "btnPrimaryWideAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
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

public struct DSPrimaryLargeButtonBuilder: DSViewBuilderProtocol {
    public static let modelKey = "btnPrimaryLargeAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
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

public struct DSStrokeButtonBuilder: DSViewBuilderProtocol {
    public static let modelKey = "btnStrokeDefaultAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
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

public struct DSPlainButtonBuilder: DSViewBuilderProtocol {
    public static let modelKey = "btnPlainAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
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

public struct DSButtonLinkBuilder: DSViewBuilderProtocol {
    public static let modelKey = "btnLinkAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
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

public struct DSWhiteLargeButtonBuilder: DSViewBuilderProtocol {
    public static let modelKey = "btnWhiteLargeAtm"
    
    public let padding: UIEdgeInsets?
    
    public init(padding: UIEdgeInsets? = nil) {
        self.padding = padding
    }
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
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
        let buttonPadding = padding ?? paddingType.defaultPadding()
        let paddingBox = BoxView(subview: button).withConstraints(insets: buttonPadding)
        return paddingBox
    }
}

public struct BtnStrokeWideAtmBuilder: DSViewBuilderProtocol {
    public static let modelKey = "btnStrokeWideAtm"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSButtonModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
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
