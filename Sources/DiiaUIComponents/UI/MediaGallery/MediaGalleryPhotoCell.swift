import UIKit
import DiiaCommonTypes

class MediaGalleryPhotoCell: UICollectionViewCell, Reusable {

    private var viewModel: GalleryImageViewModel?
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    var url: String? {
        didSet {
            setImage(url: url)
        }
    }

    open var scrollView: UIScrollView
    public let imageView: UIImageView
    private let actionStack = UIStackView()

    override init(frame: CGRect) {

        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView = UIScrollView(frame: frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)

        contentView.addSubview(scrollView)
        scrollView.fillSuperview()

        scrollView.addSubview(imageView)
        imageView.fillSuperview()

        contentView.addSubview(actionStack)
        actionStack.anchor(top: contentView.safeAreaLayoutGuide.topAnchor,
                           trailing: contentView.safeAreaLayoutGuide.trailingAnchor,
                           padding: .init(top: Constants.padding, left: .zero, bottom: .zero, right: Constants.padding))

        scrollView.delegate = self

        setupGestureRecognizer()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc public func doubleTapAction(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }

    @objc public func singleTapAction(recognizer: UITapGestureRecognizer) {
        actionStack.isHidden.toggle()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel = nil
        actionStack.isHidden = true
        imageView.kf.cancelDownloadTask()
        setImage(image: image, animated: false)
    }

    func setImage(image: UIImage?, animated: Bool) {
        self.image = image
        configureForNewImage(animated: animated)
    }

    func configureForNewImage(animated: Bool = true) {
        imageView.sizeToFit()

        setZoomScale()
        scrollViewDidZoom(scrollView)

        if animated {
            imageView.alpha = 0.0
            UIView.animate(withDuration: 0.5) {
                self.imageView.alpha = 1.0
            }
        }
    }

    func setImage(url: String?) {
        imageView.loadImage(imageURL: url, completion: { [weak self] in
            self?.configureForNewImage(animated: false)
        })
    }

    func setViewModel(viewModel: GalleryImageViewModel) {
        self.viewModel = viewModel
        if let imageLink = viewModel.imageLink,
           !imageLink.isEmpty {
            imageView.loadImage(imageURL: viewModel.imageLink, completion: { [weak self] in
                viewModel.image = self?.imageView.image
                self?.configureForNewImage(animated: false)
            })
        } else {
            imageView.image = viewModel.image
            configureForNewImage(animated: false)
        }

        updateActions(actions: viewModel.actions)
    }

    // MARK: Private Methods
    private func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapAction(recognizer:)))
        self.addGestureRecognizer(singleTap)

        singleTap.require(toFail: doubleTap)
    }

    private func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height

        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }

    private func updateActions(actions: [Action]) {
        actionStack.safelyRemoveArrangedSubviews()
        actions.forEach { action in
            let button = ActionButton(action: action, type: .icon)
            button.tintColor = .white
            button.withSize(Constants.buttonSize)
            actionStack.addArrangedSubview(button)
        }
    }
}

// MARK: UIScrollViewDelegate Methods
extension MediaGalleryPhotoCell: UIScrollViewDelegate {

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {

        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        if verticalPadding >= 0 {
            // Center the image on screen
            scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        } else {
            // Limit the image panning to the screen bounds
            scrollView.contentSize = imageViewSize
        }
    }
}

extension MediaGalleryPhotoCell: MediaGalleryCellProtocol {
    func prepareForRotation() {

    }

    func resumeAfterRotation() {
        configureForNewImage(animated: false)
    }
}

extension MediaGalleryPhotoCell {
    enum Constants {
        static let padding: CGFloat = 20
        static let buttonSize = CGSize(width: 36, height: 36)
    }
}
