
import UIKit

public enum HorizontalPhotoCollectionItem {
    case image(url: String)
    case video(url: String, previewUrl: String)
}

public class HorizontalPhotoCollectionView: BaseCodeView {
    private let titleLabel: UILabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let descriptionLabel: UILabel = UILabel().withParameters(font: FontBook.statusFont, textColor: .gray)
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: Constants.stackSpacing, bottom: 0, right: Constants.stackSpacing)
        return layout
    }()
    
    private var items: [HorizontalPhotoCollectionItem] = []
    
    private var cellSize: CGSize = .zero
    
    private var swiftGallery: MediaGallery?

    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        stack(stack(titleLabel, descriptionLabel, spacing: Constants.smallSpacing),
              collectionView, spacing: Constants.stackSpacing)
        
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.register(cellType: PhotoCollectionCell.self)
        collectionView.register(cellType: VideoCollectionCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Configuration
    public func configure(title: String?, imageUrls: [String], cellSize: CGSize) {
        self.items = imageUrls.compactMap({HorizontalPhotoCollectionItem.image(url: $0)})
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        self.cellSize = cellSize
        collectionView.withHeight(cellSize.height)
        layoutIfNeeded()
        collectionView.reloadData()
    }
    
    public func configure(title: String?,
                          description: String? = nil,
                          titleFont: UIFont = FontBook.smallHeadingFont,
                          items: [HorizontalPhotoCollectionItem],
                          cellSize: CGSize,
                          offset: CGFloat? = nil) {
        self.items = items
        titleLabel.text = title
        titleLabel.font = titleFont
        titleLabel.isHidden = title == nil
        descriptionLabel.text = description
        descriptionLabel.isHidden = description == nil
        self.cellSize = cellSize
        let sectionOffset = offset ?? Constants.stackSpacing
        collectionViewLayout.sectionInset = .init(top: .zero, left: sectionOffset, bottom: .zero, right: sectionOffset)
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
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch items[indexPath.row] {
        case .image(let url):
            let cell: PhotoCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: url)
            return cell
        case .video(_, let previewUrl):
            let cell: VideoCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: previewUrl)
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

extension HorizontalPhotoCollectionView: MediaGalleryDataSource, MediaGalleryDelegate {
    public func numberOfImagesInGallery(gallery: MediaGallery) -> Int {
        return items.count
    }
    
    public func mediaInGallery(gallery: MediaGallery, forIndex: Int) -> GalleryContentType? {
        switch items[forIndex] {
        case .image(let url):
            let vm = GalleryImageViewModel(imageLink: url, image: nil)
            vm.actions = [
                .init(title: nil, image: R.image.close.image, callback: { [weak self] in
                    self?.swiftGallery?.dismiss(animated: true)
                    self?.swiftGallery = nil
                })
            ]
            return .image(viewModel: vm)
        case .video(let url, _):
            let vm = GalleryVideoViewModel(streamLink: nil, downloadLink: url)
            vm.actions = [
                .init(title: nil, image: R.image.close.image, callback: { [weak self] in
                    self?.swiftGallery?.dismiss(animated: true)
                    self?.swiftGallery = nil
                })
            ]
            vm.preparePlaying = {[weak vm] in
                if let playURL = URL(string: url) {
                    vm?.state.value = .readyForLoading(url: playURL)
                } else {
                    vm?.state.value = .error(message: Constants.videoURLError)
                }
            }
            return .video(viewModel: vm)
        }
    }
    
    public func galleryDidTapToClose(gallery: MediaGallery) {
        swiftGallery?.dismiss(animated: true, completion: nil)
        swiftGallery = nil
    }
}

private extension HorizontalPhotoCollectionView {
    enum Constants {
        static let videoURLError = "Некоректне посилання на відео"
        static let smallSpacing: CGFloat = 4
        static let stackSpacing: CGFloat = 16
    }
}
