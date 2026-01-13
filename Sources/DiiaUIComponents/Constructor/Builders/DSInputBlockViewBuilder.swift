

import UIKit
import DiiaCommonTypes

/// design_system_code: inputBlockOrg
public struct DSInputBlockViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "inputBlockOrg"

    public func makeView(
        from object: AnyCodable,
        withPadding paddingType: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let model: DSInputBlockModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSInputBlockView()
        if let viewFabric {
            view.setFabric(viewFabric)
        }
        let viewModel = DSInputBlockViewModel(
            componentId: model.componentId,
            tableMainHeadingViewModel: model.tableMainHeadingMlc.map { model in
                return DSTableMainHeadingViewModel(headingModel: model) {
                    if let iconAction = model.icon?.action {
                        eventHandler(.action(iconAction))
                    }
                }
            },
            tableSecondaryHeadingViewModel: model.tableSecondaryHeadingMlc.map { model in
                return TableSecondaryHeadingViewModel(headingModel: model) {
                    if let iconAction = model.icon?.action {
                        eventHandler(.action(iconAction))
                    }
                }
            },
            attentionIconMessageModel: model.attentionIconMessageMlc,
            items: model.items,
            urlOpener: UIComponentsConfiguration.shared.urlOpener,
            eventHandler: eventHandler
        )
        
        view.configure(with: viewModel)
        
        let insets = paddingType.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}
