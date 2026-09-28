
import UIKit
import DiiaCommonTypes

/// design_system_code: inputNumberMlc
public struct DSInputNumberViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "inputNumberMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding paddingType: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSInputNumberMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let validators = data.validation?.compactMap {
            TextValidationErrorGenerator(validationModel: $0)
        } ?? []
        let inputView = DSInputNumberMlcView()
        inputView.setEventHandler(eventHandler)
        inputView.configure(with: DSInputNumberMlcViewModel(
            componentId: data.componentId,
            inputCode: data.inputCode,
            label: data.label,
            placeholder: data.placeholder,
            hint: data.hint,
            mask: data.mask,
            value: data.value ,
            maxValue: data.maxValue,
            minValue: data.minValue,
            maxCount: data.maxCount,
            minCount: data.minCount,
            mandatory: data.mandatory,
            errorMessage: data.errorMessage,
            iconRight: data.iconRight,
            validators: validators))
        let paddingBox = BoxView(subview: inputView).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

// MARK: - Mock
extension DSInputNumberViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputNumberMlcModel(
            componentId: "componentId",
            inputCode: "inputNumberMlc",
            label: "inputNumberMlc",
            placeholder: "inputNumberMlcPlaceholder",
            hint: "inputNumberMlcHint",
            value: "1115556",
            maxValue: 200,
            minValue: 300000000,
            maxCount: nil,
            minCount: nil,
            mandatory: true,
            errorMessage: "From 200 to 300000000",
            mask: nil,
            iconRight: nil,
            validation: nil
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
