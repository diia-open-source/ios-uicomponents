
import UIKit
import DiiaCommonTypes

public struct ContentCardOrg: Codable {
    public let componentId: String
    public let chipStatusAtm: DSCardStatusChipModel?
    public let squareChipStatusAtm: DSSquareChipStatusModel?
    public let rightLabel: String?
    public let iconLeft: DSIconUrlAtmModel?
    public let label: String
    public let description: String?
    public let iconTexts: [DSIconTextModel]
    public let rightIconText: DSIconTextModel?
    public let points: String?
    public let bottomContent: [AnyCodable]
    public let iconTextsBottom: [DSIconTextModel]?
    public let iconBottom: DSIconModel?
    public let action: DSActionParameter?
    
    public init(
        componentId: String,
        chipStatusAtm: DSCardStatusChipModel? = nil,
        squareChipStatusAtm: DSSquareChipStatusModel? = nil,
        rightLabel: String? = nil,
        iconLeft: DSIconUrlAtmModel? = nil,
        label: String,
        description: String? = nil,
        iconTexts: [DSIconTextModel],
        rightIconText: DSIconTextModel? = nil,
        points: String? = nil,
        bottomContent: [AnyCodable],
        iconTextsBottom: [DSIconTextModel]? = nil,
        iconBottom: DSIconModel? = nil,
        action: DSActionParameter? = nil) {
            self.componentId = componentId
            self.chipStatusAtm = chipStatusAtm
            self.squareChipStatusAtm = squareChipStatusAtm
            self.rightLabel = rightLabel
            self.iconLeft = iconLeft
            self.label = label
            self.description = description
            self.iconTexts = iconTexts
            self.rightIconText = rightIconText
            self.points = points
            self.bottomContent = bottomContent
            self.iconTextsBottom = iconTextsBottom
            self.iconBottom = iconBottom
            self.action = action
        }
}

/// design_system_code: contentCardOrg
public final class ContentCardOrgView: BaseCodeView {
    private let chipStatusView = DSChipStatusAtmView()
    private let rightLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .black540, textAlignment: .right)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .black540, numberOfLines: 2)
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText, numberOfLines: 2)
    private let squareChipStatusView = DSSquareChipStatusView()
    private lazy var squareChipStatusContainer = UIStackView.create(.horizontal, views: [squareChipStatusView, UIView()])
    private let pointsLabel = UILabel().withParameters(font: FontBook.statusFont, textColor: .black540)
    private let leftIcon = DSIconUrlAtmView().withSize(Constants.middleIconSize)
    private let iconBottomView = DSIconView().withSize(Constants.smallIconSize)
    
    private let mainStackView = UIStackView.create(spacing: Constants.middleSpacing)
    private let topStackView = UIStackView.create(.horizontal, spacing: Constants.middleSpacing)
    private let textStack = UIStackView.create(.vertical, spacing: Constants.smallSpacing)
    private let centerStackView = UIStackView.create(.horizontal, spacing: Constants.bigSpacing, alignment: .top)
    private let bottomContainerStack = UIStackView.create(spacing: Constants.smallSpacing)
    private let bottomStackView = UIStackView.create(.horizontal, spacing: Constants.bigSpacing, alignment: .bottom)
    
    public override func setupSubviews() {
        backgroundColor = UIColor.white
        layer.cornerRadius = Constants.cornerRadius
        heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.minHeight).isActive = true
        addSubview(mainStackView)
        mainStackView.fillSuperview(padding: .allSides(Constants.bigSpacing))
        
        topStackView.addArrangedSubviews([chipStatusView, UIView(), rightLabel])
        textStack.addArrangedSubviews([squareChipStatusContainer, titleLabel, descriptionLabel])
        
        centerStackView.addArrangedSubviews([leftIcon, textStack])
        bottomStackView.addArrangedSubviews([bottomContainerStack, iconBottomView])
        
        mainStackView.addArrangedSubviews([topStackView, centerStackView, pointsLabel, bottomStackView])
        
        textStack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    public func configure(with model: ContentCardOrg, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        accessibilityIdentifier = model.componentId
        
        chipStatusView.isHidden = model.chipStatusAtm == nil
        rightLabel.isHidden = model.rightLabel == nil
        topStackView.isHidden = chipStatusView.isHidden && rightLabel.isHidden
        leftIcon.isHidden = model.iconLeft == nil
        descriptionLabel.isHidden = model.description == nil
        pointsLabel.isHidden = model.points == nil
        iconBottomView.isHidden = model.iconBottom == nil
        squareChipStatusContainer.isHidden = model.squareChipStatusAtm == nil
        bottomStackView.isHidden = iconBottomView.isHidden && model.bottomContent.isEmpty && (model.iconTextsBottom?.isEmpty ?? true)

        if let chipStatusAtm = model.chipStatusAtm {
            chipStatusView.configure(for: chipStatusAtm)
        }
        if let squareChipStatusAtm = model.squareChipStatusAtm {
            squareChipStatusView.configure(with: squareChipStatusAtm)
        }
        rightLabel.text = model.rightLabel
        if let iconLeft = model.iconLeft {
            leftIcon.configure(with: iconLeft)
        }
        titleLabel.text = model.label
        descriptionLabel.text = model.description
        if let points = model.points {
            pointsLabel.text = points
        }
        if let rightIconText = model.rightIconText {
            let rightIconView = DSIconTextView()
            rightIconView.configure(with: rightIconText, textColor: .black, textFillsWidth: false)
            rightIconView.setContentHuggingPriority(.required, for: .horizontal)
            rightIconView.setContentCompressionResistancePriority(.required, for: .horizontal)
            centerStackView.addArrangedSubviews([rightIconView])
        }
        model.iconTexts.forEach { iconTextModel in
            let iconTextView = DSIconTextView()
            iconTextView.configure(with: iconTextModel)
            textStack.addArrangedSubview(iconTextView)
        }
        
        model.bottomContent.forEach { component in
            let fabric = DSViewFabric()
            if let componentView = fabric.makeView(
                from: component,
                withPadding: .fixed(paddings: .zero),
                eventHandler: eventHandler) {
                bottomContainerStack.addArrangedSubview(componentView)
            }
        }
        if let iconTextsBottom = model.iconTextsBottom, !iconTextsBottom.isEmpty {
            let items: [(view: UIView, width: CGFloat)] = iconTextsBottom.map { iconTextModel in
                let iconTextView = DSIconTextView()
                iconTextView.configure(with: iconTextModel)
                return (iconTextView, DSIconTextView.width(for: iconTextModel))
            }
            let iconTextsBottomWrapView = DSRowItemsWrapView()
            iconTextsBottomWrapView.configure(items: items, lineSpacing: Constants.bigSpacing, interitemSpacing: Constants.bigSpacing)
            bottomContainerStack.addArrangedSubview(iconTextsBottomWrapView)
        }
        if let iconBottom = model.iconBottom {
            iconBottomView.setIcon(iconBottom)
        }
        
        if let action = model.action {
            tapGestureRecognizer {
                eventHandler(.action(action))
            }
        }
    }
}

private extension ContentCardOrgView {
    enum Constants {
        static let smallIconSize: CGSize = .init(width: 24, height: 24)
        static let middleIconSize: CGSize = .init(width: 40, height: 40)
        
        static let cornerRadius: CGFloat = 16
        static let minHeight: CGFloat = 56
        static let smallSpacing: CGFloat = 4
        static let spacing: CGFloat = 8
        static let middleSpacing: CGFloat = 12
        static let bigSpacing: CGFloat = 16
    }
}
