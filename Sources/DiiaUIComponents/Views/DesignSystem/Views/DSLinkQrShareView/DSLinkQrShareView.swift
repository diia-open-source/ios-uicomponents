
import UIKit
import DiiaCommonTypes

/// design_system_code: linkQrShareOrg
public final class DSLinkQrShareView: BaseCodeView {
    
    // MARK: - Subviews
    private let chipBlackTabsView = DSCenterChipBlackTabsOrgView()
    private let linkSharingView = DSLinkSharingOrgView()
    private let qrCodeOrgView = DSQrCodeOrgView()
    
    // MARK: - Properties
    private var viewModel: DSLinkQrShareViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        
        let sharingContainerView = UIView()
        sharingContainerView.addSubviews([
            linkSharingView,
            qrCodeOrgView,
        ])
        linkSharingView.fillSuperview()
        qrCodeOrgView.fillSuperview()

        UIStackView.create(
            views: [chipBlackTabsView, sharingContainerView],
            spacing: Constants.stackSpacing,
            in: self,
            padding: Constants.contentPaddings
        )
    }

    private func updateVisibility(chipBlackTabsViewModel: DSCenterChipBlackTabsOrgViewModel) {
        let isFirstItemSelected = chipBlackTabsViewModel.itemsViewModels.first?.state.value == .selected
        self.linkSharingView.isHidden = !isFirstItemSelected
        self.qrCodeOrgView.isHidden = isFirstItemSelected
    }

    // MARK: - Public Methods
    public func configure(with viewModel: DSLinkQrShareViewModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.viewModel = viewModel

        self.chipBlackTabsView.isHidden = viewModel.centerChipBlackTabsViewModel == nil
        if let chipBlackTabsViewModel = viewModel.centerChipBlackTabsViewModel {
            chipBlackTabsView.configure(with: chipBlackTabsViewModel, eventHandler: eventHandler)
            updateVisibility(chipBlackTabsViewModel: chipBlackTabsViewModel)

            chipBlackTabsViewModel.onSelectedChanged = { [weak self] _ in
                self?.updateVisibility(chipBlackTabsViewModel: chipBlackTabsViewModel)
            }
        } else {
            qrCodeOrgView.isHidden = viewModel.model.qrCodeOrg == nil
            linkSharingView.isHidden = viewModel.model.linkSharingOrg == nil
        }

        qrCodeOrgView.configure(viewModel: viewModel.qrViewModel, eventHandler: eventHandler)
        linkSharingView.configure(with: viewModel.linkViewModel, eventHandler: eventHandler)
    }
}

// MARK: - Constants
private extension DSLinkQrShareView {
    enum Constants {
        static let cornerRadius: CGFloat = 24
        static let contentPaddings = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        static let stackSpacing: CGFloat = 16
    }
}
