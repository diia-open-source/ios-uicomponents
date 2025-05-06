
import UIKit
import DiiaCommonTypes

public struct DSTableBlockTwoColumnsBuilder: DSViewBuilderProtocol {
    public static let modelKey = "tableBlockTwoColumns"
    
    public func makeView(from object: AnyCodable,
                         withPadding topPadding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTableBlockTwoColumnPlaneOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSTableBlockTwoColumnsPlaneOrgView()
        view.configure(models: model, imagesContent: [:], eventHandler: eventHandler)
        return view
    }
}
