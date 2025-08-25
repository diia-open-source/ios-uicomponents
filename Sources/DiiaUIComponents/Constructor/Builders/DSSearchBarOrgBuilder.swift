
import UIKit
import DiiaCommonTypes

public struct DSSearchBarOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "searchBarOrg"
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSearchBarModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let searchBar = DSSearchBarView()
        searchBar.set(eventHandler: eventHandler)
        searchBar.configure(with: .init(
            componentId: data.componentId,
            searchInputMlc: data.searchInputMlc,
            btnWhiteAdditionalIconAtm: data.btnWhiteAdditionalIconAtm))
        
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: searchBar).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSSearchBarOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSSearchBarModel(
            componentId: "componentId",
            searchInputMlc: .init(
                componentId: "componentId",
                label: "label",
                iconLeft: .mock,
                iconRight: .mock
            ),
            btnWhiteAdditionalIconAtm: DSButtonWhiteAdditionalIconAtm(
                id: "id",
                state: .enabled,
                label: "label",
                icon: "icon",
                accessibilityDescription: "accessibilityDescription(optional)",
                badgeCounterAtm: DSBadgeCounterModel(count: 2),
                action: .mock,
                componentId: "componentId"
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
