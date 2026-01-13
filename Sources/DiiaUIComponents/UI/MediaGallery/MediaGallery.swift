
import UIKit

public protocol MediaGalleryDataSource: NSObjectProtocol {
    func numberOfImagesInGallery(gallery: MediaGallery) -> Int
    func mediaInGallery(gallery: MediaGallery, forIndex: Int) -> GalleryContentType?
}

public protocol MediaGalleryDelegate: NSObjectProtocol {
    func galleryDidTapToClose(gallery: MediaGallery)
}

// swiftlint:disable all
// MARK: - SwiftPhotoGallery
public final class MediaGallery: UIViewController, Rotatable {

    fileprivate var animateImageTransition = false

    public weak var dataSource: MediaGalleryDataSource?
    public weak var delegate: MediaGalleryDelegate?

    public lazy var imageCollectionView: UICollectionView = self.setupCollectionView()

    public var numberOfImages: Int {
        return collectionView(imageCollectionView, numberOfItemsInSection: 0)
    }

    public var backgroundColor: UIColor {
        get {
            return view.backgroundColor ?? .clear
        }
        set(newBackgroundColor) {
            view.backgroundColor = newBackgroundColor
        }
    }

    public var currentPageIndicatorTintColor: UIColor {
        get {
            return pageControl.currentPageIndicatorTintColor ?? .black
        }
        set(newCurrentPageIndicatorTintColor) {
            pageControl.currentPageIndicatorTintColor = newCurrentPageIndicatorTintColor
        }
    }

    public var pageIndicatorTintColor: UIColor {
        get {
            return pageControl.pageIndicatorTintColor ?? .clear
        }
        set(newPageIndicatorTintColor) {
            pageControl.pageIndicatorTintColor = newPageIndicatorTintColor
        }
    }

    public var startPage: Int = 0
    
    public var currentPage: Int = 0 {
        didSet {
            if currentPage < numberOfImages {
                scrollToImage(withIndex: currentPage, animated: false)
            } else {
                scrollToImage(withIndex: numberOfImages - 1, animated: false)
            }
            updatePageControl()
        }
    }

    public var hidePageControl: Bool = false {
        didSet {
            pageControl.isHidden = hidePageControl
        }
    }

    public var hideStatusBar: Bool = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    public var isSwipeToDismissEnabled: Bool = true
    private var flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    fileprivate var pageControl: UIPageControl = UIPageControl()
    private var pageControlBottomConstraint: NSLayoutConstraint?
    private var pageControlCenterXConstraint: NSLayoutConstraint?
    private var needsLayout = false
    
    private var isVoiceOverRunning: Bool {
        return UIAccessibility.isVoiceOverRunning
    }

