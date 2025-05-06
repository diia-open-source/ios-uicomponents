
import UIKit
import DiiaCommonTypes

/// design_system_code: inputNumberFractionalMlc
public struct DSInputNumberFractionalViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "inputNumberFractionalMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputNumberMlc = object.parseValue(forKey: Self.modelKey) else { return nil }

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
                    inputCode: data.inputCode ?? Self.modelKey,
                    inputData: .string(text))))
            }
        ))

        let paddingBox = BoxView(subview: inputView).withConstraints(insets: paddingType.defaultPadding())
        return paddingBox
    }
}
