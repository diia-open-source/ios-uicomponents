
import UIKit
import DiiaCommonTypes

public struct TransparentInfoCardMlcModel: Codable {
    public let componentId: String
    public let label: String
    public let chipStatusAtm: DSCardStatusChipModel?
    public let rows: [RowModel]?
    public let bottomLeftLabel: BottomLeftModel?
    public let bottomRightLabel: BottomRightModel?
    public let action: DSActionParameter?
    public let description: String?
    
    public init(componentId: String, label: String, chipStatusAtm: DSCardStatusChipModel?, rows: [RowModel]?, bottomLeftLabel: BottomLeftModel?, bottomRightLabel: BottomRightModel?, action: DSActionParameter?, description: String?) {
        self.componentId = componentId
        self.label = label
        self.chipStatusAtm = chipStatusAtm
        self.rows = rows
        self.bottomLeftLabel = bottomLeftLabel
        self.bottomRightLabel = bottomRightLabel
        self.action = action
        self.description = description
    }
    
    public struct RowModel: Codable {
        public let iconLeft: DSIconModel?
        public let label: String
        public let value: String?
        
        public init(iconLeft: DSIconModel?, label: String, value: String?) {
            self.iconLeft = iconLeft
            self.label = label
            self.value = value
        }
    }

    public struct BottomLeftModel: Codable {
        public let text: String?
        public let additionalText: AdditionalText?
        
        public init(text: String?, additionalText: AdditionalText?) {
            self.text = text
            self.additionalText = additionalText
        }
        
        public struct AdditionalText: Codable {
            public let text: String?
            public let isStrikethrough: Bool?
            
            public init(text: String?, isStrikethrough: Bool?) {
                self.text = text
                self.isStrikethrough = isStrikethrough
            }
        }
    }

    public struct BottomRightModel: Codable {
        public let text: String?
        public let iconRight: DSIconModel?
        
        public init(text: String?, iconRight: DSIconModel?) {
            self.text = text
            self.iconRight = iconRight
        }
    }
}

final public class TransparentInfoCardMlcView: BaseCodeView {
    private lazy var mainStack = UIStackView.create(views: [container, descriptionLabel], spacing: Constants.spacing)
    private let container = UIView()
    private let rowsStack = UIStackView.create(spacing: Constants.spacing)
    
    private let chipStatusContainer = UIView()
    private let chipStatusView = DSChipView()
    private let label = UILabel().withParameters(font: FontBook.mainFont.regular.size(14))

    private lazy var rightBottomStack = UIStackView.create(
        .horizontal,
        views: [rightBottomLabel, rightBottomIcon],
        spacing: Constants.spacing,
        alignment: .center
    )
    private lazy var leftBottomStack = UIStackView.create(
        .horizontal,
        views: [leftBottomLabel, leftBottomAdditionalLabel],
        spacing: Constants.spacing,
        alignment: .center
    )
    private lazy var bottomStack = UIStackView.create(
        .horizontal,
        views: [leftBottomStack, rightBottomStack],
        spacing: Constants.spacing,
        alignment: .bottom
    )

