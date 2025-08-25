
import UIKit
import DiiaCommonTypes

/// design_system_code: inputNumberFractionalMlc
public struct DSInputNumberFractionalViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "inputNumberFractionalMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputNumberMlc = object.parseValue(forKey: self.modelKey) else { return nil }

        let inputView = TitledTextFieldView()

        var validators: [TextValidationErrorGenerator] = []
        if let errorMessage = data.errorMessage {
            validators.append(.init(type: .number(min: data.minValue, max: data.maxValue), error: errorMessage))
        }

        var value: String? = nil
        if let numberValue = data.value {
            value = "\(numberValue)"
        }
        
        inputView.configure(viewModel: TitledTextFieldViewModel(
            id: data.componentId,
            title: data.label,
            placeholder: data.placeholder ?? .empty,
            validators: validators,
            mandatory: data.mandatory,
            defaultText: value,
            instructionsText: data.hint,
            keyboardType: .decimalPad,
            onChangeText: { text in
                eventHandler(.inputChanged(.init(
                    inputCode: data.inputCode ?? self.modelKey,
                    inputData: .string(text))))
            }
        ))

        let paddingBox = BoxView(subview: inputView).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

// MARK: - Mock
extension DSInputNumberFractionalViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputNumberMlc(
            componentId: "componentId",
            inputCode: "inputCode",
            label: "label",
            placeholder: "placeholder",
            hint: "hint",
            value: 0,
            maxValue: 100,
            minValue: 0,
            mandatory: true,
            errorMessage: "errorMessage"
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
