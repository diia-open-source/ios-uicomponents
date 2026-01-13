
import UIKit

public final class EqualTabSelectionView: UIView {
    
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
        tabsCollectionView.register(EqualTabCollectionCell.nib, forCellWithReuseIdentifier: EqualTabCollectionCell.reuseID)
        tabsCollectionView.contentInset = UIEdgeInsets(
            top: .zero,
            left: Constants.horizontalInset,
            bottom: .zero,
            right: Constants.horizontalInset
        )
        
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
        tabsCollectionView.reloadData()
        tabsCollectionView.layoutIfNeeded()
        updateUnderline()
    }
    
    public func setActiveTab(index: Int) {
        selectedTabIndex = index
    }
}

// MARK: - UICollectionViewDataSource
extension EqualTabSelectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EqualTabCollectionCell.reuseID, for: indexPath) as? EqualTabCollectionCell,
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
extension EqualTabSelectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedTabIndex = indexPath.item
        onItemSelected(indexPath.item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {        
        return .init(
            width: (UIScreen.main.bounds.width - 2 * Constants.horizontalInset) / CGFloat(tabTitles.count),
            height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Constants
extension EqualTabSelectionView {
    private enum Constants {
        static let animationDuration: TimeInterval = 0.2
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
