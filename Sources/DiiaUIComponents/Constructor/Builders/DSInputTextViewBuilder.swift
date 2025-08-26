
import UIKit
import DiiaCommonTypes

/// design_system_code: inputTextMlc
public struct DSInputTextViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "inputTextMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputTextMlc = object.parseValue(forKey: self.modelKey) else { return nil }

        let inputView = TitledTextFieldView()
        inputView.setupUI(
            titleFont: FontBook.statusFont,
            textFont: FontBook.bigText,
            errorFont: FontBook.statusFont)
        
        var validators: [TextValidationErrorGenerator] = []
        if let validation = data.validation {
            validators = validation.map { .init(validationModel: $0) }
        }

        var rightAction: Action? = nil
        if let rightIcon = data.iconRight, let action = rightIcon.action {
            rightAction = .init(
                image: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: rightIcon.code) ?? UIImage(),
                callback: {
                eventHandler(.action(action))
            })
        }
        
        let vm = TitledTextFieldViewModel(
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
            },
            rightAction: rightAction
        )
        
        if let mask = data.maskCode {
            vm.shouldChangeCharacters = TextInputFormatter.textFormatter(
                textField: inputView.textField,
                mask: mask,
                onChange: { text in
                    eventHandler(.inputChanged(.init(
                        inputCode: data.inputCode ?? self.modelKey,
                        inputData: .string(text.removingMask(mask: mask) ?? text))))
                }
            )
        }
        
        inputView.configure(viewModel: vm)
        
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: inputView).withConstraints(insets: insets)
        return paddingBox
    }
}

// MARK: - Mock
extension DSInputTextViewBuilder: DSViewMockableBuilderProtocol {
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
                InputValidationModel(
                    regexp: "^([a-zA-Z0-9_%+-]{1,}\\.){0,}[a-zA-Z0-9_%+-]{1,}@([a-zA-Z0-9_%+-]{1,}\\.){1,}(?!ru|su)[A-Za-z]{2,64}$",
                    flags: ["i"],
                    errorMessage: "Невалідний емейл"
                )
            ],
            inputCode: "email",
            iconRight: .mock,
            keyboardType: 7,
            isDisable: false
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
