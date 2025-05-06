
import UIKit
import DiiaCommonTypes

public class DSCheckboxBtnWhiteOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "checkboxBtnWhiteOrg"
    private let checkboxBuilder = DSCheckboxButtonOrgBuilder()
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSCheckboxBtnOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = checkboxBuilder.makeView(model: model, eventHandler: eventHandler)
        view.layer.borderColor = nil
        view.layer.borderWidth = .zero
        view.layer.cornerRadius = Constants.cornerRadius
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
        paddingBox.subview.backgroundColor = .white
        return paddingBox
    }
}

private extension DSCheckboxBtnWhiteOrgBuilder {
    enum Constants {
        static let cornerRadius: CGFloat = 16
    }
}
