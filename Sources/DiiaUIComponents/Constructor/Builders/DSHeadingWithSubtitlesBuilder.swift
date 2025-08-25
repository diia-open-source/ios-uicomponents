
import UIKit
import DiiaCommonTypes

public struct DSHeadingWithSubtitlesBuilder: DSViewBuilderProtocol {
    public let modelKey = "headingWithSubtitlesMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding paddingType: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let model: DSHeadingWithSubtitlesModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSHeadingWithSubtitleView()
        view.configure(model: model)
        
        let insets = paddingType.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSHeadingWithSubtitlesBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSHeadingWithSubtitlesModel(
            value: "Main Heading",
            subtitles: ["First subtitle", "Second subtitle", "Third subtitle"]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
