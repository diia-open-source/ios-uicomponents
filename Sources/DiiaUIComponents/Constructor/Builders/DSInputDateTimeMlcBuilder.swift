
import UIKit
import DiiaCommonTypes

/// DS_Code: inputDateTimeOrg
public struct DSInputDateTimeMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "inputDateTimeOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputDateTimeModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
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
            eventHandler(.inputChanged(.init(inputCode: data.inputCode ?? Self.modelKey, inputData: text != nil ? .string(text ?? "") : .null)))
        }
        view.configure(viewModel: vm)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
        return paddingBox
    }
}
