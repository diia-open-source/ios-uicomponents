
import UIKit
import DiiaCommonTypes

/// DS_Code: inputDateTimeOrgV2
public struct DSInputDateTimeOrgV2Builder: DSViewBuilderProtocol {
    public let modelKey = "inputDateTimeOrgV2"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputDateTimeModelV2 = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSInputDateTimeOrgViewV2()
        let vm = DSInputDateTimeViewModel(
            componentId: data.componentId,
            id: data.id,
            maxDate: data.maxDate,
            minDate: data.minDate,
            inputCode: data.inputCode,
            inputDateMlc: data.inputDateMlcV2,
            inputTimeMlc: data.inputTimeMlcV2,
            mandatory: data.inputDateMlcV2?.mandatory == true)
        vm.onChange = { text in
            eventHandler(.inputChanged(.init(
                inputCode: data.inputCode ?? self.modelKey,
                inputData: text != nil ? .string(text ?? "") : .null)))
        }
        view.configure(viewModel: vm)

        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSInputDateTimeOrgV2Builder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputDateTimeModelV2(
            componentId: "componentId",
            id: "componentId",
            maxDate: nil,
            minDate: nil,
            inputCode: "datetime_input",
            inputDateMlc: DSInputDateModel(
                componentId: "componentId",
                id: "componentId",
                inputCode: "date_input",
                blocker: false,
                mandatory: true,
                label: "Select date",
                value: nil,
                hint: "Enter date",
                validation: []
            ),
            inputTimeMlc: DSInputTimeModel(
                componentId: "componentId",
                id: "componentId",
                inputCode: "time_input",
                placeholder: "Select time",
                label: "Time",
                value: nil,
                hint: "Enter time",
                dateFormat: "HH:mm",
                mandatory: true
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