    private let rightBottomLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(12), numberOfLines: 1, textAlignment: .right)
    private let rightBottomIcon = UIImageView()

    private let leftBottomLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(14), numberOfLines: 1, textAlignment: .left)
    private let leftBottomAdditionalLabel = UILabel()

    private let descriptionLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(12), textColor: .black600, textAlignment: .right)

    private lazy var bottomStackSpacer = UIView()

    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    private var model: TransparentInfoCardMlcModel?

    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
        mainStack.fillSuperview()
        
        container.backgroundColor = Constants.transparentBackgroundColor
        container.withBorder(width: 1, color: .white, cornerRadius: Constants.cornerRadius)

        leftBottomLabel.setContentHuggingPriority(.required, for: .horizontal)

        rightBottomIcon.withSize(Constants.imageSize)
        
        container.stack(chipStatusContainer, rowsStack, bottomStack, spacing: Constants.containerSpacing, padding: .allSides(Constants.containerSpacing))

        chipStatusContainer.addSubview(chipStatusView)
        chipStatusView.anchor(top: chipStatusContainer.topAnchor, leading: chipStatusContainer.leadingAnchor, bottom: chipStatusContainer.bottomAnchor, trailing: nil, padding: .zero)
        
        container.tapGestureRecognizer { [weak self] in
            guard let self, let action = self.model?.action else { return }
            self.eventHandler?(.statefulAction(parameters: action, stateHandler: self))
        }
        container.isUserInteractionEnabled = true
        
        rightBottomStack.tapGestureRecognizer { [weak self] in
            guard let self, let action = self.model?.bottomRightLabel?.iconRight?.action else { return }
            self.eventHandler?(.statefulAction(parameters: action, stateHandler: self))
        }
    }
    
    public func configure(with model: TransparentInfoCardMlcModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
        self.model = model
        
        chipStatusContainer.isHidden = model.chipStatusAtm == nil
        if let chipStatusAtm = model.chipStatusAtm {
            chipStatusView.configure(for: chipStatusAtm)
        }
        label.text = model.label
        rowsStack.safelyRemoveArrangedSubviews()
        rowsStack.addArrangedSubview(label)
        for row in model.rows ?? [] {
            rowsStack.addArrangedSubview(createRow(row))
        }

        bottomStack.removeArrangedSubview(bottomStackSpacer)
        bottomStackSpacer.removeFromSuperview()

        rightBottomStack.isHidden = model.bottomRightLabel == nil
        rightBottomStack.isUserInteractionEnabled = model.bottomRightLabel?.iconRight?.action != nil
        if let bottomRightLabel = model.bottomRightLabel {
            rightBottomLabel.text = bottomRightLabel.text
            rightBottomIcon.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: bottomRightLabel.iconRight?.code)

            if model.bottomLeftLabel == nil {
                bottomStack.insertArrangedSubview(bottomStackSpacer, at: 0)
            }
        }

        leftBottomStack.isHidden = model.bottomLeftLabel == nil
        let isHorizontal = model.bottomRightLabel?.text == nil
        leftBottomStack.axis = isHorizontal ? .horizontal : .vertical
        leftBottomStack.spacing = isHorizontal ? Constants.spacing : 0
        leftBottomStack.alignment = isHorizontal ? .center : .leading
        bottomStack.alignment = isHorizontal ? .center : .bottom
        if let bottomLeftLabel = model.bottomLeftLabel {
            leftBottomLabel.text = bottomLeftLabel.text

            if let bottomLeftAdditionalText = bottomLeftLabel.additionalText?.text,
               let attributed = bottomLeftAdditionalText.attributed(
                   font: FontBook.mainFont.regular.size(12),
                   color: Constants.additionalLabelTextColor,
                   lineHeight: isHorizontal ? 0 : Constants.additionalLabelLineHeight,
                   textAlignment: .left
               ){
                let mutable = NSMutableAttributedString(attributedString: attributed)

                if bottomLeftLabel.additionalText?.isStrikethrough == true {
                    mutable.addAttributes(
                        [.strikethroughStyle: NSUnderlineStyle.single.rawValue],
                        range: NSRange(location: 0, length: attributed.length)
                    )
                }

                leftBottomAdditionalLabel.attributedText = mutable
            }

            if model.bottomRightLabel == nil {
                bottomStack.addArrangedSubview(bottomStackSpacer)
            }
        }

        descriptionLabel.isHidden = model.description == nil
        descriptionLabel.text = model.description
    }
    
    private func createRow(_ row: TransparentInfoCardMlcModel.RowModel) -> UIView {
        let titleLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(12), textColor: .black600)
        titleLabel.text = row.label
        let descriptionLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(12), textColor: .black600)
        descriptionLabel.text = row.value
        descriptionLabel.isHidden = row.value == nil
        let icon = UIImageView(image: UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: row.iconLeft?.code))
        icon.withSize(Constants.rowImageSize)
        icon.isHidden = row.iconLeft == nil
        if let action = row.iconLeft?.action {
            icon.tapGestureRecognizer { [weak self] in
                self?.eventHandler?(.action(action))
            }
        }
        
        return UIStackView.create(
            .horizontal,
            views: [
                icon,
                UIStackView.create(
                    views: [
                        titleLabel,
                        descriptionLabel
                    ],
                    spacing: Constants.rowVerticalSpacing
                )
            ],
            spacing: Constants.rowHorizontalSpacing,
            alignment: .top
        )
    }
}

extension TransparentInfoCardMlcView: StatefullViewProtocol {
    public func setState(_ state: DSButtonState) {
        self.isUserInteractionEnabled = true
        rightBottomIcon.stopRotation()
        switch state {
        case .disabled:
            self.isUserInteractionEnabled = false
        case .loading:
            rightBottomIcon.image = R.image.blackGradientSpinner.image
            rightBottomIcon.startRotating()
        default:
            rightBottomIcon.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: model?.bottomRightLabel?.iconRight?.code)
        }
    }
}

private extension TransparentInfoCardMlcView {
    enum Constants {
        static let transparentBackgroundColor: UIColor = .white.withAlphaComponent(0.5)
        static let spacing: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let containerSpacing: CGFloat = 16
        static let rowHorizontalSpacing: CGFloat = 4
        static let rowVerticalSpacing: CGFloat = 2
        static let additionalLabelTextColor: UIColor = .black400
        static let additionalLabelLineHeight: CGFloat = 24
        static let rowImageSize: CGSize = .init(width: 16, height: 16)
        static let imageSize: CGSize = .init(width: 24, height: 24)
    }
}
