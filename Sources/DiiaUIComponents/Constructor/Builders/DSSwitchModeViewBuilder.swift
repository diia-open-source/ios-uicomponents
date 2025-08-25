
import UIKit
import DiiaCommonTypes

/// design_system_code: switchModeMlc
public struct DSSwitchModeViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "switchModeMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSSwitchModeModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSSwitchModeView()
        let viewModel = DSSwitchModeViewModel(
            componentId: data.componentId,
            primaryIcon: data.primaryIconAtm,
            secondaryIcon: data.secondaryIconAtm,
            eventHandler: eventHandler)
        view.configure(with: viewModel)
        
        let paddingInsets = padding.defaultPadding(object: object, modelKey: modelKey)
        let boxView = BoxView(subview: view).withConstraints(insets: paddingInsets)
        return boxView
    }
}

extension DSSwitchModeViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSSwitchModeModel(
            componentId: "componentId",
            primaryIconAtm: .mock,
            secondaryIconAtm: .mock,
            selectedId: "selectedId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
