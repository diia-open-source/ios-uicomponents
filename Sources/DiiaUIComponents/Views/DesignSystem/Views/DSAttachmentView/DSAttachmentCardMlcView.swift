
import UIKit
import DiiaCommonTypes

public struct DSAttachmentCardMlc: Codable {
    let attachmentCardMlc: DSAttachmentCard?
}

public struct DSAttachmentCard: Codable {
    public let componentId: String
    public let id: String
    public let chipStatusAtm: DSCardStatusChipModel?
    public let iconRight: DSIconModel?
    public let label: String
    public let description: String?
    public let key: DSAttachmentCardKey?
    public let btnIconPlainGroupMlc: DSBtnIconPlainGroupMlc?
}

public struct DSAttachmentCardKey: Codable {
    public let id: String
    public let label: String
    public let description: String?
    public let iconRight: DSIconModel?
}

//ds_code: attachmentCardMlc
final public class DSAttachmentCardMlcView: BaseCodeView {
    private let mainStack = UIStackView.create(.vertical, spacing: Constants.mainSpacing)
    private let statusStackView = UIStackView.create(.horizontal, alignment: .center)
    private let labelDescriptionStackView = UIStackView.create(.vertical, spacing: Constants.smallSpacing)
    private let keyContentVStack = UIStackView.create(.vertical, spacing: Constants.mainSpacing)
    private let separatorView = DSSeparatorView()
    private let textLabel = UILabel().withParameters(font: Constants.textLabelFont)
    private let descriptionLabel = UILabel().withParameters(font: Constants.descriptionLabelFont, textColor: Constants.descriptionLabelTextColor)
    private let deleteIcon = DSIconView()
    private let chipStatusView = DSChipStatusAtmView()
    private let addKeyButton = BorderedActionsView()
    private let keyItem = DSListItemView()
    
    // MARK: - Properties
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    // MARK: - Lifecycle
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.paddings)
        mainStack.addArrangedSubviews([
            statusStackView,
            labelDescriptionStackView,
            keyContentVStack,
            addKeyButton
        ])
        
        statusStackView.addArrangedSubviews([
            chipStatusView,
            deleteIcon
        ])
        
        labelDescriptionStackView.addArrangedSubviews([
            textLabel,
            descriptionLabel
        ])
        
        keyContentVStack.addArrangedSubviews([
            separatorView,
            keyItem
        ])
        keyItem.setupUI(stackPadding: .zero)
        self.layer.cornerRadius = Constants.cornerRadius
        self.backgroundColor = .white
    }
    
    // MARK: - Public
    public func configure(with model: DSAttachmentCardMlc, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.accessibilityIdentifier = model.attachmentCardMlc?.componentId
        self.eventHandler = eventHandler
        
        chipStatusView.isHidden = model.attachmentCardMlc?.chipStatusAtm == nil
        if let chipStatusAtm = model.attachmentCardMlc?.chipStatusAtm {
            chipStatusView.configure(for: chipStatusAtm)
        }
        
        deleteIcon.isHidden = model.attachmentCardMlc?.iconRight == nil
        if let iconRight = model.attachmentCardMlc?.iconRight {
            deleteIcon.setIcon(iconRight)
        }
        statusStackView.isHidden = model.attachmentCardMlc?.chipStatusAtm == nil && model.attachmentCardMlc?.iconRight == nil
        
        textLabel.text = model.attachmentCardMlc?.label
        descriptionLabel.isHidden = model.attachmentCardMlc?.description == nil
        descriptionLabel.text = model.attachmentCardMlc?.description
        
        keyItem.isHidden = model.attachmentCardMlc?.key == nil
        separatorView.isHidden = model.attachmentCardMlc?.key == nil
        if let key = model.attachmentCardMlc?.key {
            keyItem.configure(viewModel: DSListItemViewModel(title: key.label,
                                                             details: key.description,
                                                             rightIcon: UIComponentsConfiguration.shared.imageProvider.imageForCode(
                                                                imageCode: key.iconRight?.code),
                                                             onClick: { [weak self] in
                guard let action = key.iconRight?.action else { return }
                self?.eventHandler?(.action(action))
            }))
        }
        
        addKeyButton.isHidden = model.attachmentCardMlc?.btnIconPlainGroupMlc == nil
        if let addButton = model.attachmentCardMlc?.btnIconPlainGroupMlc {
            let iconVMs = addButton.items.map { button in
                let viewModel = IconedLoadingStateViewModel(
                    name: button.btnPlainIconAtm.label,
                    image: UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: button.btnPlainIconAtm.icon) ?? UIImage(),
                    componentId: button.btnPlainIconAtm.componentId)
                if let action = button.btnPlainIconAtm.action {
                    viewModel.clickHandler = { [weak self] in
                        self?.eventHandler?(.buttonLoadIconAction(
                            parameters: action,
                            viewModel: viewModel))
                    }
                }
                return viewModel
            }
            addKeyButton.configureView(with: iconVMs)
        }
    }
}

private extension DSAttachmentCardMlcView {
    enum Constants {
        static let paddings: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let cornerRadius: CGFloat = 10
        static let mainSpacing: CGFloat = 16
        static let smallSpacing: CGFloat = 4
        static let textLabelFont = FontBook.usualFont.withSize(14)
        static let descriptionLabelFont = FontBook.usualFont.withSize(12)
        static let descriptionLabelTextColor: UIColor = .black.withAlphaComponent(0.54)
    }
}
