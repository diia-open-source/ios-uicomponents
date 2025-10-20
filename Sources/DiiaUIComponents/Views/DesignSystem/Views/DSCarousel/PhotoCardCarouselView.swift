
import UIKit
import DiiaCommonTypes

public final class PhotoCardCarouselView: BaseCodeView {
    
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    private let scrollingPageControl = InteractivePageControl()
    private var collectionHeightConstraint = NSLayoutConstraint()
    
    private var accessibilityDescridable: AccessibilityDescridable?
    private var delegate: UICollectionViewDelegate?
    private var cellSize: CGSize = .zero
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    private(set) var sourceModel: PhotoCardCarouseModel?
    private var fabric: DSViewFabric?
    
    private var visibleIndexPath: IndexPath?
    private var isScrollingProgrammatically = false
    private var isUserScrolling = false
    private var isPageControlScrolling = false
    private var originalViewModels = [PhotoCardMlcViewModel]()
    private var infiniteViewModels: [PhotoCardMlcViewModel] = []
    
    private var realItemCount: Int { originalViewModels.count }
    private var totalItemCount: Int { infiniteViewModels.count }
    
    private var currentRealIndex: Int = 0 {
        didSet {
            guard currentRealIndex != oldValue else { return }
            updatePageControl()
        }
    }
    
    public override func setupSubviews() {
        backgroundColor = .clear
        collectionView.backgroundColor = .clear
        
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: Constants.defaultCellHeight)
        collectionHeightConstraint.isActive = true
        
        scrollingPageControl.clipsToBounds = true
        scrollingPageControl.layer.cornerRadius = Constants.pageControlSize.height / 2
        
        let scrollingBox = BoxView(subview: scrollingPageControl)
            .withConstraints(size: Constants.pageControlSize,
                             centeredX: true,
                             centeredY: true)
        scrollingBox.withHeight(Constants.pageControlSize.height)
        
        let mainStack = UIStackView.create(
            views: [collectionView, scrollingBox],
            spacing: Constants.stackSpacing)
        addSubview(mainStack)
        mainStack.fillSuperview()
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        scrollingPageControl.addTarget(
            self,
            action: #selector(handlePageControlChange(_:)),
            for: .valueChanged)
        
