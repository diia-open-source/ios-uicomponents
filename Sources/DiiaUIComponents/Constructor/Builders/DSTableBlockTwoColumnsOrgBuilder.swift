
import UIKit
import DiiaCommonTypes

public struct DSTableBlockTwoColumnsOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "tableBlockTwoColumnsOrg"
    private let imagesContent: [DSDocumentContentData: UIImage]?
    
    public init(imagesContent: [DSDocumentContentData : UIImage]? = nil) {
        self.imagesContent = imagesContent
    }
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableBlockTwoColumnPlaneOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSTableBlockTwoColumnsOrgView()
        view.configure(models: data,
                       imagesContent: imagesContent ?? [:],
                       eventHandler: eventHandler)
        
        let box = BoxView(subview: view).withConstraints(insets: padding.insets(for: object, modelKey: modelKey, defaultInsets: Constants.insets))
        return box
    }
}

extension DSTableBlockTwoColumnsOrgBuilder {
    enum Constants {
        static let insets = UIEdgeInsets(top: 24, left: .zero, bottom: .zero, right: .zero)
    }
}

extension DSTableBlockTwoColumnsOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTableBlockTwoColumnPlaneOrg(
            componentId: "componentId(optional)",
            photo: .photo,
            items: [DSItemsModel(
                tableItemVerticalMlc: .mock
            )],
            headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel(
                value: "value",
                subtitles: ["subtitle1", "subtitle2"]
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