    // MARK: Public Interface
    public init(delegate: MediaGalleryDelegate, dataSource: MediaGalleryDataSource) {
        super.init(nibName: nil, bundle: nil)

        self.dataSource = dataSource
        self.delegate = delegate
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func reload(imageIndexes: Int...) {
        if imageIndexes.isEmpty {
            imageCollectionView.reloadData()
        } else {
            let indexPaths: [IndexPath] = imageIndexes.map({IndexPath(item: $0, section: 0)})
            imageCollectionView.reloadItems(at: indexPaths)
        }
    }

    // MARK: Lifecycle methods
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        flowLayout.itemSize = view.bounds.size
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if needsLayout {
            let desiredIndexPath = IndexPath(item: currentPage, section: 0)

            if currentPage >= 0 {
                scrollToImage(withIndex: currentPage, animated: false)
            }

            switch dataSource?.mediaInGallery(gallery: self, forIndex: currentPage) {
            case .image: imageCollectionView.reloadItems(at: [desiredIndexPath])
            default: break
            }

            imageCollectionView.visibleCells.forEach { cell in
                if let cell = cell as? MediaGalleryCellProtocol {
                    cell.resumeAfterRotation()
                }
            }
            
            needsLayout = false
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black

        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = Constants.pageIndicatorTintColor
        setupPageControl()
        setupGestureRecognizers()
        if startPage != 0 {
            currentPage = startPage
            imageCollectionView.isHidden = true
        }
        pageControl.isHidden = dataSource?.numberOfImagesInGallery(gallery: self) ?? 0 < Constants.pageIndicatorMinCount
    }

    public override func viewDidAppear(_ animated: Bool) {
        if currentPage < 0 {
            currentPage = 0
        }
        if startPage != 0 {
            currentPage = startPage
            imageCollectionView.isHidden = false
        }
    }

    public override var prefersStatusBarHidden: Bool {
        get {
            return hideStatusBar
        }
    }

    // MARK: Rotation Handling
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        needsLayout = true

        imageCollectionView.visibleCells.forEach { cell in
            if let cell = cell as? MediaGalleryCellProtocol {
                cell.prepareForRotation()
            }
        }
        super.viewWillTransition(to: size, with: coordinator)
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    public override var shouldAutorotate: Bool {
        return true
    }

    // MARK: - Internal Methods
    func updatePageControl() {
        pageControl.currentPage = currentPage
    }
    
    // MARK: Gesture Handlers
    private func setupGestureRecognizers() {
            let panGesture = PanDirectionGestureRecognizer(direction: PanDirection.vertical, target: self, action: #selector(wasDragged(_:)))
            imageCollectionView.addGestureRecognizer(panGesture)
            imageCollectionView.isUserInteractionEnabled = true
    }

    @objc private func wasDragged(_ gesture: PanDirectionGestureRecognizer) {

        guard let image = gesture.view, isSwipeToDismissEnabled else { return }

        let translation = gesture.translation(in: self.view)
        image.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY + translation.y)

        let yFromCenter = image.center.y - self.view.bounds.midY

        let alpha = 1 - abs(yFromCenter / self.view.bounds.midY)
        self.view.backgroundColor = backgroundColor.withAlphaComponent(alpha)

        if gesture.state == UIGestureRecognizer.State.ended {

            var swipeDistance: CGFloat = 0
            let swipeBuffer: CGFloat = Constants.swipeBuffer
            var animateImageAway = false

            if yFromCenter > -swipeBuffer && yFromCenter < swipeBuffer {
                // reset everything
                UIView.animate(withDuration: Constants.restingAnimationDuration, animations: {
                    self.view.backgroundColor = self.backgroundColor.withAlphaComponent(1.0)
                    image.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
                })
            } else if yFromCenter < -swipeBuffer {
                swipeDistance = 0
                animateImageAway = true
            } else {
                swipeDistance = self.view.bounds.height
                animateImageAway = true
            }

            if animateImageAway {
                if self.modalPresentationStyle == .custom {
                    self.delegate?.galleryDidTapToClose(gallery: self)
                    return
                }
                
                UIView.animate(
                    withDuration: Constants.draggingAnimationDuration,
                    animations: {
                        self.view.alpha = 0
                        image.center = CGPoint(x: self.view.bounds.midX, y: swipeDistance)
                    },
                    completion: { [weak self] _ in
                        guard let self = self else { return }
                        self.delegate?.galleryDidTapToClose(gallery: self)
                    }
                )
            }

        }
    }

    // MARK: Private Methods
    private func setupCollectionView() -> UICollectionView {
        // Set up flow layout
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        // Set up collection view
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(cellType: MediaGalleryPhotoCell.self)
        collectionView.register(cellType: MediaGalleryVideoCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true

        // Set up collection view constraints
        var imageCollectionViewConstraints: [NSLayoutConstraint] = []
        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .leading,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .leading,
                                                                 multiplier: 1,
                                                                 constant: 0))

        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .top,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .top,
                                                                 multiplier: 1,
                                                                 constant: 0))

        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .trailing,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .trailing,
                                                                 multiplier: 1,
                                                                 constant: 0))

        imageCollectionViewConstraints.append(NSLayoutConstraint(item: collectionView,
                                                                 attribute: .bottom,
                                                                 relatedBy: .equal,
                                                                 toItem: view,
                                                                 attribute: .bottom,
                                                                 multiplier: 1,
                                                                 constant: 0))

        view.addSubview(collectionView)
        view.addConstraints(imageCollectionViewConstraints)
        
        collectionView.contentSize = CGSize(width: Constants.collectionViewContentWidth, height: 1.0)

        return collectionView
    }
    
    private func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.isAccessibilityElement = true

        pageControl.numberOfPages = numberOfImages
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor

        pageControl.alpha = 1
        pageControl.isHidden = hidePageControl
        
        if isVoiceOverRunning {
            pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        }

        view.addSubview(pageControl)

        pageControlCenterXConstraint = NSLayoutConstraint(item: pageControl,
                                                          attribute: NSLayoutConstraint.Attribute.centerX,
                                                          relatedBy: NSLayoutConstraint.Relation.equal,
                                                          toItem: view,
                                                          attribute: NSLayoutConstraint.Attribute.centerX,
                                                          multiplier: 1.0,
                                                          constant: 0)

        pageControlBottomConstraint = NSLayoutConstraint(item: view as Any,
                                                         attribute: NSLayoutConstraint.Attribute.bottom,
                                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                                         toItem: pageControl,
                                                         attribute: NSLayoutConstraint.Attribute.bottom,
                                                         multiplier: 1.0,
                                                         constant: Constants.pageControlBottomPadding)

        view.addConstraints([pageControlCenterXConstraint!, pageControlBottomConstraint!])
    }

    private func scrollToImage(withIndex: Int, animated: Bool = false) {
        imageCollectionView.scrollToItem(at: IndexPath(item: withIndex, section: 0), at: .centeredHorizontally, animated: animated)
    }
    
    fileprivate func configureCell(for page: Int, cell: UICollectionViewCell) {
        guard let media = dataSource?.mediaInGallery(gallery: self, forIndex: page) else {
            return
        }
        switch media {
        case .image(let viewModel):
            if let cell = cell as? MediaGalleryPhotoCell {
                cell.setViewModel(viewModel: viewModel)
            }
        case .video(let viewModel):
            if let cell = cell as? MediaGalleryVideoCell {
                cell.setVideo(viewModel: viewModel)
            }
        }
    }
    
    @objc private func pageControlValueChanged(_ sender: UIPageControl) {
        currentPage = sender.currentPage
        scrollToImage(withIndex: currentPage)
    }
}

