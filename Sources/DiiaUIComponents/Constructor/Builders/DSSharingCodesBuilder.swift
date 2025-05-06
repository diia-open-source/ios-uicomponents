
import UIKit
import DiiaCommonTypes

struct DSSharingCodesBuilder: DSViewBuilderProtocol{
    
    public static let modelKey = "sharingCodesOrg"
    
    func makeView(from object: AnyCodable,
                  withPadding padding: DSViewPaddingType,
                  viewFabric: DSViewFabric?,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        
        guard let data: DSSharingCodesOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSSharingCodesOrgView()

        let stubMsgModel = data.stubMessageMlc
        
        let stubViewModel = StubMessageViewModel(model: stubMsgModel,
                                                 repeatAction: {
            if let parameters = stubMsgModel.btnStrokeAdditionalAtm?.action {
                eventHandler(.action(parameters))
            }
        })
        let plainButtonViewModels = data.btnLoadIconPlainGroupMlc?.items.map({button in
            let btnPlainIconAtm = button.btnLoadPlainIconAtm
            return IconedLoadingStateViewModel(
                name: btnPlainIconAtm.label,
                image: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: btnPlainIconAtm.icon) ?? UIImage(),
                clickHandler: {
                    if let parameters = btnPlainIconAtm.action {
                        eventHandler(.action(parameters))
                    }
                },
                componentId: btnPlainIconAtm.componentId)
        })
        let viewModel = DSSharingCodesOrgViewModel(sharingCodes: data,
                                                   stubViewModel: stubViewModel,
                                                   itemsVMs: plainButtonViewModels)
        view.configure(for: viewModel)
        let container = BoxView(subview: view).withConstraints(insets: Constants.padding)
        return container
    }
}

private extension DSSharingCodesBuilder {
    enum Constants {
        static let padding = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
}
