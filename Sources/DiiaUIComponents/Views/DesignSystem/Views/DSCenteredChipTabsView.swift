
import UIKit

/// design_system_code: centerChipTabsOrg
public final class DSCenteredChipTabsView: BaseCodeView {
    private let mainStack = UIStackView.create(.horizontal, spacing: Constants.chipSpacing, distribution: .fillEqually)
    private let divider = UIView().withHeight(1)
    
    private var items: [DSChipItemView] = []
    private var onSelect: ((DSChipItem) -> Void)?
    
    private var mainStackConstraints: AnchoredConstraints?
    
    // MARK: - Lifecycle
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStackConstraints = mainStack.fillSuperview(padding: Constants.offset)
        divider.backgroundColor = Constants.dividerColor
        addSubview(divider)
        divider.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }

    // MARK: - Public
    public func configure(viewModel: DSChipTabViewModel, eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        self.onSelect = viewModel.onSelect
        for item in viewModel.items {
            let view = DSChipItemView()
            view.configure(viewModel: item)
            view.withHeight(Constants.itemHeight)
            view.layer.cornerRadius = Constants.itemHeight/2.0
            view.layer.masksToBounds = true
            items.append(view)
            mainStack.addArrangedSubview(view)
            
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

extension DSCenteredChipTabsView: DSPaddingModeDependedViewProtocol {
    func setupPaddingMode(_ padding: DSPaddingsModel) {
        if let horizontalSize = padding.side?.horizontalSize {
            mainStackConstraints?.leading?.constant = horizontalSize
            mainStackConstraints?.trailing?.constant = horizontalSize
            layoutIfNeeded()
        }
    }
}

private extension DSCenteredChipTabsView {
    enum Constants {
        static let itemHeight: CGFloat = 38
        static let offset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        static let chipSpacing: CGFloat = 8.0
        static let dividerColor = UIColor("#C5D9E9")
    }
}
