
import UIKit
import DiiaCommonTypes

/// design_system_code: centerChipBlackTabsOrg
public final class DSCenterChipBlackTabsOrgView: BaseCodeView {
    // MARK: - Properties
    private let mainStack = UIStackView.create(.horizontal, spacing: Constants.chipSpacing, distribution: .fillEqually)
    private var viewModel: DSCenterChipBlackTabsOrgViewModel?

    // MARK: - Lifecycle
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
    }

    // MARK: - Public
    public func configure(with viewModel: DSCenterChipBlackTabsOrgViewModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.viewModel = viewModel

        mainStack.safelyRemoveArrangedSubviews()

        for itemViewModel in viewModel.itemsViewModels {
            let view = DSChipBlackMlcView()

            itemViewModel.onClick = { [weak viewModel] action in
                viewModel?.setSelected(chipViewModel: itemViewModel)

                guard let action = itemViewModel.action else { return }
                eventHandler(.action(action))
            }

            view.configure(with: itemViewModel)
            mainStack.addArrangedSubview(view)
        }

        eventHandler(.onComponentConfigured(with: .centerChipTabsView(viewModel: viewModel)))
    }
}

// MARK: - DSCenterChipBlackTabsOrgView+Constants
extension DSCenterChipBlackTabsOrgView {
    private enum Constants {
        static let chipSpacing: CGFloat = 8.0
    }
}
