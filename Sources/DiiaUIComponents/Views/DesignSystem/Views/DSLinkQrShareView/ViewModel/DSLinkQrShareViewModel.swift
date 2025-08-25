
import UIKit
import DiiaCommonTypes

public class DSLinkQrShareViewModel {
    public var model: Observable<DSLinkQrShareModel>
    public var loadingState: Observable<LoadingState>
    public let eventHandler: (ConstructorItemEvent) -> Void
    
    public var centerChipBlackTabsViewModel: DSCenterChipBlackTabsOrgViewModel? {
        prepareChipTabsViewModel()
    }
    
    public var linkSharingViewModel: DSLinkSharingOrgViewModel? {
        prepareLinkSharingViewModel()
    }
    
    public var qrCodeViewModel: DSQrCodeOrgViewModel? {
        prepareQrCodeViewModel()
    }
    
    public var paginationMessage: DSPaginationMessageMlcModel? {
        model.value.paginationMessageMlc
    }
    
    // MARK: - Init
    public init(model: DSLinkQrShareModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.model = .init(value: model)
        self.loadingState = .init(value: .ready)
        self.eventHandler = eventHandler
    }
    
    // MARK: - Private Methods
    private func prepareChipTabsViewModel() -> DSCenterChipBlackTabsOrgViewModel? {
        guard let model = model.value.centerChipBlackTabsOrg else { return nil }
        
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

        return DSCenterChipBlackTabsOrgViewModel(
            componentId: model.componentId,
            preselectedCode: model.preselectedCode,
            itemsViewModels: itemsViewModels
        )
    }
    
    private func prepareLinkSharingViewModel() -> DSLinkSharingOrgViewModel? {
        guard let model = model.value.linkSharingOrg else { return nil }
        
        let iconButtonViewModels = model.btnIconPlainGroupMlc.items.map {
            let btnPlainIconAtm = $0.btnPlainIconAtm
            let image = UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: btnPlainIconAtm.icon) ?? UIImage()
            return IconedLoadingStateViewModel(
                name: btnPlainIconAtm.label,
                image: image,
                clickHandler: { [weak self] in
                    if let self, let action = btnPlainIconAtm.action {
                        self.eventHandler(.action(action))
                    }
                },
                componentId: btnPlainIconAtm.componentId
            )
        }
        return DSLinkSharingOrgViewModel(
            componentId: model.componentId,
            text: model.text,
            linkSharingMlc: model.linkSharingMlc,
            description: model.description,
            iconButtonViewModels: iconButtonViewModels
        )
    }
    
    private func prepareQrCodeViewModel() -> DSQrCodeOrgViewModel? {
        guard let model = model.value.qrCodeOrg else { return nil }
        return DSQrCodeOrgViewModel(model: model)
    }
}
