
import UIKit

public class RoundedTabSelectionView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var tabsCollectionView: UICollectionView!

    // MARK: - Properties
    private var tabVMs: [TabSelectionViewModel] = []
    private var onItemSelected: ((Int) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib(bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib(bundle: Bundle.module)
    }
    
    // MARK: - LifeCycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        initialSetup()
    }
    
    private func initialSetup() {
        tabsCollectionView.register(RoundedTabSelectionCell.nib, forCellWithReuseIdentifier: RoundedTabSelectionCell.reuseID)
        tabsCollectionView.contentInset = Constants.collectionViewInsets
        tabsCollectionView.dataSource = self
        tabsCollectionView.delegate = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = Constants.minimumHorizontalSpacing
        tabsCollectionView.collectionViewLayout = flowLayout
    }
    
    // MARK: - Configure
    public func setup(viewModels: [TabSelectionViewModel], onItemSelected: @escaping (Int) -> Void) {
        self.tabVMs = viewModels
        self.onItemSelected = onItemSelected
        tabsCollectionView.reloadData()
        tabsCollectionView.layoutIfNeeded()
    }
    
    private func setActiveTab(index: Int) {
        guard tabVMs.indices.contains(index) else { return }
        tabVMs.forEach { $0.isSelected = false }
        tabVMs[index].isSelected = true
        tabsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension RoundedTabSelectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedTabSelectionCell.reuseID, for: indexPath) as? RoundedTabSelectionCell,
            tabVMs.indices.contains(indexPath.item)
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: tabVMs[indexPath.item])
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabVMs.count
    }
}

// MARK: - UICollectionViewDelegate
extension RoundedTabSelectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onItemSelected?(indexPath.item)
        setActiveTab(index: indexPath.item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard tabVMs.indices.contains(indexPath.item) else { return .zero }
        return .init(
            width: RoundedTabSelectionCell.widthForVM(viewModel: tabVMs[indexPath.item]),
            height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumHorizontalSpacing
    }
}

// MARK: - Constants
private extension RoundedTabSelectionView {
    struct Constants {
        static let minimumHorizontalSpacing: CGFloat = 8
        static let collectionViewInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
}
