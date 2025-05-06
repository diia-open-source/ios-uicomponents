
import UIKit
import DiiaCommonTypes

/// design_system_code: articlePicCarouselOrg
public struct DSArticlePicCarouselBuilder: DSViewBuilderProtocol {
    public static let modelKey = "articlePicCarouselOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSArticlePicCarouselModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = HorizontalCollectionView()
        view.configure(
            title: nil,
            datasource: DSArticlePicCarouselDataSource(sourceModel: data),
            cellSize: Constants.cellSize,
            cellTypes: [DSArticlePicCell.self, DSArticleVideoCell.self]
        )
        view.setupUI(pageControlDotColor: Constants.dotColor)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.paddingInsets)
        return paddingBox
    }
}

// MARK: - Data Source
class DSArticlePicCarouselDataSource: NSObject, UICollectionViewDataSource {
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
