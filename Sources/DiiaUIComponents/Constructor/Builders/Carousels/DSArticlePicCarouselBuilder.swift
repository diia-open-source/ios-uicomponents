
import UIKit
import DiiaCommonTypes

/// design_system_code: articlePicCarouselOrg
public struct DSArticlePicCarouselBuilder: DSViewBuilderProtocol {
    public let modelKey = "articlePicCarouselOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSArticlePicCarouselModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = HorizontalCollectionView()
        view.configure(
            title: nil,
            datasource: DSArticlePicCarouselDataSource(sourceModel: data),
            cellSize: Constants.cellSize,
            cellTypes: [DSArticlePicCell.self, DSArticleVideoCell.self]
        )
        view.setupUI(pageControlDotColor: Constants.dotColor)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultCollectionPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

// MARK: - Data Source
final class DSArticlePicCarouselDataSource: NSObject, UICollectionViewDataSource {
    private let sourceModel: DSArticlePicCarouselModel

    init(sourceModel: DSArticlePicCarouselModel) {
        self.sourceModel = sourceModel
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let articleVideo = sourceModel.items[indexPath.row].articleVideoMlc {
            let cell: DSArticleVideoCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: articleVideo)
            return cell
        }
        if let articlePic = sourceModel.items[indexPath.row].articlePicAtm {
            let cell: DSArticlePicCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: articlePic)
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceModel.items.count
    }
}

// MARK: - Constants
private enum Constants {
    static let cellSize = CGSize(width: UIScreen.main.bounds.width - 48, height: UIScreen.main.bounds.width * 0.56)
    static let paddingInsets = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    static let dotColor = UIColor("#EEF7F1")
}

extension DSArticlePicCarouselBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSArticlePicCarouselModel(
            dotNavigationAtm: DSDotNavigationModel(count: 3),
            items: [
                DSArticlePicCarouselItem(
                    articlePicAtm: DSImageData(
                        image: "mock_article_image_1",
                        accessibilityDescription: "Mock article image 1"
                    ),
                    articleVideoMlc: DSVideoData(
                        componentId: "mock_video_component_1",
                        source: "mock_video_source_1.mp4",
                        playerBtnAtm: DSPlayerBtnModel(
                            type: "play",
                            icon: "play_icon"
                        ),
                        fullScreenVideoOrg: DSFullScreenVideoOrg(
                            componentId: "mock_fullscreen_video_1",
                            source: "mock_fullscreen_source_1.mp4",
                            playerBtnAtm: DSPlayerBtnModel(
                                type: "play",
                                icon: "play_icon"
                            ),
                            btnPrimaryDefaultAtm: DSButtonModel(
                                label: "Watch Full Screen",
                                state: .enabled,
                                action: DSActionParameter(
                                    type: "video",
                                    subtype: "fullscreen",
                                    resource: "mock_resource",
                                    subresource: "mock_subresource"
                                ),
                                componentId: "mock_fullscreen_button_1"
                            ),
                            btnPlainAtm: DSButtonModel(
                                label: "Close",
                                state: .enabled,
                                action: DSActionParameter(
                                    type: "close",
                                    subtype: "video",
                                    resource: "mock_resource",
                                    subresource: "mock_subresource"
                                ),
                                componentId: "mock_close_button_1"
                            )
                        ),
                        thumbnail: "mock_video_thumbnail_1"
                    )
                ),
                DSArticlePicCarouselItem(
                    articlePicAtm: DSImageData(
                        image: "mock_article_image_2",
                        accessibilityDescription: "Mock article image 2"
                    ),
                    articleVideoMlc: DSVideoData(
                        componentId: "mock_video_component_2",
                        source: "mock_video_source_2.mp4",
                        playerBtnAtm: DSPlayerBtnModel(
                            type: "play",
                            icon: "play_icon"
                        ),
                        fullScreenVideoOrg: DSFullScreenVideoOrg(
                            componentId: "mock_fullscreen_video_2",
                            source: "mock_fullscreen_source_2.mp4",
                            playerBtnAtm: DSPlayerBtnModel(
                                type: "play",
                                icon: "play_icon"
                            ),
                            btnPrimaryDefaultAtm: DSButtonModel(
                                label: "Watch Full Screen",
                                state: .enabled,
                                action: DSActionParameter(
                                    type: "video",
                                    subtype: "fullscreen",
                                    resource: "mock_resource",
                                    subresource: "mock_subresource"
                                ),
                                componentId: "mock_fullscreen_button_2"
                            ),
                            btnPlainAtm: DSButtonModel(
                                label: "Close",
                                state: .enabled,
                                action: DSActionParameter(
                                    type: "close",
                                    subtype: "video",
                                    resource: "mock_resource",
                                    subresource: "mock_subresource"
                                ),
                                componentId: "mock_close_button_2"
                            )
                        ),
                        thumbnail: "mock_video_thumbnail_2"
                    )
                ),
                DSArticlePicCarouselItem(
                    articlePicAtm: DSImageData(
                        image: "mock_article_image_3",
                        accessibilityDescription: "Mock article image 3"
                    ),
                    articleVideoMlc: DSVideoData(
                        componentId: "mock_video_component_3",
                        source: "mock_video_source_3.mp4",
                        playerBtnAtm: DSPlayerBtnModel(
                            type: "play",
                            icon: "play_icon"
                        ),
                        fullScreenVideoOrg: DSFullScreenVideoOrg(
                            componentId: "mock_fullscreen_video_3",
                            source: "mock_fullscreen_source_3.mp4",
                            playerBtnAtm: DSPlayerBtnModel(
                                type: "play",
                                icon: "play_icon"
                            ),
                            btnPrimaryDefaultAtm: DSButtonModel(
                                label: "Watch Full Screen",
                                state: .enabled,
                                action: DSActionParameter(
                                    type: "video",
                                    subtype: "fullscreen",
                                    resource: "mock_resource",
                                    subresource: "mock_subresource"
                                ),
                                componentId: "mock_fullscreen_button_3"
                            ),
                            btnPlainAtm: DSButtonModel(
                                label: "Close",
                                state: .enabled,
                                action: DSActionParameter(
                                    type: "close",
                                    subtype: "video",
                                    resource: "mock_resource",
                                    subresource: "mock_subresource"
                                ),
                                componentId: "mock_close_button_3"
                            )
                        ),
                        thumbnail: "mock_video_thumbnail_3"
                    )
                )
            ]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
