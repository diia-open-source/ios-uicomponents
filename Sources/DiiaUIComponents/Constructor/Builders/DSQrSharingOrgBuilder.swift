
import UIKit
import DiiaCommonTypes

public struct DSQRSharingOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "qrSharingOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSQRSharingOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSQRSharingView()
        
        let stubViewModel = StubMessageViewModel(icon: data.stubMessageMlc?.icon ?? "",
                                                 title: data.stubMessageMlc?.title,
                                                 descriptionText: data.stubMessageMlc?.description,
                                                 componentId: data.stubMessageMlc?.componentId,
                                                 repeatAction: {
            if let action = data.stubMessageMlc?.btnStrokeAdditionalAtm?.action {
                eventHandler(.action(action))
            }
        })
        
        let plainButtonViewModels = data.btnIconPlainGroupMlc?.items.map({button in
            let btnPlainIconAtm = button.btnPlainIconAtm
            return IconedLoadingStateViewModel(
                name: btnPlainIconAtm.label,
                image: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: btnPlainIconAtm.icon) ?? UIImage(),
                clickHandler: {
                    if let action = btnPlainIconAtm.action {
                        eventHandler(.action(action))
                    }
                },
                componentId: btnPlainIconAtm.componentId)
        })
        let viewModel = DSQRSharingViewModel(qrSharingOrg: data,
                                             stubViewModel: data.stubMessageMlc == nil ? nil : stubViewModel,
                                             plainButtonViewModels: plainButtonViewModels)
        view.configure(viewModel: viewModel)
        let container = UIView()
        container.addSubview(view)
        view.fillSuperview(padding: .allSides(Constants.offset))
        return container
    }
}

private extension DSQRSharingOrgBuilder {
    enum Constants {
        static let offset: CGFloat = 20
    }
}
