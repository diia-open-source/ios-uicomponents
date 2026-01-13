
import UIKit
import DiiaCommonTypes

public final class DSLinkQrShareViewModel {
    public let centerChipBlackTabsViewModel: DSCenterChipBlackTabsOrgViewModel?
    public let linkViewModel: DSLinkSharingOrgViewModel
    public let qrViewModel: DSQrCodeOrgViewModel
    public let model: DSLinkQrShareModel

    // MARK: - Init
    public init(model: DSLinkQrShareModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.model = model
        self.centerChipBlackTabsViewModel = Self.prepareChipTabsViewModel(model: model)
        self.linkViewModel = DSLinkSharingOrgViewModel(model: model.linkSharingOrg)
        self.qrViewModel = DSQrCodeOrgViewModel(model: model.qrCodeOrg)
    }
    
    // MARK: - Private Methods
    private static func prepareChipTabsViewModel(model: DSLinkQrShareModel) -> DSCenterChipBlackTabsOrgViewModel? {
        guard let model = model.centerChipBlackTabsOrg else { return nil }
        
        let itemsViewModels: [DSChipBlackMlcViewModel] = model.items.compactMap {
            let chipViewModel = DSChipBlackMlcViewModel(
                componentId: $0.chipBlackMlc.componentId,
                label:  $0.chipBlackMlc.label,
                code: $0.chipBlackMlc.code,
                action: $0.chipBlackMlc.action
            )
            if $0.chipBlackMlc.code == model.preselectedCode {
                chipViewModel.state.value = .selected
            }
            return chipViewModel
        }

        let viewModel = DSCenterChipBlackTabsOrgViewModel(
            componentId: model.componentId,
            preselectedCode: model.preselectedCode,
            itemsViewModels: itemsViewModels
        )
        return viewModel
    }
}
