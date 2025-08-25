
import UIKit
import DiiaCommonTypes

/// DS_Code: inputDateMlc
public struct DSInputDateMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "inputDateMlc"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputDateModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let validators = data.validation?.compactMap {
            TextValidationErrorGenerator(validationModel: $0)
        } ?? []
        let vm = DSInputDateViewModel(
            id: data.id,
            inputCode: data.inputCode,
            title: data.label,
            placeholder: R.Strings.general_date_picker_hint.localized(),
            validators: validators,
            defaultText: data.value,
            instructionsText: data.hint,
            enableManualEnter: false) { text in
                eventHandler(.inputChanged(.init(
                    inputCode: data.id ?? "inputDateMlc",
                    inputData: .string(text))))
            }

        let view = DSInputDateView()
        view.configure(viewModel: vm)

        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSInputDateMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputDateModel(
            componentId: "componentId",
            id: "componentId",
            inputCode: "date_input",
            blocker: false,
            mandatory: true,
            label: "Select date",
            value: nil,
            hint: "Enter date",
            validation: []
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
