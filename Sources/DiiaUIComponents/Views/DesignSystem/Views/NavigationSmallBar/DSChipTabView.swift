import UIKit

// MARK: - DSChipItemView
public struct DSChipItem {
    public let code: String?
    public let name: String
    public let numCount: Int?
    public var isSelected: Bool
    public let action: DSActionParameter?
    
    public init(code: String? = nil,
                name: String,
                numCount: Int?,
                isSelected: Bool,
                action: DSActionParameter?) {
        self.code = code
        self.name = name
        self.numCount = numCount
        self.isSelected = isSelected
        self.action = action
    }
}

public class DSChipItemView: BaseCodeView {
    private var itemLabel = UILabel()
    private var itemNumContainer = UIView()
    private var itemCounterLabel = UILabel()
    
    private(set) var viewModel: DSChipItem?
    
    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? .white : Constants.uncheckedColor
        }
    }
    public override func setupSubviews() {
        itemLabel.withParameters(font: FontBook.usualFont)
        itemCounterLabel.withParameters(font: FontBook.usualFont)
        itemCounterLabel.textColor = .white
        itemCounterLabel.textAlignment = .center
        itemNumContainer.backgroundColor = .black
        
        itemNumContainer.addSubview(itemCounterLabel)
        
        hstack(itemLabel, itemNumContainer, spacing: Constants.stackSpacing, padding: Constants.offset)
        
        itemNumContainer.withHeight(Constants.labelHeight)
        itemNumContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.labelHeight).isActive = true
        itemNumContainer.layer.cornerRadius = Constants.labelHeight/2.0
        
        itemCounterLabel.fillSuperview(padding: .allSides(Constants.labelPadding))
        itemCounterLabel.font = FontBook.tabBarTitle
    }
    
    public func configure(viewModel: DSChipItem) {
        self.viewModel = viewModel
        
        itemLabel.text = viewModel.name
        
        itemNumContainer.isHidden = viewModel.numCount == nil || viewModel.numCount == 0
        
        if let numCount = viewModel.numCount, numCount != 0 {
            itemCounterLabel.text = numCount < 100 ? numCount.description : "99+"
        }
        
        backgroundColor = viewModel.isSelected ? .white : Constants.uncheckedColor
    }
}

private extension DSChipItemView {
    enum Constants {
        static let uncheckedColor = UIColor(white: 1, alpha: 0.3)
        static let labelHeight: CGFloat = 20
        static let stackSpacing: CGFloat = 8
        static let labelPadding: CGFloat = 4
        static let offset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
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
public class DSChipTabsView: BaseCodeView {
    
    private var itemsScroll = UIScrollView()
    private var itemStack = UIStackView()
    
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
    }
    
    public func configure(viewModel: DSChipTabViewModel) {
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
    }
    
    @objc private func selectItem(_ gesture: UITapGestureRecognizer) {
        items.forEach({$0.isSelected = false})
        guard let selectedItem = (gesture.view as? DSChipItemView), let viewModel = selectedItem.viewModel else {
            return
        }
        selectedItem.isSelected = true
        onSelect?(viewModel)
    }
}

private extension DSChipTabsView {
    enum Constants {
        static let itemHeight: CGFloat = 40
        static let stackSpacing: CGFloat = 8
        static let offset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        static let startOffset = CGPoint(x: -24, y: .zero)
        static let scrollViewInsets: UIEdgeInsets = .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}