// MARK: UICollectionViewDataSource Methods
extension MediaGallery: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ imageCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfImagesInGallery(gallery: self) ?? 0
    }

    public func collectionView(_ imageCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let media = dataSource?.mediaInGallery(gallery: self, forIndex: indexPath.item) else {
            return UICollectionViewCell()
        }
        
        switch media {
        case .image:
            let cell: MediaGalleryPhotoCell = imageCollectionView.dequeueReusableCell(for: indexPath)
            configureCell(for: indexPath.item, cell: cell)
            return cell
        case .video:
            let cell: MediaGalleryVideoCell = imageCollectionView.dequeueReusableCell(for: indexPath)
            configureCell(for: indexPath.item, cell: cell)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegate Methods
extension MediaGallery: UICollectionViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animateImageTransition = true
        imageCollectionView.visibleCells.forEach { cell in
            if let cell = cell as? MediaGalleryCellProtocol {
                cell.prepareForRotation()
            }
        }
        self.pageControl.alpha = 1.0
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateImageTransition = false

        currentPage = Int(imageCollectionView.contentOffset.x / imageCollectionView.frame.size.width)
        updatePageControl()
        if let cell = imageCollectionView.cellForItem(at: IndexPath(item: currentPage, section: 0)) as? MediaGalleryVideoCell {
            cell.setNeedsToPlay()
        }
        
        if !isVoiceOverRunning {
            UIView.animate(
                withDuration: 1.0,
                delay: Constants.animationDelay,
                options: UIView.AnimationOptions.curveEaseInOut,
                animations: { () -> Void in
                    self.pageControl.alpha = 0.0
                },
                completion: nil)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MediaGalleryPhotoCell {
            cell.configureForNewImage()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if needsLayout { return }
        if let cell = cell as? MediaGalleryCellProtocol {
            cell.prepareForRotation()
        }
    }
}

// MARK: UIGestureRecognizerDelegate Methods
extension MediaGallery: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return otherGestureRecognizer is UITapGestureRecognizer &&
            gestureRecognizer is UITapGestureRecognizer &&
            otherGestureRecognizer.view is MediaGalleryPhotoCell &&
            gestureRecognizer.view == imageCollectionView
    }
}


extension MediaGallery {
    enum Constants {
        static let pageControlBottomPadding: CGFloat = 32
        static let animationDelay: TimeInterval = 2.0
        static let collectionViewContentWidth: CGFloat = 1000.0
        static let draggingAnimationDuration: TimeInterval = 0.35
        static let restingAnimationDuration: TimeInterval = 0.25
        static let swipeBuffer: CGFloat = 50
        static let pageIndicatorMinCount: Int = 2
        static let pageIndicatorTintColor: UIColor = UIColor(white: 0.75, alpha: 0.35) //Dim Gray
    }
}
