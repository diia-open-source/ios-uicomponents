
import UIKit
import DiiaCommonTypes

public struct StateMessageMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "stateMessageMlc"

    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
            guard let model: StateMessageMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }
            
            let view = StateMessageView()
            let viewModel = StateMessageViewModel(
                iconName: model.iconAtm?.code,
                title: model.title,
                btnTitle: model.btnStrokeAdditionalAtm?.label,
                btnAccessibilityHint: model.btnStrokeAdditionalAtm?.label,
                descriptionText: model.description,
                componentId: model.componentId,
                parameters: nil,
                repeatAction: {
                    guard let action = model.btnStrokeAdditionalAtm?.action else { return }
                    eventHandler(.action(action))
                })

            view.configure(with: viewModel, urlOpener: UIComponentsConfiguration.shared.urlOpener)

            let insets = padding.defaultPadding(object: object, modelKey: modelKey)
            let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
            return paddingBox
    }
}

extension StateMessageMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = StateMessageMlcModel(
            componentId: "componentId",
            iconAtm: .mock,
            title: "title",
            description: "description description",
            btnStrokeAdditionalAtm: .mock)

        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
