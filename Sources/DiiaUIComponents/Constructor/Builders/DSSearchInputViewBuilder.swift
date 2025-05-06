
import UIKit
import DiiaCommonTypes

public struct DSSearchInputViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "searchInputMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSearchModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = makeView(data: data, eventHandler: eventHandler)
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.padding)
        return paddingBox
    }
    
    func makeView(data: DSSearchModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView {
        let view = DSSearchInputView()
        view.setup(
            placeholder: data.label,
            textChangeCallback: {
                eventHandler(.inputChanged(.init(
                    inputCode: Self.modelKey,
                    inputData: .string(view.searchText ?? .empty))))
            })
        return view
    }
    
    private enum Constants {
        static let padding = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
}
