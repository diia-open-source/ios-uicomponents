
import UIKit
import DiiaCommonTypes

///design_system_code: contentCardOrg
public struct ContentCardOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "contentCardOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let contentCardOrg: ContentCardOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = ContentCardOrgView()
        view.configure(with: contentCardOrg, eventHandler: eventHandler)
        let insets = padding.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        
        return paddingBox
    }
}

extension ContentCardOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = ContentCardOrg(
            componentId: "contentCardOrg_id",
            chipStatusAtm: .mock,
            rightLabel: "rightLabel",
            iconLeft: .mock,
            label: "label",
            description: "description",
            iconTexts: [],
            rightIconText: DSIconTextModel.init(iconLeft: .mock, text: "text"),
            points: "mock * mock * mock",
            bottomContent: [],
            iconBottom: .mock,
            action: .mock)
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
