
import UIKit
import DiiaCommonTypes

/// design_system_code: inputTextMlcV2
public struct InputTextV2Builder: DSViewBuilderProtocol {
    
    public let modelKey = "inputTextMlcV2"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputTextMlc = object.parseValue(forKey: self.modelKey) else { return nil }

        let inputView = TitledTextFieldViewV2()
        inputView.setupUI(
            titleFont: FontBook.statusFont,
            textFont: FontBook.bigText,
            errorFont: FontBook.statusFont)
        
        var validators: [TextValidationErrorGenerator] = []
        if let validation = data.validation {
            validators = validation.map { .init(validationModel: $0) }
        }
        let viewModel = TitledTextFieldViewModel(
            id: data.id,
            inputCode: data.inputCode,
            title: data.label,
            placeholder: data.placeholder ?? .empty,
            validators: validators,
            mask: data.maskCode,
            mandatory: data.mandatory,
            defaultText: data.value,
            instructionsText: data.hint,
            keyboardType: UIKeyboardType(rawValue: data.keyboardType ?? .zero) ?? .default,
            onChangeText: { text in
                eventHandler(.inputChanged(.init(
                    inputCode: data.inputCode ?? self.modelKey,
                    inputData: .string(text))))
            }
        )
        
        if let mask = data.maskCode {
            viewModel.shouldChangeCharacters = TextInputFormatter.textFormatter(
                textField: inputView.textField,
                mask: mask,
                onChange: { text in
                    eventHandler(.inputChanged(.init(
                        inputCode: data.inputCode ?? self.modelKey,
                        inputData: .string(text.removingMask(mask: mask) ?? text))))
                }
            )
        }
        
        inputView.configure(viewModel: viewModel)

        if data.isDisable == true {
            viewModel.fieldState.value = .disabled
        }
        
        let insets = paddingType.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: inputView).withConstraints(insets: insets)
        return paddingBox
    }
}

extension InputTextV2Builder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputTextMlc(
            id: "id",
            blocker: true,
            label: "label",
            placeholder: "placeholder",
            hint: "hint",
            value: "value",
            mandatory: true,
            validation: [
                InputValidationModel(regexp: "^([a-zA-Z0-9_%+-]{1,}\\.){0,}[a-zA-Z0-9_%+-]{1,}@([a-zA-Z0-9_%+-]{1,}\\.){1,}(?!ru|su)[A-Za-z]{2,64}$", flags: ["i"], errorMessage: "Невалідний емейл")
            ],
            inputCode: "email",
            keyboardType: 7,
            isDisable: false
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
