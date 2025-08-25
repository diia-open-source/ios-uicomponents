
import UIKit
import DiiaCommonTypes

public struct DSEditAutomaticallyDeterminedValueBuilder: DSViewBuilderProtocol {
    public let modelKey = "editAutomaticallyDeterminedValueOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSEditAutomaticallyDeterminedValueOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSEditAutomaticallyDeterminedValueView()
        
        var validators: [TextValidationErrorGenerator] = []
        if let validation = data.inputTextMultilineMlc.validation {
            validators = validation.map { .init(validationModel: $0) }
        }

        let inputViewModel = TitledTextFieldViewModel(
            componentId: data.componentId,
            inputCode: data.inputTextMultilineMlc.inputCode,
            title: data.inputTextMultilineMlc.label,
            placeholder: data.inputTextMultilineMlc.placeholder ?? .empty,
            validators: validators,
            mandatory: data.inputTextMultilineMlc.mandatory,
            defaultText: data.inputTextMultilineMlc.value,
            instructionsText: data.inputTextMultilineMlc.hint,
            onChangeText: { text in
                eventHandler(.inputChanged(.init(inputCode: data.inputTextMultilineMlc.inputCode ?? self.modelKey,
                                                 inputData: .string(text))))
            }
        )
        
        let viewModel = DSEditAutomaticallyDeterminedValueViewModel(title: data.title,
                                                                    label: data.label,
                                                                    value: data.value,
                                                                    inputMlc: inputViewModel,
                                                                    componentId: data.componentId)
        
        view.configure(for: viewModel)
        let box = BoxView(subview: view).withConstraints(insets: paddingType.insets(for: object, modelKey: modelKey, defaultInsets: .allSides(Constants.offset)))
        return box
    }
}

extension DSEditAutomaticallyDeterminedValueBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let inputTextMlc = DSInputTextMultilineMlc(
            componentId: "componentId",
            inputCode: "textInput",
            label: "Input Label",
            placeholder: "Enter text here",
            hint: "This is a hint text",
            value: "Default value",
            mandatory: true,
            validation: nil
        )
        
        let model = DSEditAutomaticallyDeterminedValueOrg(
            title: "Edit Value",
            label: "Current Label",
            value: "Current Value",
            inputTextMultilineMlc: inputTextMlc,
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

private extension DSEditAutomaticallyDeterminedValueBuilder {
    enum Constants {
        static let offset: CGFloat = 24
    }
}
