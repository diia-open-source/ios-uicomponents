
import UIKit
import DiiaCommonTypes

/// design_system_code: inputNumberLargeMlc
public struct DSInputNumberLargeViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "inputNumberLargeMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSInputNumberLargeModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSInputNumberLargeView()
        let items = data.items.map { $0.inputNumberLargeAtm }
        let viewModel = DSInputNumberLargeViewModel(
            id: data.componentId ?? self.modelKey,
            items: items,
            mandatory: data.mandatory,
            mandatoryCounter: Int(data.mandatoryCounter ?? .empty))
        eventHandler(.onComponentConfigured(with: .inputLargeNumber(viewModel: viewModel)))
        viewModel.onChange = {
            eventHandler(.inputChanged(ConstructorInputModel(
                inputCode: self.modelKey,
                inputData: .string(viewModel.number))))
        }
        view.configure(with: viewModel)
        
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

// MARK: - Mock
extension DSInputNumberLargeViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputNumberLargeModel(
            componentId: "componentId",
            items: [
                DSInputNumberLargeItem(inputNumberLargeAtm:
                                        DSInputNumberLargeItemData(
                                            componentId: "componentId",
                                            placeholder: "placeholder",
                                            value: "value",
                                            state: "state",
                                            mandatory: false
                                        ))
            ],
            mandatory: true,
            mandatoryCounter: "mandatoryCounter"
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

