
import UIKit
import DiiaCommonTypes

/// design_system_code: inputTextMultilineMlc
public struct DSMultilineInputTextBuilder: DSViewBuilderProtocol {
    public static let modelKey = "inputTextMultilineMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputTextMultilineMlc = object.parseValue(forKey: Self.modelKey) else { return nil }

        let inputView = TitledMultilineTextView()

        var validators: [TextValidationErrorGenerator] = []
        if let validation = data.validation {
            validators = validation.map { .init(validationModel: $0) }
        }

        inputView.configure(viewModel: TitledTextFieldViewModel(
            id: data.componentId,
            title: data.label,
            placeholder: data.placeholder ?? .empty,
            validators: validators,
            mandatory: data.mandatory,
            defaultText: data.value,
            instructionsText: data.hint,
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
