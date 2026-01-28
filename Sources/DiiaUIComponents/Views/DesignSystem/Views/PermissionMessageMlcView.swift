
import UIKit

public struct PermissionMessageMlcViewModel {
    public let title: String
    public let description: String
    public let primaryButton: DSLoadingButtonViewModel
    
    public init(title: String, description: String, primaryButton: DSLoadingButtonViewModel) {
        self.title = title
        self.description = description
        self.primaryButton = primaryButton
    }
}

/// design_system_code: permissionMessageMlc
public final class PermissionMessageMlcView: BaseCodeView {
    // MARK: - UI
    private let titleLabel = UILabel().withParameters(
        font: FontBook.smallHeadingFont,
        textColor: .white,
        numberOfLines: Constants.titleNumberOfLines,
        textAlignment: .center
    )
    private let descriptionLabel = UILabel().withParameters(
        font: FontBook.usualFont,
        textColor: .white,
        numberOfLines: 0,
        textAlignment: .center
    )
    private let primaryButton = DSPrimaryDefaultButton()
    private lazy var primaryButtonBox = BoxView(subview: primaryButton).withConstraints(insets: Constants.buttonPaddings)
    private lazy var mainVStack = UIStackView.create(
        views: [titleLabel, descriptionLabel, primaryButtonBox],
        spacing: Constants.mainStackSpacing,
        alignment: .center
    )
    private let container = UIView()
    
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    // MARK: - Properties
    public var scannerFrameSize: CGSize = Constants.scannerFrameSize {
        didSet {
            container.withSize(scannerFrameSize)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public override func setupSubviews() {
        addSubview(container)
        container.fillSuperview()
        container.backgroundColor = Constants.backgroundColor
        
        let box = BoxView(subview: mainVStack).withConstraints(insets: Constants.boxViewInsets)
        box.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(box)
        box.anchor(leading: container.leadingAnchor, trailing: container.trailingAnchor, padding: Constants.boxViewPaddings)
        box.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        setupPrimaryButton()
    }
    
    // MARK: - Public -
    public func configure(model: PermissionMessageMlc, eventHandler: ((ConstructorItemEvent) -> Void)?) {
        self.accessibilityIdentifier = model.componentId
        self.eventHandler = eventHandler
        
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        
        primaryButton.isHidden = model.btnPrimaryDefaultAtm == nil
        if let buttonModel = model.btnPrimaryDefaultAtm {
            primaryButton.accessibilityIdentifier = buttonModel.componentId
            let vm = DSLoadingButtonViewModel(title: buttonModel.label, state: .enabled, componentId: buttonModel.componentId)
            vm.callback = { [weak self, weak vm] in
                guard let action = buttonModel.action, let vm else { return }
                self?.eventHandler?(.buttonAction(parameters: action, viewModel: vm))
            }
            
            primaryButton.configure(viewModel: vm)
        }
    }
    
    public func configure(with viewModel: PermissionMessageMlcViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        primaryButton.configure(viewModel: viewModel.primaryButton)
    }
    
    // MARK: - Private -
    private func setupPrimaryButton() {
        primaryButton.titleLabel?.font = FontBook.usualFont
        primaryButton.contentEdgeInsets = Constants.buttonEdgeInsets
        primaryButton.withHeight(Constants.buttonHeight)
    }
}

// MARK: - Constants
private extension PermissionMessageMlcView {
    enum Constants {
        static let titleNumberOfLines: Int = 2
        static let mainStackSpacing: CGFloat = 8
        static let scannerFrameSize: CGSize = CGSize(width: 200, height: 200)
        static let backgroundColor = UIColor.black.withAlphaComponent(0.3)
        static let boxViewInsets: UIEdgeInsets = UIEdgeInsets(vertical: 16)
        static let boxViewPaddings: UIEdgeInsets = UIEdgeInsets(horizontal: 26)
        static let buttonPaddings = UIEdgeInsets(top: 8)
        static let buttonEdgeInsets = UIEdgeInsets(horizontal: 32, vertical: 10)
        static let buttonHeight: CGFloat = 36
    }
}
