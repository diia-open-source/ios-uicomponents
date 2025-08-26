
import UIKit

public class TabSelectionView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var tabsCollectionView: UICollectionView!
    @IBOutlet weak private var underlineView: UIView!
    
    @IBOutlet weak private var underlineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var underlineWidthConstraint: NSLayoutConstraint!

    // MARK: - Properties
    private var tabTitles: [String] = []
    
    private var selectedTabIndex = 0 {
        didSet {
            updateUnderline()
        }
    }
    
    public var onItemSelected: (Int) -> Void = { _ in }
    
    // MARK: - LifeCycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        fromNib(bundle: Bundle.module)
        initialSetup()
    }
    
    private func initialSetup() {
        tabsCollectionView.register(TabSelectionCell.nib, forCellWithReuseIdentifier: TabSelectionCell.reuseID)
        tabsCollectionView.contentInset = UIEdgeInsets(
            top: .zero,
            left: Constants.horizontalInset,
            bottom: .zero,
            right: Constants.horizontalInset
        )
        
        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumInteritemSpacing = Constants.interitemSpacing
        tabsCollectionView.collectionViewLayout = flowLayout
        tabsCollectionView.isScrollEnabled = false
        
        tabsCollectionView.dataSource = self
        tabsCollectionView.delegate = self
    }
    
    // MARK: - Private Methods
    private func updateUnderline() {
        guard
            let cell = tabsCollectionView.cellForItem(at: IndexPath(item: selectedTabIndex, section: 0))
        else {
            return
        }
        
        let x = cell.frame.minX + Constants.horizontalInset
        
        underlineLeadingConstraint.constant = x
        underlineWidthConstraint.constant = cell.bounds.width
        
        UIView.animate(withDuration: Constants.animationDuration) { self.layoutIfNeeded() }
    }
    
    // MARK: - Configure
    public func setTitles(_ titles: [String]) {
        self.tabTitles = titles
        tabsCollectionView.performBatchUpdates(nil, completion: { [weak self] _ in self?.updateUnderline() })
    }
    
    public func setActiveTab(index: Int) {
        selectedTabIndex = index
    }
}

// MARK: - UICollectionViewDataSource
extension TabSelectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabSelectionCell.reuseID, for: indexPath) as? TabSelectionCell,
            tabTitles.indices.contains(indexPath.item)
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: tabTitles[indexPath.item])
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabTitles.count
    }
}

// MARK: - UICollectionViewDelegate
extension TabSelectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedTabIndex = indexPath.item
        onItemSelected(indexPath.item)
    }
}

// MARK: - Constants
extension TabSelectionView {
    private enum Constants {
        static let animationDuration: TimeInterval = 0.2
        static let interitemSpacing: CGFloat = 40
        static var horizontalInset: CGFloat {
            switch UIDevice.size() {
            case .screen4Inch, .screen4_7Inch:
                return 16
            default:
                return 24
            }
        }
    }
}
