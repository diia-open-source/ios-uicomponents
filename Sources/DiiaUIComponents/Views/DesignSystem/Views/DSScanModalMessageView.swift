
import UIKit

/// design_system_code: scanModalMessageOrg
public final class DSScanModalMessageView: BaseCodeView {
    private let iconCentre = DSIconView().withSize(Constants.iconCentreSize)
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont,
                                                      numberOfLines: Constants.titleNumberOfLines,
                                                      textAlignment: .center)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont,
                                                            numberOfLines: Constants.descriptionNumberOfLines,
                                                            textAlignment: .center)
    private let primaryButton = DSPrimaryDefaultButton()
    private let bottomIcon = DSIconView().withSize(Constants.bottomIconSize)
    
    private lazy var primaryButtonBox = BoxView(subview: primaryButton).withConstraints(insets: Constants.buttonPaddings)
    private lazy var mainVStack = UIStackView.create(
        views: [iconCentre, contentVStack, primaryButtonBox],
        spacing: Constants.mainStackSpacing,
        alignment: .center
    )
    private lazy var contentVStack = UIStackView.create(
        views: [titleLabel, descriptionLabel],
        spacing: Constants.contentStackSpacing,
        alignment: .center
    )
    
    // MARK: - Properties
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    // MARK: - Init
    public override func setupSubviews() {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = Constants.mainStackCornerRadius
        container.addSubview(mainVStack)
        mainVStack.fillSuperview(padding: Constants.mainStackPadding)
        
        addSubview(container)
        container.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor
        )
        
        addSubview(bottomIcon)
        bottomIcon.anchor(
            top: container.bottomAnchor,
            bottom: bottomAnchor,
            padding: Constants.bottomIconPadding
        )
        bottomIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    public func configure(model: ScanModalMessageOrgModel, eventHandler: ((ConstructorItemEvent) -> Void)?) {
        self.accessibilityIdentifier = model.componentId
        self.eventHandler = eventHandler
        
        iconCentre.isHidden = model.iconCentre == nil
        if let iconCentre = model.iconCentre {
            self.iconCentre.setIcon(iconCentre)
        }
        
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        
        primaryButtonBox.isHidden = model.btnPrimaryDefaultAtm == nil
        if let primaryButton = model.btnPrimaryDefaultAtm {
            configurePrimaryButton(with: primaryButton)
        }
        
        bottomIcon.isHidden = model.mediumIconAtm == nil
        if let bottomIcon = model.mediumIconAtm {
            self.bottomIcon.setIcon(bottomIcon)
            self.bottomIcon.onClick = { [weak self] action in
                guard let action else { return }
                self?.eventHandler?(.action(action))
            }
        }
    }
    
    // MARK: - Private
    private func configurePrimaryButton(with model: DSButtonModel) {
        primaryButton.titleLabel?.font = FontBook.bigText
        primaryButton.accessibilityIdentifier = model.componentId
        primaryButton.contentEdgeInsets = Constants.buttonEdgeInsets
        primaryButton.withHeight(Constants.buttonHeight)
        let vm = DSLoadingButtonViewModel(title: model.label, state: .enabled, componentId: model.componentId)
        vm.callback = { [weak self, weak vm] in
            guard let action = model.action, let vm else { return }
            self?.eventHandler?(.buttonAction(parameters: action, viewModel: vm))
        }
        
        primaryButton.configure(viewModel: vm)
    }
}

// MARK: - Constants
private extension DSScanModalMessageView {
    enum Constants {
        static let iconCentreSize = CGSize(width: 32, height: 32)
        static let bottomIconSize = CGSize(width: 48, height: 48)
        static let mainStackSpacing: CGFloat = 16
        static let mainStackPadding = UIEdgeInsets(horizontal: 24, vertical: 24)
        static let mainStackCornerRadius: CGFloat = 16
        static let contentStackSpacing: CGFloat = 8
        static let titleNumberOfLines = 3
        static let descriptionNumberOfLines = 8
        static let buttonPaddings = UIEdgeInsets(top: 16)
        static let buttonEdgeInsets = UIEdgeInsets(horizontal: 61.5, vertical: 16)
        static let buttonHeight: CGFloat = 48
        static let bottomIconPadding = UIEdgeInsets(top: 24)
    }
}
