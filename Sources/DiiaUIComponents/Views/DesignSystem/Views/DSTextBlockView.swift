
import UIKit
import DiiaCommonTypes

public struct DSTextBlockModel: Codable {
    public let componentId: String?
    public let squareChipStatusAtm: DSSquareChipStatusModel?
    public let title: String?
    public let text: String?
    public let items: [AnyCodable]
    public let listItems: [AnyCodable]?
}

public class DSTextBlockViewModel {
    public let componentId: String?
    public let squareChipStatusAtm: DSSquareChipStatusModel?
    public let title: String?
    public let text: String?
    public let items: [AnyCodable]
    public let listItems: [AnyCodable]?
    public let eventHandler: (ConstructorItemEvent) -> Void
    
    public init(
        componentId: String?,
        squareChipStatusAtm: DSSquareChipStatusModel?,
        title: String?,
        text: String?,
        items: [AnyCodable],
        listItems: [AnyCodable]?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) {
        self.componentId = componentId
        self.squareChipStatusAtm = squareChipStatusAtm
        self.title = title
        self.text = text
        self.items = items
        self.listItems = listItems
        self.eventHandler = eventHandler
    }
}

/// design_system_code: textBlockOrg
public class DSTextBlockView: BaseCodeView {
    // MARK: - Properties
    private lazy var mainStack = UIStackView.create(
        views: [
            squareChipStatusContainer,
            titleLabel,
            textLabel,
            bottomItemsListStackContainer,
            bottomItemsStackContainer
        ],
        spacing: Constants.mainStackSpacing
    )

    private let squareChipStatusView = DSSquareChipStatusView()
    private lazy var squareChipStatusContainer = UIStackView.create(.horizontal, views: [squareChipStatusView, UIView()])

    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let textLabel = UILabel().withParameters(font: FontBook.usualFont)

    private let bottomItemsStackContainer = UIView()
    private let bottomItemsStack = UIStackView.create(spacing: Constants.itemsSpacing)

    private let bottomItemsListStackContainer = UIView()
    private let bottomItemsListStack = UIStackView.create(spacing: Constants.itemsSpacing)

    // MARK: - Properties
    private var viewFabric = DSViewFabric.instance
    
    // MARK: - Lifecycle
    public override func setupSubviews() {
        super.setupSubviews()
        
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.contentPaddings)

        bottomItemsStackContainer.addSubview(bottomItemsStack)
        bottomItemsStack.fillSuperview()

        bottomItemsListStackContainer.addSubview(bottomItemsListStack)
        bottomItemsListStack.fillSuperview()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSTextBlockViewModel) {
        accessibilityIdentifier = viewModel.componentId
        
        squareChipStatusContainer.isHidden = viewModel.squareChipStatusAtm == nil
        if let squareChipStatusModel = viewModel.squareChipStatusAtm {
            squareChipStatusView.configure(with: squareChipStatusModel)
        }
        
        titleLabel.isHidden = viewModel.title == nil
        if let title = viewModel.title {
            let attributedText = title.attributed(font: FontBook.smallHeadingFont, lineHeight: Constants.lineHeight)
            titleLabel.attributedText = attributedText
        }
        
        textLabel.isHidden = viewModel.text == nil
        if let text = viewModel.text {
            textLabel.text = text
        }

        bottomItemsListStack.safelyRemoveArrangedSubviews()
        bottomItemsListStackContainer.isHidden = viewModel.listItems?.isEmpty ?? true

        if let listItems = viewModel.listItems, !listItems.isEmpty {
            let subviews = listItems.compactMap {
                viewFabric.makeView(
                    from: $0,
                    withPadding: .fixed(paddings: .zero),
                    eventHandler: viewModel.eventHandler
                )
            }
            bottomItemsListStack.addArrangedSubviews(subviews)
        }

        bottomItemsStack.safelyRemoveArrangedSubviews()
        bottomItemsStackContainer.isHidden = viewModel.items.isEmpty

        if !viewModel.items.isEmpty {
            let subviews = viewModel.items.compactMap {
                viewFabric.makeView(
                    from: $0,
                    withPadding: .fixed(paddings: .zero),
                    eventHandler: viewModel.eventHandler
                )
            }
            bottomItemsStack.addArrangedSubviews(subviews)
            mainStack.setCustomSpacing(Constants.itemsListSpacing, after: bottomItemsListStackContainer)
        }
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
}

// MARK: - Constants
private extension DSTextBlockView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let itemsSpacing: CGFloat = 8
        static let itemsListSpacing: CGFloat = 24
        static let mainStackSpacing: CGFloat = 16
        static let lineHeight: CGFloat = 24
        static let contentPaddings = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
