
import UIKit
import DiiaCommonTypes

public struct DSTableBlockTwoColumnsBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableBlockTwoColumns"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSTableBlockTwoColumnPlaneOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSTableBlockTwoColumnsPlaneOrgView()
        view.configure(models: model, imagesContent: [:], eventHandler: eventHandler)
        let box = BoxView(subview: view).withConstraints(insets: padding.insets(for: object, modelKey: modelKey, defaultInsets: .zero))
        return box
    }
}

extension DSTableBlockTwoColumnsBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTableBlockTwoColumnPlaneOrg(
            componentId: "componentId(optional)",
            photo: .photo,
            items: [
                DSItemsModel(
                    tableItemVerticalMlc: .mock
                )
            ],
            headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel(
                value: "value",
                subtitles: ["subtitle1", "subtitle2"],
                componentId: "componentId"
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
