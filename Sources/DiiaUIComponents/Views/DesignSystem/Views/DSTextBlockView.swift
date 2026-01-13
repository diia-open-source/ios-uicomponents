
import UIKit
import DiiaCommonTypes

public struct DSTextBlockModel: Codable {
    public let componentId: String?
    public let squareChipStatusAtm: DSSquareChipStatusModel?
    public let title: String?
    public let text: String?
    public let items: [AnyCodable]
    public let listItems: [AnyCodable]?
    public let parameters: [TextParameter]?
    public let attentionIconMessageMlc: DSAttentionIconMessageMlc?
    
    public init(
        componentId: String? = nil,
        squareChipStatusAtm: DSSquareChipStatusModel? = nil,
        title: String? = nil,
        text: String? = nil,
        items: [AnyCodable],
        listItems: [AnyCodable]? = nil,
        parameters: [TextParameter]? = nil,
        attentionIconMessageMlc: DSAttentionIconMessageMlc? = nil) {
        self.componentId = componentId
        self.squareChipStatusAtm = squareChipStatusAtm
        self.title = title
        self.text = text
        self.items = items
        self.listItems = listItems
        self.parameters = parameters
        self.attentionIconMessageMlc = attentionIconMessageMlc
    }
}

public final class DSTextBlockViewModel {
    public let componentId: String?
    public let squareChipStatusAtm: DSSquareChipStatusModel?
    public let title: String?
    public let text: String?
    public let items: [AnyCodable]
    public let listItems: [AnyCodable]?
    public let parameters: [TextParameter]?
    public let attentionIconMessageMlc: DSAttentionIconMessageMlc?
    public let eventHandler: (ConstructorItemEvent) -> Void
    
    public init(
        componentId: String?,
        squareChipStatusAtm: DSSquareChipStatusModel?,
        title: String?,
        text: String?,
        items: [AnyCodable],
        listItems: [AnyCodable]?,
        parameters: [TextParameter]? = nil,
        attentionIconMessageMlc: DSAttentionIconMessageMlc? = nil,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) {
        self.componentId = componentId
        self.squareChipStatusAtm = squareChipStatusAtm
        self.title = title
        self.text = text
        self.items = items
        self.listItems = listItems
        self.parameters = parameters
        self.eventHandler = eventHandler
        self.attentionIconMessageMlc = attentionIconMessageMlc
    }
    
    public init(model: DSTextBlockModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.componentId = model.componentId
        self.squareChipStatusAtm = model.squareChipStatusAtm
        self.title = model.title
        self.text = model.text
        self.items = model.items
        self.listItems = model.listItems
        self.parameters = model.parameters
        self.eventHandler = eventHandler
        self.attentionIconMessageMlc = model.attentionIconMessageMlc
    }
}

/// design_system_code: textBlockOrg
public final class DSTextBlockView: BaseCodeView {
    // MARK: - Properties
    private lazy var mainStack = UIStackView.create(
        views: [
            squareChipStatusContainer,
            titleLabel,
            textView,
            bottomItemsListStackContainer,
            bottomItemsStackContainer,
            attentionIconMessageView
        ],
        spacing: Constants.mainStackSpacing
    )

    private let squareChipStatusView = DSSquareChipStatusView()
    private lazy var squareChipStatusContainer = UIStackView.create(.horizontal, views: [squareChipStatusView, UIView()])

    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let textView = UITextView()

    private let bottomItemsStackContainer = UIView()
    private let bottomItemsStack = UIStackView.create(spacing: Constants.itemsSpacing)

    private let bottomItemsListStackContainer = UIView()
    private let bottomItemsListStack = UIStackView.create(spacing: Constants.itemsSpacing)
    
    private let attentionIconMessageView = DSAttentionIconMessageView()

    // MARK: - Properties
    private var viewFabric = DSViewFabric.instance
    
    // MARK: - Lifecycle
    public override func setupSubviews() {
        super.setupSubviews()
        setupTextView()
        
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
        
        textView.isHidden = viewModel.text == nil
        if let text = viewModel.text {
            if let parameters = viewModel.parameters {
                textView.attributedText = text.attributedTextWithParameters(font: FontBook.usualFont, parameters: parameters)
            } else {
                textView.text = text
            }
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
            let withElementsBefore = viewModel.squareChipStatusAtm != nil ||
                viewModel.title != nil ||
                viewModel.text != nil ||
                !(viewModel.listItems ?? []).isEmpty
            
            let subviews = viewModel.items.compactMap {
                viewFabric.makeView(
                    from: $0,
                    withPadding: withElementsBefore ?
                        .fixed(paddings: Constants.itemsListPaddings) :
                        .fixed(paddings: .zero),
                    eventHandler: viewModel.eventHandler
                )
            }
            bottomItemsStack.addArrangedSubviews(subviews)
        }
        
        attentionIconMessageView.isHidden = viewModel.attentionIconMessageMlc == nil
        if let attentionIcon = viewModel.attentionIconMessageMlc {
            attentionIconMessageView.configure(with: attentionIcon)
        }
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
    
    // MARK: - Private methods
    private func setupTextView() {
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        textView.font = FontBook.usualFont
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = true
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        textView.delegate = self
    }
}

extension DSTextBlockView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(UIComponentsConfiguration.shared.urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
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
        static let itemsListPaddings = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}
