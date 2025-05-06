
import UIKit
import DiiaCommonTypes

/// design_system_code: inputNumberLargeMlc
public struct DSInputNumberLargeViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "inputNumberLargeMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSInputNumberLargeModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSInputNumberLargeView()
        let items = data.items.map { $0.inputNumberLargeAtm }
        let viewModel = DSInputNumberLargeViewModel(
            id: data.componentId ?? Self.modelKey,
            items: items,
            mandatory: data.mandatory)
        viewModel.onChange = {
            eventHandler(.inputChanged(ConstructorInputModel(
                inputCode: Self.modelKey,
                inputData: .string(viewModel.number))))
        }
        view.configure(with: viewModel)
        
        let insets = padding.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}
