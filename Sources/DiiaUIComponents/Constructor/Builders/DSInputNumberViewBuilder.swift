
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
            mandatory: data.mandatory,
            errorMessage: data.errorMessage,
            iconRight: data.iconRight))
        let paddingBox = BoxView(subview: inputView).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

// MARK: - Mock
extension DSInputNumberViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputNumberMlc(
            componentId: "componentId",
            inputCode: "inputCode",
            label: "label",
            placeholder: "test",
            hint: "hint",
            value: 1111556,
            maxValue: nil,
            minValue: nil,
            mandatory: true,
            errorMessage: "errorMessage",
            mask: nil,
            iconRight: .mock
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