        setupUI()
    }
    
    // MARK: - Configuration
    public func configure(
        sourceModel: PhotoCardCarouseModel,
        fabric: DSViewFabric,
        accessibilityDescridable: AccessibilityDescridable? = nil,
        cellSize: CGSize,
        cellTypes: [Reusable.Type],
        eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
            
            self.eventHandler = eventHandler
            self.sourceModel = sourceModel
            self.fabric = fabric
            self.accessibilityDescridable = accessibilityDescridable
            self.cellSize = cellSize
            
            self.originalViewModels = sourceModel.items.map {
                PhotoCardMlcViewModel(photoCardMlc: $0, eventHandler: eventHandler)
            }
            
            setupInfiniteViewModels()
            registerCellTypes(cellTypes)
            setupCollectionViewLayout()
            setupPageControl()
            
            collectionView.reloadData()
            collectionView.performBatchUpdates(nil) { _ in
                self.scrollToFirstPage()
            }
        }
    
    private func setupInfiniteViewModels() {
        guard realItemCount > 0 else { return }
        
        if realItemCount == 1 {
            infiniteViewModels = originalViewModels
        } else {
            infiniteViewModels = []
            for _ in 0..<Constants.bufferMultiplier {
                infiniteViewModels.append(contentsOf: originalViewModels)
            }
        }
    }
    
    private func registerCellTypes(_ cellTypes: [Reusable.Type]) {
        cellTypes.forEach {
            if let cellType = $0 as? NibReusable.Type {
                collectionView.register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseID)
            } else {
                collectionView.register($0, forCellWithReuseIdentifier: $0.reuseID)
            }
        }
    }
    
    private func setupCollectionViewLayout() {
        let layout = ZoomAndSnapFlowLayout(itemSize: cellSize,
                                           minimumSpacing: Constants.interItemInset)
        layout.minimumLineSpacing = Constants.interItemInset
        layout.minimumInteritemSpacing = .zero
        layout.sectionInset = Constants.sectionInset
        
        collectionView.collectionViewLayout = layout
        collectionView.decelerationRate = .fast
        collectionHeightConstraint.constant = cellSize.height
        layoutIfNeeded()
    }
    
    private func setupPageControl() {
        scrollingPageControl.numberOfPages = realItemCount
        scrollingPageControl.currentPage = 0
        scrollingPageControl.hidesForSinglePage = true
        currentRealIndex = 0
    }
    
    private func scrollToFirstPage() {
        guard realItemCount > 0, totalItemCount > 0 else { return }
        
        if realItemCount == 1 {
            currentRealIndex = 0
            return
        }
        
        let startIndex = (Constants.bufferMultiplier / 2) * realItemCount
        let indexPath = IndexPath(item: startIndex, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        currentRealIndex = 0
    }
    
    @objc private func handlePageControlChange(_ sender: UIPageControl) {
        let targetRealIndex = sender.currentPage
        guard targetRealIndex >= 0 && targetRealIndex < realItemCount else { return }
        
        isPageControlScrolling = true
        scrollToRealIndexForPageControl(targetRealIndex, animated: true)
    }
    
    private func scrollToRealIndexForPageControl(_ realIndex: Int, animated: Bool) {
        guard realIndex >= 0 && realIndex < realItemCount else { return }
        
        isScrollingProgrammatically = true
        isUserScrolling = false
        
        collectionView.indexPathsForVisibleItems.forEach { indexPath in
            let cell = collectionView.cellForItem(at: indexPath) as? GenericCollectionViewCell
            cell?.setContent(isHidden: false, animated: false)
        }
        
        let targetItem: Int
        
        if realItemCount == 1 {
            targetItem = 0
        } else {
            let middleSection = Constants.bufferMultiplier / 2
            targetItem = middleSection * realItemCount + realIndex
        }
        
        let targetIndexPath = IndexPath(item: targetItem, section: 0)
        
        guard targetItem >= 0 && targetItem < totalItemCount else {
            isScrollingProgrammatically = false
            isPageControlScrolling = false
            return
        }
        
        collectionView.scrollToItem(at: targetIndexPath, at: .centeredHorizontally, animated: animated)
        
        currentRealIndex = realIndex
        
        if !animated {
            isScrollingProgrammatically = false
            isPageControlScrolling = false
            updateCellVisibility()
        }
    }
    
    private func findClosestInfiniteIndex(for realIndex: Int, from currentItem: Int) -> Int {
        guard realItemCount > 1 else { return realIndex }
        
        var closestIndex = realIndex
        var minDistance = Int.max
        
        for section in 0..<Constants.bufferMultiplier {
            let infiniteIndex = section * realItemCount + realIndex
            if infiniteIndex >= 0 && infiniteIndex < totalItemCount {
                let distance = abs(currentItem - infiniteIndex)
                if distance < minDistance {
                    minDistance = distance
                    closestIndex = infiniteIndex
                }
            }
        }
        
        if closestIndex == realIndex && realItemCount > 1 {
            let middleSection = Constants.bufferMultiplier / 2
            closestIndex = middleSection * realItemCount + realIndex
        }
        
        return min(max(closestIndex, 0), totalItemCount - 1)
    }
    
    private func updatePageControl() {
        scrollingPageControl.currentPage = currentRealIndex
    }
    
    private func calculateRealIndex(from infiniteIndex: Int) -> Int {
        guard realItemCount > 0 else { return 0 }
        return infiniteIndex % realItemCount
    }
    
    // MARK: - Cell Visibility Management
    private func updateCellVisibility() {
        guard !isUserScrolling || !isScrollingProgrammatically else { return }
        
        let itemWidth = cellSize.width + Constants.interItemInset
        let currentOffset = collectionView.contentOffset.x
        let centerItem = Int(round(currentOffset / itemWidth))
        let centerIndexPath = IndexPath(item: centerItem, section: 0)
        
        collectionView.indexPathsForVisibleItems.forEach { indexPath in
            let cell = collectionView.cellForItem(at: indexPath) as? GenericCollectionViewCell
            let isCenter = indexPath == centerIndexPath
            cell?.setContent(isHidden: !isCenter, animated: true)
            
            if isCenter {
                UIAccessibility.post(notification: .layoutChanged, argument: cell)
                
                if let cellItemId = cell?.viewId {
                    eventHandler?(.collectionChange(item: cellItemId))
                }
            }
        }
    }
    
    public func setupUI(pageControlDotColor: UIColor = Constants.pageControlDotColor,
                        pageControlSelectedColor: UIColor = .black) {
        scrollingPageControl.pageIndicatorTintColor = pageControlDotColor
        scrollingPageControl.currentPageIndicatorTintColor = pageControlSelectedColor
        scrollingPageControl.backgroundStyle = .minimal
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension PhotoCardCarouselView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let realIndex = calculateRealIndex(from: indexPath.row)
        let viewModel = originalViewModels[realIndex]
        let cell: GenericCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if let eventHandler = eventHandler {
            let view = PhotoCardMlcBuidler()
                .makeView(from: viewModel, eventHandler: eventHandler)
            cell.configure(with: view)
            
            if let accessibilityDescridable = accessibilityDescridable,
               let accessibilityDescriptions = accessibilityDescridable.accessibilityDescriptions,
               realIndex < accessibilityDescriptions.count {
                let description = accessibilityDescriptions[realIndex]
                cell.isAccessibilityElement = true
                cell.accessibilityLabel = description
                cell.accessibilityTraits = .button
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        return totalItemCount
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}

// MARK: - Scroll Handling
extension PhotoCardCarouselView {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserScrolling = true
        isPageControlScrolling = false
        
        collectionView.indexPathsForVisibleItems.forEach { indexPath in
            let cell = collectionView.cellForItem(at: indexPath) as? GenericCollectionViewCell
            cell?.setContent(isHidden: false, animated: true)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isScrollingProgrammatically else { return }
        updateCurrentIndexFromScroll()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isUserScrolling = false
        updateCurrentIndexFromScroll()
        updateCellVisibility()
        
        if !isPageControlScrolling {
            handleInfiniteScrollBoundary()
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isUserScrolling = false
            updateCurrentIndexFromScroll()
            updateCellVisibility()
            
            if !isPageControlScrolling {
                handleInfiniteScrollBoundary()
            }
        }
    }
    
    private func updateCurrentIndexFromScroll() {
        let itemWidth = cellSize.width + Constants.interItemInset
        let currentOffset = collectionView.contentOffset.x
        let currentItem = Int(round(currentOffset / itemWidth))
        
        guard currentItem >= 0 && currentItem < totalItemCount else { return }
        
        let newRealIndex = calculateRealIndex(from: currentItem)
        currentRealIndex = newRealIndex
    }
    
    private func handleInfiniteScrollBoundary() {
        guard realItemCount > 1 else { return }
        
        let itemWidth = cellSize.width + Constants.interItemInset
        let currentOffset = collectionView.contentOffset.x
        let currentItem = Int(round(currentOffset / itemWidth))
        
        let totalItems = totalItemCount
        let bufferZone = realItemCount
        
        if currentItem < bufferZone {
            let newItem = currentItem + (Constants.bufferMultiplier - 2) * realItemCount
            if newItem < totalItems {
                let newOffset = CGFloat(newItem) * itemWidth
                collectionView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
            }
        }
        else if currentItem >= totalItems - bufferZone {
            let newItem = currentItem - (Constants.bufferMultiplier - 2) * realItemCount
            if newItem >= 0 {
                let newOffset = CGFloat(newItem) * itemWidth
                collectionView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
            }
        }
    }
}

// MARK: - DSInputComponentProtocol
extension PhotoCardCarouselView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        let selectedCount = originalViewModels.filter({
            $0.tableItemCheckboxViewModel?.mandatory == false ||
            $0.tableItemCheckboxViewModel?.isSelected.value == true }).count
        
        if selectedCount >= sourceModel?.maxSelected ?? originalViewModels.count {
            originalViewModels
                .filter({$0.tableItemCheckboxViewModel?.isSelected.value == false})
                .forEach({$0.isEnable.value = false})
        } else {
            originalViewModels
                .forEach({$0.isEnable.value = true})
        }
        
        return selectedCount >= sourceModel?.minSelected ?? 0 &&
        selectedCount <= sourceModel?.maxSelected ?? originalViewModels.count
    }
    
    public func inputCode() -> String {
        return Constants.photoCardCarouselOrg
    }
    
    public func inputData() -> AnyCodable? {
        return AnyCodable.array(
            originalViewModels.compactMap({
                $0.tableItemCheckboxViewModel?.isSelected.value == false ? nil :
                AnyCodable.fromEncodable(encodable: $0.componentId)
            })
        )
    }
}

extension PhotoCardCarouselView {
    public enum Constants {
        public static let pageControlDotColor: UIColor = .black.withAlphaComponent(0.3)
        static let photoCardCarouselOrg = "photoCardCarouselOrg"
        static let dragVelocity: CGFloat = 2.5
        static let interItemInset: CGFloat = 8
        static let defaultCellHeight: CGFloat = 200
        static let sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        static let pageControlSize = CGSize(width: 100, height: 20)
        static let stackSpacing: CGFloat = 12
        static let bufferMultiplier = 3
    }
}
