
import UIKit
import DiiaCommonTypes

/// design_system_code: switchModeMlc
public struct DSSwitchModeViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "switchModeMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSSwitchModeModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSSwitchModeView()
        let viewModel = DSSwitchModeViewModel(
            componentId: data.componentId,
            primaryIcon: data.primaryIconAtm,
            secondaryIcon: data.secondaryIconAtm,
            eventHandler: eventHandler)
        view.configure(with: viewModel)
        
        let paddingInsets = padding.defaultPadding()
        let boxView = BoxView(subview: view).withConstraints(insets: paddingInsets)
        return boxView
    }
}
