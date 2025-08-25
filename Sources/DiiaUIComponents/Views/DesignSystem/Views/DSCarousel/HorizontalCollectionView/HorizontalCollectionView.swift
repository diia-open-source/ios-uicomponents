
import UIKit

public class HorizontalCollectionView: UIView {

    @IBOutlet weak private var titleLabelContainer: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var scrollingPageContainer: UIView!
    @IBOutlet weak private var scrollingPageControl: ScrollingPageControl!
    @IBOutlet weak private var collectionHeightConstraint: NSLayoutConstraint!
    
    private var datasource: UICollectionViewDataSource?
    private var accessibilityDescridable: AccessibilityDescridable?
    private var delegate: UICollectionViewDelegate?
    private var cellSize: CGSize = .zero
    private var eventHandler: ((ConstructorItemEvent) -> Void)?

    private var indexOfCellBeforeDragging = 0
    private var horizontalVelocity: CGFloat = 0
    
    private var pagingData: (current: Int, total: Int) = (0, 0) {
        didSet {
            scrollingPageContainer.isHidden = pagingData.total < Constants.minAmountToShowPages
            scrollingPageControl.dotSize = Constants.dotSize
            
            scrollingPageControl.maxDots = Constants.maxDots
            scrollingPageControl.centerDots = Constants.centerDots
            
            scrollingPageControl.pages = pagingData.total
            scrollingPageControl.selectedPage = pagingData.current
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        fromNib(bundle: Bundle.module)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib(bundle: Bundle.module)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Configuration
    public func configure(
        title: String?,
        datasource: UICollectionViewDataSource,
        accessibilityDescridable: AccessibilityDescridable? = nil,
        cellSize: CGSize,
        cellTypes: [Reusable.Type],
        eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
            self.eventHandler = eventHandler
            
            titleLabelContainer.isHidden = title == nil
            titleLabel.text = title
            
            cellTypes.forEach {
                if let cellType = $0 as? NibReusable.Type {
                    collectionView.register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseID)
                } else {
                    collectionView.register($0, forCellWithReuseIdentifier: $0.reuseID)
                }
            }
            
            self.cellSize = cellSize
            collectionHeightConstraint.constant = cellSize.height
            layoutIfNeeded()
            
            self.accessibilityDescridable = accessibilityDescridable
            
            self.datasource = datasource
            pagingData.total = datasource.collectionView(collectionView, numberOfItemsInSection: 0)
            collectionView.reloadData()
        }
    
    public func setupUI(pageControlDotColor: UIColor = Constants.pageControlDotColor,
                        pageControlSelectedColor: UIColor = .black) {
        translatesAutoresizingMaskIntoConstraints = false
        scrollingPageControl.dotColor = pageControlDotColor
        scrollingPageControl.selectedColor = pageControlSelectedColor
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
}

extension HorizontalCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.collectionView(collectionView, numberOfItemsInSection: 0) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = datasource?.collectionView(collectionView, cellForItemAt: indexPath) else {
            return UICollectionViewCell()
        }
        
        if let accessibilityDescridable = accessibilityDescridable,
           let accessibilityDescriptions = accessibilityDescridable.accessibilityDescriptions
        {
            let description = accessibilityDescriptions[indexPath.item]
            
            cell.isAccessibilityElement = true
            cell.accessibilityLabel = description
            cell.accessibilityTraits = .button
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    private func indexWithVelocity(velocity: CGFloat) -> Int {
        var indexOfMajorCell = self.indexOfMajorCell()
        if indexOfMajorCell == indexOfCellBeforeDragging {
            let numberOfItems = collectionView.numberOfItems(inSection: 0)
            if velocity > 0.1 && indexOfMajorCell < (numberOfItems - 1) {
                indexOfMajorCell += 1
            } else if velocity < -0.1 && indexOfMajorCell > 0 {
                indexOfMajorCell -= 1
            }
        }
        return indexOfMajorCell
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = cellSize.width + Constants.interItemInset
        let proportionalOffset = (collectionView.contentOffset.x) / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.x < -2.5 || velocity.x > 2.5 {
            horizontalVelocity = velocity.x
            return
        } else {
            targetContentOffset.pointee = scrollView.contentOffset
            horizontalVelocity = 0
        }
        targetContentOffset.pointee = scrollView.contentOffset
        
        scrollToCenter(with: velocity.x)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToCenter(with: horizontalVelocity)
        horizontalVelocity = 0
    }
    
    func scrollToCenter(with horizontalVelocity: CGFloat) {
        let indexOfMajorCell = indexWithVelocity(velocity: horizontalVelocity)
        
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        pagingData.current = indexOfMajorCell
        if let genericCell = collectionView.cellForItem(at: indexPath) as? GenericCollectionViewCell,
           let cellItemId = genericCell.viewId {
            eventHandler?(.collectionChange(item: cellItemId))
        }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension HorizontalCollectionView {
    public enum Constants {
        public static let minAmountToShowPages = 2
        public static let pageControlDotColor: UIColor = .black.withAlphaComponent(0.3)
        public static let interItemInset: CGFloat = 8
        
        public static let maxDots = 6
        public static let centerDots = 3
        public static let dotSize: CGFloat = 8
    }
}
