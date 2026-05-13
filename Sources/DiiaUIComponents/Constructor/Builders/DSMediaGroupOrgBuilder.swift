
import UIKit
import DiiaCommonTypes

public struct DSMediaGroupOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "mediaGroupOrg"

    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
            guard let data: DSMediaGroupOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }
            
            let insets = padding.defaultCollectionPadding(object: object, modelKey: modelKey)
            let internalInsets = padding.defaultPaddingV2(object: object, modelKey: modelKey)
            
            let photoCollection = HorizontalPhotoCollectionView()
            var items = [HorizontalPhotoCollectionItem]()
            items.append(contentsOf: data.images.compactMap({
                HorizontalPhotoCollectionItem.image(
                    url: $0,
                    accessibilityDescription: nil
                )
            }))
            items.append(contentsOf: data.video.compactMap({
                HorizontalPhotoCollectionItem.video(
                    url: $0,
                    previewUrl: .empty,
                    accessibilityDescription: nil
                )
            }))
            photoCollection.configure(
                title: data.title,
                description: data.description,
                titleFont: FontBook.usualFont,
                items: items,
                cellSize: CGSize(width: Constants.photoSize,
                                 height: Constants.photoSize),
                sectionInset: .init(left: internalInsets.left, right: internalInsets.right, bottom: .zero, top: .zero))
            photoCollection.accessibilityIdentifier = data.componentId
            
            let paddingBox = BoxView(subview: photoCollection).withConstraints(insets: insets)
            return paddingBox
    }
    
    private enum Constants {
        static let photoSize: CGFloat = 112
    }
}

extension DSMediaGroupOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSMediaGroupOrgModel(
            componentId: "mediaGroupOrg",
            title: "mediaGroupOrg title",
            description: "mediaGroupOrg description",
            video: ["https://samplelib.com/mp4/sample-5s-360p.mp4"],
            images: ["https://images.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"]
        )

        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

public struct DSMediaGroupOrgModel: Codable {
    let componentId: String?
    let title: String?
    let description: String?
    let video: [String]
    let images: [String]
}
