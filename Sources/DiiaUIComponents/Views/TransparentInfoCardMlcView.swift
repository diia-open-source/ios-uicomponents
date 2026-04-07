
import UIKit
import DiiaCommonTypes

struct TransparentInfoCardMlcModel: Codable {
    let componentId: String
    let label: String
    let chipStatusAtm: DSCardStatusChipModel?
    let rows: [RowModel]?
    let bottomLeftLabel: BottomLeftModel?
    let bottomRightLabel: BottomRightModel?
    let action: DSActionParameter?
    let description: String?
    
    struct RowModel: Codable {
        let iconLeft: DSIconModel?
        let label: String
        let value: String?
    }

    struct BottomLeftModel: Codable {
        let text: String?
        let additionalText: AdditionalText?

        struct AdditionalText: Codable {
            let text: String?
            let isStrikethrough: Bool?
        }
    }

    struct BottomRightModel: Codable {
        let text: String?
        let iconRight: DSIconModel?
    }
}

final class TransparentInfoCardMlcView: BaseCodeView {
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

    override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
        
        container.backgroundColor = Constants.transparentBackgroundColor
        container.withBorder(width: 1, color: .white, cornerRadius: Constants.cornerRadius)

        rightBottomIcon.withSize(Constants.imageSize)
        
        container.stack(chipStatusContainer, rowsStack, bottomStack, spacing: Constants.containerSpacing, padding: .allSides(Constants.containerSpacing))

        chipStatusContainer.addSubview(chipStatusView)
        chipStatusView.anchor(top: chipStatusContainer.topAnchor, leading: chipStatusContainer.leadingAnchor, bottom: chipStatusContainer.bottomAnchor, trailing: nil, padding: .zero)
        
        container.tapGestureRecognizer { [weak self] in
            guard let action = self?.model?.action else { return }
            self?.eventHandler?(.action(action))
        }
        container.isUserInteractionEnabled = true
        
        rightBottomStack.tapGestureRecognizer { [weak self] in
            guard let action = self?.model?.bottomRightLabel?.iconRight?.action else { return }
            self?.eventHandler?(.action(action))
        }
    }
    
    func configure(with model: TransparentInfoCardMlcModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
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
