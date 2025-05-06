
import UIKit

// MARK: - DSMapChipTabsView
public struct DSMapChipTabViewModel {
    public let items: [DSMapChipItem]
    public let onSelect: (DSMapChipItem) -> Void
    
    public init(items: [DSMapChipItem], onSelect: @escaping (DSMapChipItem) -> Void) {
        self.items = items
        self.onSelect = onSelect
    }
}

/// design_system_code: mapChipTabsOrg
public class DSMapChipTabsView: BaseCodeView {
    private var itemsScroll = UIScrollView()
    private var itemStack = UIStackView()
    
    private var items = [DSMapChipItemView]()
    private var onSelect: ((DSMapChipItem) -> Void)?
    
    public override func setupSubviews() {
        addSubview(itemsScroll)
        itemsScroll.addSubview(itemStack)
        
        itemStack.axis = .horizontal
        itemStack.spacing = Constants.stackSpacing
        itemStack.distribution = .fill
        
        itemsScroll.translatesAutoresizingMaskIntoConstraints = false
        itemsScroll.fillSuperview(padding: Constants.scrollViewInsets)
        itemsScroll.showsHorizontalScrollIndicator = false
        itemStack.fillSuperview(padding: Constants.offset)
        
        itemsScroll.withHeight(Constants.itemHeight)
        itemStack.heightAnchor.constraint(equalTo: itemsScroll.heightAnchor).isActive = true
    }
    
    public func configure(viewModel: DSMapChipTabViewModel) {
        self.onSelect = viewModel.onSelect
        for item in viewModel.items {
            let view = DSMapChipItemView()
            view.configure(viewModel: item)
            view.layer.cornerRadius = Constants.itemHeight * 0.5
            view.layer.masksToBounds = true
            items.append(view)
            itemStack.addArrangedSubview(view)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(selectItem))
            view.addGestureRecognizer(tap)
        }
    }
    
    @objc private func selectItem(_ gesture: UITapGestureRecognizer) {
        items.forEach({$0.isSelected = false})
        guard let selectedItem = (gesture.view as? DSMapChipItemView), let viewModel = selectedItem.viewModel else {
            return
        }
        selectedItem.isSelected = true
        onSelect?(viewModel)
    }
}

private extension DSMapChipTabsView {
    enum Constants {
        static let itemHeight: CGFloat = 40
        static let stackSpacing: CGFloat = 8
        static let offset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        static let scrollViewInsets: UIEdgeInsets = .init(top: 16, left: 0, bottom: 16, right: 0)
    }
}

public class DSMapChipItemView: BaseCodeView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.withParameters(font: FontBook.usualFont)
        label.textColor = .black
        return label
    }()
    
    private var imageView: UIImageView = {
        let _imageView = UIImageView()
        _imageView.contentMode = .scaleAspectFit
        return _imageView
    }()
    
    private(set) var viewModel: DSMapChipItem?
    
    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? .black : .white
            titleLabel.textColor = isSelected ? .white : .black
        }
    }
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        
        hstack(
            imageView,
            titleLabel,
            spacing: Constants.stackSpacing,
            alignment: .center,
            distribution: .equalSpacing,
            padding: Constants.offset
        )
    }
    
    public func configure(viewModel: DSMapChipItem) {
        self.viewModel = viewModel
        self.isSelected = viewModel.isSelected

        accessibilityIdentifier = viewModel.componentId
        accessibilityLabel = viewModel.accessibilityDescription
        titleLabel.text = viewModel.label
        imageView.isHidden = viewModel.icon == nil
        let image = UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: viewModel.icon)
        imageView.image = image
    }
}

private extension DSMapChipItemView {
    enum Constants {
        static let uncheckedColor = UIColor(white: 1, alpha: 0.3)
        static let stackSpacing: CGFloat = 8
        static let offset: UIEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 16)
    }
}
