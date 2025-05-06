
import UIKit
import DiiaCommonTypes

public struct DSSearchBarOrgBuilder: DSViewBuilderProtocol {
    static let modelKey = "searchBarOrg"
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSearchBarModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let searchBar = DSSearchBarView()
        searchBar.set(eventHandler: eventHandler)
        searchBar.configure(with: .init(
            componentId: data.componentId,
            searchInputMlc: data.searchInputMlc,
            btnWhiteAdditionalIconAtm: data.btnWhiteAdditionalIconAtm))
        
        let insets = padding.defaultPadding()
        let paddingBox = BoxView(subview: searchBar).withConstraints(insets: insets)
        return paddingBox
    }
}
