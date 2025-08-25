
import UIKit
import DiiaCommonTypes

/// design_system_code: inputTextMultilineMlc
public struct DSMultilineInputTextBuilder: DSViewBuilderProtocol {
    public let modelKey = "inputTextMultilineMlc"

    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputTextMultilineMlc = object.parseValue(forKey: self.modelKey) else { return nil }

        let inputView = TitledMultilineTextView()

        var validators: [TextValidationErrorGenerator] = []
        if let validation = data.validation {
            validators = validation.map { .init(validationModel: $0) }
        }

        inputView.configure(viewModel: TitledTextFieldViewModel(
            componentId: data.componentId,
            id: data.componentId,
            inputCode: data.inputCode,
            title: data.label,
            placeholder: data.placeholder ?? .empty,
            validators: validators,
            mandatory: data.mandatory,
            defaultText: data.value,
            instructionsText: data.hint,
            onChangeText: { text in
                eventHandler(.inputChanged(.init(
                    inputCode: data.inputCode ?? self.modelKey,
                    inputData: .string(text))))
            }
        ))

        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: inputView).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSMultilineInputTextBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputTextMultilineMlc(
            componentId: "componentId",
            inputCode: "multiline_input",
            label: "Text input",
            placeholder: "Enter text",
            hint: "Enter your text here",
            value: nil,
            mandatory: true,
            validation: []
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
