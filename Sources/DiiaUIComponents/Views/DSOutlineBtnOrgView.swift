import UIKit


///DS_Code: outlineButtonOrg
public struct DSOutlineButtonOrg: Codable {
    public let componentId: String
    public let items: [DSOutlineButtonItem]
    
    public init(componentId: String, items: [DSOutlineButtonItem]) {
        self.componentId = componentId
        self.items = items
    }
}

///DS_Code: outlineButtonMlc
public struct DSOutlineButtonMlc: Codable {
    public let componentId: String
    public let title: String?
    public let iconLeft: DSIconModel?
    public let action: DSActionParameter?
    
    public init(componentId: String, title: String?, iconLeft: DSIconModel?, action: DSActionParameter?) {
        self.componentId = componentId
        self.title = title
        self.iconLeft = iconLeft
        self.action = action
    }
}

public struct DSOutlineButtonItem: Codable {
    public let outlineButtonMlc: DSOutlineButtonMlc?

    public init(outlineButtonMlc: DSOutlineButtonMlc?) {
        self.outlineButtonMlc = outlineButtonMlc
    }
}

public class DSOutlineBtnOrgView: BaseCodeView {
    private let stackView = UIStackView.create()
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    public override func setupSubviews() {
        addSubview(stackView)
        stackView.fillSuperview(padding: Constants.padding)
        stackView.spacing = Constants.spacing
        withBorder(width: Constants.borderWidth, color: .white, cornerRadius: Constants.cornerRadius)
    }
    
    public func configure(model: DSOutlineButtonOrg) {
        accessibilityIdentifier = model.componentId
        
        for (index, outlineButton) in model.items.enumerated() {
            guard let btnModel = outlineButton.outlineButtonMlc else { return }
            let btn = createOutlineButton(
                model: btnModel)
            stackView.addArrangedSubview(btn)
            if index < model.items.count - 1 {
                stackView.addArrangedSubview(separator())
            }
        }
    }
    
    public func setEventHandler(_ eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }
    
    private func createOutlineButton(model: DSOutlineButtonMlc) -> IconedLoadingStateView {
        let viewModel = IconedLoadingStateViewModel(
            name: model.title ?? .empty,
            image: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: model.iconLeft?.code) ?? UIImage(),
            componentId: model.componentId,
            loadingImage: R.image.blackGradientSpinner.image)
        viewModel.clickHandler = { [weak self, weak viewModel] in
            if let action = model.action, let vm = viewModel {
                self?.eventHandler?(.buttonLoadIconAction(parameters: action, viewModel: vm))
            }
        }
        let button = IconedLoadingStateView()
        button.setupUI(alignment: .center, titleFont: FontBook.usualFont.withSize(Constants.fontSize))
        button.configure(viewModel: viewModel)
        
        return button
    }
    
    private func separator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .white
        separator.withHeight(1)
        let boxView = BoxView(subview: separator).withConstraints(insets: Constants.separatorPadding)
        return boxView
    }
}

private extension DSOutlineBtnOrgView {
    enum Constants {
        static let spacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let separatorPadding: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        static let borderWidth: CGFloat = 2
        static let padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let fontSize: CGFloat = 14
    }
}
