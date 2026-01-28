
import UIKit
import DiiaCommonTypes

///design_system_code: scanModalMessageOrg
public struct DSScanModalMessageBuilder: DSViewBuilderProtocol {
    public let modelKey = "scanModalMessageOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let scanModalMessageOrg: ScanModalMessageOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let scanModalMessageView = DSScanModalMessageView()
        scanModalMessageView.configure(model: scanModalMessageOrg, eventHandler: eventHandler)
        
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: scanModalMessageView).withConstraints(insets: insets)
        
        return paddingBox
    }
}

extension DSScanModalMessageBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = ScanModalMessageOrgModel(
            componentId: "scanModalMessageOrg",
            title: "title",
            description: "description?",
            iconCentre: .mock,
            btnPrimaryDefaultAtm: .mock,
            mediumIconAtm: .mock
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
