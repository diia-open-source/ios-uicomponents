
import UIKit
import DiiaCommonTypes

/// design_system_code: permissionMessageMlc
public struct PermissionMessageMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "permissionMessageMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: PermissionMessageMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = PermissionMessageMlcView()
        view.configure(model: data, eventHandler: eventHandler)
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension PermissionMessageMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = PermissionMessageMlc(
            componentId: "componentId",
            title: "title",
            description: "description",
            btnPrimaryDefaultAtm: .mock
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
