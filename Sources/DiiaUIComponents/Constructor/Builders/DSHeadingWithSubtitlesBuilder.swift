
import UIKit
import DiiaCommonTypes

public struct DSHeadingWithSubtitlesBuilder: DSViewBuilderProtocol {
    public static let modelKey = "headingWithSubtitles"
    
    public func makeView(from object: AnyCodable,
                         withPadding topPadding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSHeadingWithSubtitlesModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSHeadingWithSubtitleView()
        view.configure(model: model)
        return view
    }
}
