import UIKit
import DiiaCommonTypes

/// DS_code: outlineButtonOrg
public struct OutlineButtonOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "outlineButtonOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSOutlineButtonOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSOutlineBtnOrgView()
        view.configure(model: data)
        view.setEventHandler(eventHandler)
        let insets = paddingType.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension OutlineButtonOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSOutlineButtonOrg(
            componentId: "componentId",
            items: [
                DSOutlineButtonItem(
                    outlineButtonMlc: DSOutlineButtonMlc(
                        componentId: "componentId",
                        title: "title",
                        iconLeft: DSIconModel(
                            code: "code",
                            accessibilityDescription: "accessibilityDescription",
                            componentId: "componentId",
                            action: DSActionParameter(
                                type: "iconAction",
                                subtype: "subtype",
                                resource: "resource",
                                subresource: "subresource"),
                            isEnable: true
                        ),
                        action: DSActionParameter(
                            type: "type",
                            subtype: "subtype",
                            resource: "resource",
                            subresource: "subresource")
                    )
                )
            ]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
