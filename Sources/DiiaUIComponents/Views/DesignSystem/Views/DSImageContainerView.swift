
import UIKit
import Lottie

/// design_system_code: articlePicAtm
public final class DSImageContainerView: BaseCodeView {
    private lazy var imagePlaceholder: LottieAnimationView = {
        let animation = LottieAnimation.named(Constants.animationName)
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    private let imageView = UIImageView()
    private var imageHeightConstraints: NSLayoutConstraint?

    override public func setupSubviews() {
        backgroundColor = Constants.placeholderColor
        addSubview(imageView)
        imageView.fillSuperview()
        
        imageView.addSubview(imagePlaceholder)
        imagePlaceholder.withSize(Constants.placeholderSize)
        imageHeightConstraints = self.imageView.heightAnchor.constraint(equalTo: self.widthAnchor,
                                                                        multiplier: 9/16)
        imageHeightConstraints?.isActive = true
        imagePlaceholder.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        imagePlaceholder.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        imageView.contentMode = .scaleAspectFill
        translatesAutoresizingMaskIntoConstraints = false

        imagePlaceholder.play()
    }
    
    // MARK: - Setup
    public func configure(url: String) {
        imageView.loadImage(imageURL: url, completion: { [weak self] in
            guard let self = self, let image = self.imageView.image else { return }
            self.updateImage(image)
        })
    }
    
    public func configure(data: DSImageData) {
        if let image = UIImage.createWithBase64String(data.image) {
            updateImage(image)
        } else {
            configure(url: data.image)
        }
        
        setupAccessibility(accessibilityDescription: data.accessibilityDescription)
    }

    private func updateImage(_ image: UIImage) {
        self.imagePlaceholder.stop()
        self.imagePlaceholder.isHidden = true
        self.imageView.image = image
        
        self.imageHeightConstraints?.isActive = false
        self.imageHeightConstraints = self.imageView.heightAnchor.constraint(
            equalTo: imageView.widthAnchor,
            multiplier: image.size.height / image.size.width
        )
        self.imageHeightConstraints?.isActive = true
        
        self.layoutIfNeeded()
    }
    
    private func setupAccessibility(accessibilityDescription: String?) {
        if let accessibilityDescription {
            isAccessibilityElement = true
            accessibilityTraits = .image
            accessibilityLabel = accessibilityDescription
        } else {
            isAccessibilityElement = false
        }
    }
}

private extension DSImageContainerView {
    enum Constants {
        static let placeholderSize = CGSize(width: 60, height: 60)
        static let animationName = "placeholder_white"
        static let placeholderColor = UIColor(hex: 0x0B4174).withAlphaComponent(0.1)
    }
}
