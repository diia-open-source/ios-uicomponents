
import UIKit
import DiiaCommonTypes

public struct DSEditAutomaticallyDeterminedValueBuilder: DSViewBuilderProtocol {
    public static let modelKey = "editAutomaticallyDeterminedValueOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSEditAutomaticallyDeterminedValueOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
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
                eventHandler(.inputChanged(.init(inputCode: data.inputTextMultilineMlc.inputCode ?? Self.modelKey,
                                                 inputData: .string(text))))
            }
        )
        
        let viewModel = DSEditAutomaticallyDeterminedValueViewModel(title: data.title,
                                                                    label: data.label,
                                                                    value: data.value,
                                                                    inputMlc: inputViewModel,
                                                                    componentId: data.componentId)
        
        view.configure(for: viewModel)
        let container = UIView()
        container.addSubview(view)
        view.fillSuperview(padding: .allSides(Constants.offset))
        return container
    }
}

private extension DSEditAutomaticallyDeterminedValueBuilder {
    enum Constants {
        static let offset: CGFloat = 24
    }
}
