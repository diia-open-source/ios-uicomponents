
import UIKit
import DiiaCommonTypes

/// design_system_code: inputTextMlc
public struct DSInputTextViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "inputTextMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputTextMlc = object.parseValue(forKey: Self.modelKey) else { return nil }

        let inputView = TitledTextFieldView()
        inputView.setupUI(
            titleFont: FontBook.statusFont,
            textFont: FontBook.bigText,
            errorFont: FontBook.statusFont)
        
        var validators: [TextValidationErrorGenerator] = []
        if let validation = data.validation {
            validators = validation.map { .init(validationModel: $0) }
        }

        inputView.configure(viewModel: TitledTextFieldViewModel(
            id: data.id,
            inputCode: data.inputCode,
            title: data.label,
            placeholder: data.placeholder ?? .empty,
            validators: validators,
            mandatory: data.mandatory,
            defaultText: data.value,
            instructionsText: data.hint,
            keyboardType: UIKeyboardType(rawValue: data.keyboardType ?? .zero) ?? .default,
            onChangeText: { text in
                eventHandler(.inputChanged(.init(
                    inputCode: data.inputCode ?? Self.modelKey,
                    inputData: .string(text))))
            }
        ))

        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: inputView).withConstraints(insets: insets)
        return paddingBox
    }
}
