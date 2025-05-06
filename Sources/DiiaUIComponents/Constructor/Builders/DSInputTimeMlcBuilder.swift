import UIKit
import DiiaCommonTypes

/// DS_Code: inputTimeMlc
public struct DSInputTimeMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "inputTimeMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSInputTimeModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let vm = DSInputTimeViewModel(
            id: data.id,
            inputCode: data.inputCode,
            title: data.label,
            placeholder: R.Strings.general_time_picker_hint.localized(),
            validators: [],
            defaultText: data.value,
            instructionsText: data.hint) { text in
                eventHandler(.inputChanged(.init(
                    inputCode: data.id ?? Self.modelKey,
                    inputData: .string(text))))
            }
        
        let view = DSInputTimeView()
        view.configure(viewModel: vm)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
        return paddingBox
    }
}
