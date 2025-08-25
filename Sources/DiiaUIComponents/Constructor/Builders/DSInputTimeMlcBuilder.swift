import UIKit
import DiiaCommonTypes

/// DS_Code: inputTimeMlc
public struct DSInputTimeMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "inputTimeMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputTimeModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let vm = DSInputTimeViewModel(
            id: data.id,
            inputCode: data.inputCode,
            title: data.label,
            placeholder: R.Strings.general_time_picker_hint.localized(),
            validators: [],
            defaultText: data.value,
            instructionsText: data.hint) { text in
                eventHandler(.inputChanged(.init(
                    inputCode: data.id ?? self.modelKey,
                    inputData: .string(text))))
            }
        
        let view = DSInputTimeView()
        view.configure(viewModel: vm)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

// MARK: - Mock
extension DSInputTimeMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputTimeModel(
            componentId: "componentId",
            id: "id",
            inputCode: "inputCode",
            placeholder: "placeholder",
            label: "label",
            value: "value",
            hint: "hint",
            dateFormat: "HH : mm",
            mandatory: true
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
