
import UIKit
import DiiaCommonTypes

///design_system_code: scanModalCardOrg
public struct ScanModalCardBuilder: DSViewBuilderProtocol {
    public let modelKey = "scanModalCardOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let scanCardOrg: ScanModalCardOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let scanModalCardView = ScanModalCardView()
        scanModalCardView.configure(model: scanCardOrg, eventHandler: eventHandler)
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: scanModalCardView).withConstraints(insets: insets)
        return paddingBox
    }
}

extension ScanModalCardBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = ScanModalCardOrg(
            componentId: "scanModalCardOrg",
            title: "title",
            chipStatusAtm: .mock,
            description: "description",
            tableItems: [.init()],
            attentionIconMessageMlc: .mock,
            items: [.init(listItemMlc: .init(label: "mock"))],
            mediumIconAtm: .mock)
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
