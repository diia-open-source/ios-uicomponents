
import UIKit
import DiiaCommonTypes

/// design_system_code: inputPhoneCodeOrg
public struct DSInputPhoneCodeBuilder: DSViewBuilderProtocol {
    public static let modelKey = "inputPhoneCodeOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding paddingType: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSInputPhoneCodeModel = object.parseValue(forKey: Self.modelKey) else { return nil }

        let inputView = DSInputPhoneCodeView()
        inputView.configure(with: .init(
            data: data,
            eventHandler: eventHandler))

        let paddingBox = BoxView(subview: inputView).withConstraints(insets: paddingType.defaultPadding())
        return paddingBox
    }
}
