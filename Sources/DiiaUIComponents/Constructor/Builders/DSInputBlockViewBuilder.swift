

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
            tableMainHeadingViewModel: model.tableMainHeadingMlc.map {
                DSTableMainHeadingViewModel(
                    componentId: $0.componentId,
                    label: $0.label,
                    description: $0.description
                )
            },
            tableSecondaryHeadingViewModel: model.tableSecondaryHeadingMlc.map {
                DSTableMainHeadingViewModel(
                    componentId: $0.componentId,
                    label: $0.label,
                    description: $0.description
                )
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
