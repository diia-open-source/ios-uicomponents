
import UIKit

public struct DSLinkSettingsOrg: Codable {
    public let componentId: String
    public let label: String?
    public let linkSharingMlc: DSLinkSharingMlcModel?
    public let description: String?
    public let btnPrimaryPlainIconAtm: DSBtnPrimaryPlainIconAtm?
    public let btnIconPlainGroupMlc: DSBtnIconPlainGroupMlc?
    
    public init(componentId: String,
                label: String?,
                linkSharingMlc: DSLinkSharingMlcModel?,
                description: String?,
                btnPrimaryPlainIconAtm: DSBtnPrimaryPlainIconAtm?,
                btnIconPlainGroupMlc: DSBtnIconPlainGroupMlc?) {
        self.componentId = componentId
        self.label = label
        self.linkSharingMlc = linkSharingMlc
        self.description = description
        self.btnPrimaryPlainIconAtm = btnPrimaryPlainIconAtm
        self.btnIconPlainGroupMlc = btnIconPlainGroupMlc
    }
}

//MARK: - ds_code: linkSettingsOrg
public final class DSLinkSettingsView: BaseCodeView {
    private let mainStack = UIStackView.create(.vertical, spacing: Constants.spacing)
    private let linkSharingStack = UIStackView.create(.vertical, spacing: Constants.smallSpacing)
    private let buttonStack = UIStackView.create(.vertical, spacing: Constants.smallSpacing)
    private let linkShareView = DSLinkSharingMlcView()
    private let titleLabel = UILabel().withParameters(font: Constants.titleLabelFont, textAlignment: .center)
    private let descriptionLabel = UILabel().withParameters(font: Constants.descriptionLabelFont, textAlignment: .center)
    private let separatorView = DSSeparatorView()
    private let primaryPlainButton = DSBtnPrimaryPlainIconView()
    private let plainGroupButton = BorderedActionsView()
    
    //MARK: Lifecycle
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.padding)
        linkSharingStack.addArrangedSubviews([
            linkShareView,
            separatorView,
            descriptionLabel
        ])
        
        buttonStack.addArrangedSubviews([
            primaryPlainButton,
            plainGroupButton
        ])
        
        mainStack.addArrangedSubviews([
            titleLabel,
            linkSharingStack,
            buttonStack
        ])
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.cornerRadius
    }
    
    //MARK: Public methods
    public func configure(with model: DSLinkSettingsOrg, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        accessibilityIdentifier = model.componentId
        
        titleLabel.isHidden = model.label == nil
        titleLabel.text = model.label
        
        linkShareView.isHidden = model.linkSharingMlc == nil
        if let linkSharing = model.linkSharingMlc {
            linkShareView.configure(with: linkSharing, eventHandler: eventHandler)
        }
        
        descriptionLabel.isHidden = model.description == nil
        descriptionLabel.text = model.description
        
        primaryPlainButton.isHidden = model.btnPrimaryPlainIconAtm == nil
        if let primaryPlainButtonModel = model.btnPrimaryPlainIconAtm {
            primaryPlainButton.configure(with: primaryPlainButtonModel, eventHandler: eventHandler)
        }
        
        plainGroupButton.isHidden = model.btnIconPlainGroupMlc == nil
        if let plainGroupButtonModel = model.btnIconPlainGroupMlc {
            let iconVMs = plainGroupButtonModel.items.map { button in
                let viewModel = IconedLoadingStateViewModel(
                    name: button.btnPlainIconAtm.label,
                    image: UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: button.btnPlainIconAtm.icon) ?? UIImage(),
                    componentId: button.btnPlainIconAtm.componentId)
                if let action = button.btnPlainIconAtm.action {
                    viewModel.clickHandler = {
                        eventHandler(.action(action))
                    }
                }
                return viewModel
            }
            plainGroupButton.configureView(with: iconVMs)
            plainGroupButton.setupUI(stackSpacing: Constants.smallSpacing, alignment: .center)
        }
    }
}

private extension DSLinkSettingsView {
    enum Constants {
        static let spacing: CGFloat = 24
        static let smallSpacing: CGFloat = 8
        static let titleLabelFont = FontBook.usualFont.withSize(12)
        static let descriptionLabelFont = FontBook.usualFont.withSize(11)
        static let padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let cornerRadius: CGFloat = 10
    }
}
