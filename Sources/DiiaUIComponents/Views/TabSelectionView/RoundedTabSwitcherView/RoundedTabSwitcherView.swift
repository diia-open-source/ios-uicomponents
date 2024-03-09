import UIKit

public class RoundedTabSwitcherView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private var viewModel: TabSwitcherViewModel = .init()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib(bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib(bundle: Bundle.module)
    }
    
    // MARK: - Lifecycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    // MARK: - Public Methods
    public func configure(viewModel: TabSwitcherViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
    }
    
    // MARK: - Private
    private func setupCollectionView() {
        collectionView.register(RoundedTabSwitcherCollectionCell.nib, forCellWithReuseIdentifier: RoundedTabSwitcherCollectionCell.reuseID)
        collectionView.contentInset = Constants.collectionViewInsets
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension RoundedTabSwitcherView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tabItem = viewModel.itemAt(index: indexPath.item),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RoundedTabSwitcherCollectionCell.reuseID, for: indexPath) as? RoundedTabSwitcherCollectionCell else { return UICollectionViewCell() }
        
        cell.configure(tabItem: tabItem)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RoundedTabSwitcherView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        viewModel.itemSelected(index: indexPath.item)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RoundedTabSwitcherView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = viewModel.itemAt(index: indexPath.item) else { return .zero }
        return CGSize(width: RoundedTabSwitcherCollectionCell.widthForVM(viewModel: item),
                      height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.minimumHorizontalSpacing
    }
}

private extension RoundedTabSwitcherView {
    struct Constants {
        static let minimumHorizontalSpacing: CGFloat = 8
        static let collectionViewInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
}
