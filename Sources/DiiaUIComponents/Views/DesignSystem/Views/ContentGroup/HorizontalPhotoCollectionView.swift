import UIKit

public class HorizontalPhotoCollectionView: BaseCodeView {
    private let titleLabel: UILabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: Constants.stackSpacing, bottom: 0, right: Constants.stackSpacing)
        
        return layout
    }()
    
    private var imageUrls: [String] = []
    private var cellSize: CGSize = .zero
    
    private var swiftGallery: MediaGallery?

    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        stack(titleLabel, collectionView, spacing: Constants.stackSpacing)
        
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.register(cellType: PhotoCollectionCell.self)
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Configuration
    public func configure(title: String?, imageUrls: [String], cellSize: CGSize) {
        self.imageUrls = imageUrls
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        self.cellSize = cellSize
        collectionView.withHeight(cellSize.height)
        layoutIfNeeded()
        collectionView.reloadData()
    }
}

extension HorizontalPhotoCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let swiftGallery = MediaGallery(delegate: self, dataSource: self)
        swiftGallery.modalPresentationStyle = .overFullScreen
        self.swiftGallery = swiftGallery
        swiftGallery.startPage = indexPath.item
        let vc = window?.visibleViewController
        vc?.present(swiftGallery, animated: true, completion: nil)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhotoCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        if imageUrls.indices.contains(indexPath.item) {
            cell.configure(with: imageUrls[indexPath.item])
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

extension HorizontalPhotoCollectionView: MediaGalleryDataSource, MediaGalleryDelegate {
    public func numberOfImagesInGallery(gallery: MediaGallery) -> Int {
        return imageUrls.count
    }
    
    public func mediaInGallery(gallery: MediaGallery, forIndex: Int) -> GalleryContentType? {
        guard imageUrls.indices.contains(forIndex) else { return nil }
        let vm = GalleryImageViewModel(imageLink: imageUrls[forIndex], image: nil)
        vm.actions = [
            .init(title: nil, image: R.image.close.image, callback: { [weak self] in
                self?.swiftGallery?.dismiss(animated: true)
                self?.swiftGallery = nil
            })
        ]
        return .image(viewModel: vm)
    }
    
    public func galleryDidTapToClose(gallery: MediaGallery) {
        swiftGallery?.dismiss(animated: true, completion: nil)
        swiftGallery = nil
    }
}

private extension HorizontalPhotoCollectionView {
    enum Constants {
        static let interitemInset: CGFloat = 8
        static let stackSpacing: CGFloat = 16
    }
}
