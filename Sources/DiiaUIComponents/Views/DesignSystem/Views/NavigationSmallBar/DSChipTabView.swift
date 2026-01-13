
import UIKit

// MARK: - DSChipItemView
public struct DSChipItem {
    public let code: String?
    public let name: String
    public let numCount: Int?
    public let iconLeft: DSIconModel?
    public var isSelected: Bool
    public var isSelectable: Bool?

    public let action: DSActionParameter?
    
    public init(code: String? = nil,
                name: String,
                numCount: Int?,
                iconLeft: DSIconModel?,
                isSelected: Bool,
                isSelectable: Bool?,
                action: DSActionParameter?) {
        self.code = code
        self.name = name
        self.numCount = numCount
        self.iconLeft = iconLeft
        self.isSelected = isSelected
        self.action = action
        self.isSelectable = isSelectable
    }
}

public final class DSChipItemView: BaseCodeView {
    private var itemLabel = UILabel()
    private var itemNumContainer = UIView()
    private var itemCounterLabel = UILabel()
    private let leftIconView: UIImageView = UIImageView().withSize(Constants.leftIconSize)

    private lazy var contentStackView = UIStackView.create(
        .horizontal,
        views: [leftIconView, itemLabel, itemNumContainer],
        spacing: Constants.stackSpacing,
        alignment: .center
    )

    private(set) var viewModel: DSChipItem?
    
    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? .white : Constants.uncheckedColor
            accessibilityTraits = isSelected ? [.selected, .button] : [.button]
        }
    }
    
    public override func setupSubviews() {
        itemLabel.withParameters(font: FontBook.usualFont)
        itemLabel.numberOfLines = 1
        itemCounterLabel.withParameters(font: FontBook.usualFont)
        itemCounterLabel.textColor = .white
        itemCounterLabel.textAlignment = .center
        itemNumContainer.backgroundColor = .black
        
        itemNumContainer.addSubview(itemCounterLabel)

        itemNumContainer.withHeight(Constants.labelHeight)
        itemNumContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.labelHeight).isActive = true
        itemNumContainer.layer.cornerRadius = Constants.labelHeight/2.0
        
        itemCounterLabel.fillSuperview(padding: .allSides(Constants.labelPadding))
        itemCounterLabel.font = FontBook.tabBarTitle

        addSubview(contentStackView)
        contentStackView.anchor(leading: leadingAnchor, trailing: trailingAnchor, padding: Constants.offset)
        contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    public func configure(viewModel: DSChipItem) {
        self.viewModel = viewModel
        
        itemLabel.text = viewModel.name

        itemNumContainer.isHidden = viewModel.numCount == nil || viewModel.numCount == 0
        
        if let numCount = viewModel.numCount, numCount != 0 {
            let itemsCount = numCount < 100 ? numCount.description : "99+"
            itemCounterLabel.text = itemsCount
            accessibilityValue = itemsCount
        }

        leftIconView.isHidden = viewModel.iconLeft == nil
        if let iconLeft = viewModel.iconLeft {
            leftIconView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: iconLeft.code)
        }

        backgroundColor = viewModel.isSelected ? .white : Constants.uncheckedColor
        
        setupAccessibility()
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = (viewModel?.isSelected ?? false) ? [.selected, .button] : [.button]
        accessibilityLabel = viewModel?.name
    }
}

private extension DSChipItemView {
    enum Constants {
        static let uncheckedColor = UIColor(white: 1, alpha: 0.3)
        static let labelHeight: CGFloat = 20
        static let stackSpacing: CGFloat = 8
        static let labelPadding: CGFloat = 4
        static let offset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        static let leftIconSize = CGSize(width: 24, height: 24)
    }
}

// MARK: - DSChipTabsView
public struct DSChipTabViewModel {
    public let items: [DSChipItem]
    public let onSelect: (DSChipItem) -> Void
    
    public init(items: [DSChipItem],
                onSelect: @escaping (DSChipItem) -> Void) {
        self.items = items
        self.onSelect = onSelect
    }
}

/// design_system_code: chipTabsOrg
public final class DSChipTabsView: BaseCodeView {
    
    private var itemsScroll = UIScrollView()
    private var itemStack = UIStackView()
    private let divider = UIView().withHeight(1)
    
    private var items = [DSChipItemView]()
    private var onSelect: ((DSChipItem) -> Void)?
    
    public override func setupSubviews() {
        addSubview(itemsScroll)
        itemsScroll.addSubview(itemStack)
        
        itemStack.axis = .horizontal
        itemStack.spacing = Constants.stackSpacing
        itemStack.distribution = .fill
        
        itemsScroll.translatesAutoresizingMaskIntoConstraints = false
        itemsScroll.fillSuperview(padding: Constants.scrollViewInsets)
        itemsScroll.contentInset = Constants.offset
        itemsScroll.contentOffset = Constants.startOffset
        itemsScroll.showsHorizontalScrollIndicator = false
        itemStack.fillSuperview()
        
        itemsScroll.withHeight(Constants.itemHeight)
        itemStack.heightAnchor.constraint(equalTo: itemsScroll.heightAnchor).isActive = true
        
        divider.backgroundColor = Constants.dividerColor
        addSubview(divider)
        divider.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    public func configure(viewModel: DSChipTabViewModel, eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        self.onSelect = viewModel.onSelect
        for item in viewModel.items {
            let view = DSChipItemView()
            view.configure(viewModel: item)
            view.layer.cornerRadius = Constants.itemHeight/2.0
            view.layer.masksToBounds = true
            items.append(view)
            itemStack.addArrangedSubview(view)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(selectItem))
            view.addGestureRecognizer(tap)
        }
        eventHandler?(.onComponentConfigured(with: .chipTabsView(viewModel: viewModel)))
    }
    
    @objc private func selectItem(_ gesture: UITapGestureRecognizer) {
        guard let selectedItem = (gesture.view as? DSChipItemView), let viewModel = selectedItem.viewModel else {
            return
        }
        if viewModel.isSelectable ?? true {
            items.forEach({$0.isSelected = false})
            selectedItem.isSelected = true
        }
        onSelect?(viewModel)
    }
}

extension DSChipTabsView: DSPaddingModeDependedViewProtocol {
    func setupPaddingMode(_ padding: DSPaddingsModel) {
        if let horizontalSize = padding.side?.horizontalSize {
            itemsScroll.contentInset = .init(top: 0, left: horizontalSize, bottom: 0, right: horizontalSize)
        }
    }
}

private extension DSChipTabsView {
    enum Constants {
        static let itemHeight: CGFloat = 38
        static let stackSpacing: CGFloat = 8
        static let offset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        static let startOffset = CGPoint(x: -24, y: .zero)
        static let scrollViewInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 16, right: 0)
        static let dividerColor = UIColor("#C5D9E9")
    }
}
