
import UIKit

final public class DSCollectionCarouselView: BaseCodeView {
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var collectionViewLayout = UICollectionViewFlowLayout()
    private var dataSource: UICollectionViewDataSource?
    private var cellSize: CGSize = .zero
    
    override public func setupSubviews() {
        backgroundColor = .clear
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    // MARK: - Public Methods
    public func setupUI(scrollDirection: UICollectionView.ScrollDirection = .vertical,
                 interitemSpacing: CGFloat = Constants.interitemSpacing,
                 sectionInset: UIEdgeInsets) {
        collectionViewLayout.scrollDirection = scrollDirection
        collectionViewLayout.minimumInteritemSpacing = interitemSpacing
        collectionViewLayout.sectionInset = sectionInset
    }
    
    public func configure(dataSource: UICollectionViewDataSource,
                   cellSize: CGSize,
                   cellTypes: [Reusable.Type]) {
        cellTypes.forEach {
            if let cellType = $0 as? NibReusable.Type {
                collectionView.register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseID)
            } else {
                collectionView.register($0, forCellWithReuseIdentifier: $0.reuseID)
            }
        }
        
        self.cellSize = cellSize
        collectionView.withHeight(cellSize.height)
        layoutIfNeeded()
        
        self.dataSource = dataSource
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.reloadData()
    }
}

extension DSCollectionCarouselView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dataSource?.collectionView(collectionView, cellForItemAt: indexPath) else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

extension DSCollectionCarouselView {
    public enum Constants {
        public static let interitemSpacing: CGFloat = 8
    }
}
