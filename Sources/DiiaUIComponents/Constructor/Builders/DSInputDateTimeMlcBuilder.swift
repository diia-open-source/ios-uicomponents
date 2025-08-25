
import UIKit
import DiiaCommonTypes

/// DS_Code: inputDateTimeOrg
public struct DSInputDateTimeMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "inputDateTimeOrg"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputDateTimeModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSInputDateTimeView()
        let vm = DSInputDateTimeViewModel(
            componentId: data.componentId,
            id: data.id,
            maxDate: data.maxDate,
            minDate: data.minDate,
            inputCode: data.inputCode,
            inputDateMlc: data.inputDateMlc,
            inputTimeMlc: data.inputTimeMlc,
            mandatory: data.inputDateMlc?.mandatory == true,
            timezone: .init(identifier: "Europe/Kyiv") ?? .current)
        vm.onChange = { text in
            eventHandler(.inputChanged(.init(inputCode: data.inputCode ?? self.modelKey, inputData: text != nil ? .string(text ?? "") : .null)))
        }
        view.configure(viewModel: vm)

        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSInputDateTimeMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputDateTimeModel(
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
