
import UIKit
import DiiaCommonTypes

/// DS_Code: inputDateMlc
public struct DSInputDateMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "inputDateMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputDateModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
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
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
        return paddingBox
    }
}
