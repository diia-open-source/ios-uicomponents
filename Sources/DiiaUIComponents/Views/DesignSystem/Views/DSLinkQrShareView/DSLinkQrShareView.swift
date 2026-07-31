
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
    
// MARK: - Templates for presenter

public extension DSLinkQrShareView {
    static let linkAction = "link"
    static let qrAction = "qr"
    
    static let confirmLinkRefreshAction = AlertTemplateAction("confirm_link_refresh")
    static let confirmQrRefreshAction = AlertTemplateAction("confirm_qr_refresh")
    
    static let paginationMessageMlc = "paginationMessageMlc"
    static let templateIcon = "attentionBlackRound"
    
    static let linkRefreshTemplate = AlertTemplate(
        type: .middleCenterIconBlackButtonAlert,
        isClosable: false,
        data: AlertTemplateData(
            icon: templateIcon,
            title: R.Strings.general_refresh_link_title.localized(),
            description: R.Strings.general_refresh_link_subtitle.localized(),
            mainButton: AlertButtonModel(
                title: R.Strings.general_retry.localized(),
                icon: nil,
                action: confirmLinkRefreshAction),
            alternativeButton: AlertButtonModel(
                title: R.Strings.general_cancel.localized(),
                icon: nil,
                action: .skip)
        )
    )

    static let linkErrorMessage = DSPaginationMessageMlcModel(
        componentId: paginationMessageMlc,
        title: R.Strings.general_refresh_link_error_title.localized(),
        description: nil,
        btnStrokeAdditionalAtm: DSButtonModel(
            label: R.Strings.general_retry.localized(),
            action: .init(type: linkAction)
        )
    )

    static let qrRefreshTemplate = AlertTemplate(
        type: .middleCenterIconBlackButtonAlert,
        isClosable: false,
        data: AlertTemplateData(
            icon: templateIcon,
            title: R.Strings.general_refresh_qr_title.localized(),
            description: R.Strings.general_refresh_qr_subtitle.localized(),
            mainButton: AlertButtonModel(
                title: R.Strings.general_update.localized(),
                icon: nil,
                action: confirmQrRefreshAction),
            alternativeButton: AlertButtonModel(
                title: R.Strings.general_cancel.localized(),
                icon: nil,
                action: .skip)
        )
    )

    static let qrErrorMessage = DSPaginationMessageMlcModel(
        componentId: paginationMessageMlc,
        title: R.Strings.general_refresh_qr_error_title.localized(),
        description: nil,
        btnStrokeAdditionalAtm: DSButtonModel(
            label: R.Strings.general_retry.localized(),
            action: .init(type: qrAction)
        )
    )
}

// MARK: - Constants
private extension DSLinkQrShareView {
    enum Constants {
        static let cornerRadius: CGFloat = 24
        static let contentPaddings = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        static let stackSpacing: CGFloat = 16
    }
}
