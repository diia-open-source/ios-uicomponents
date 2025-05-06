
import UIKit

public class LoadingContainerView: BaseCodeView, AnimatedViewProtocol {
    private let imageView = UIImageView()
    private var size: CGSize = Constants.imageSize
    private var loadingImage: UIImage? = Constants.defaultImage
    private var imageConstraints: AnchoredConstraints?
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: size.width)
        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: size.height)
        
        widthConstraint.isActive = true
        heightConstraint.isActive = true
        
        imageConstraints = AnchoredConstraints(width: widthConstraint, height: heightConstraint)
    }
    
    public func configure(size: CGSize? = nil, loadingImage: UIImage?) {
        if let size {
            setupIconSize(with: size)
        }
        
        self.loadingImage = loadingImage
        imageView.image = self.loadingImage
    }
     
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow != nil {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
    
    public func startAnimation() {
        imageView.startRotating()
    }
    
    public func stopAnimation() {
        imageView.stopRotation()
    }
    
    private func setupIconSize(with size: CGSize) {
        self.size = size
        
        imageConstraints?.width?.constant = size.width
        imageConstraints?.height?.constant = size.height
        
        layoutIfNeeded()
    }
}

extension LoadingContainerView {
    enum Constants {
        static let imageSize = CGSize(width: 24, height: 24)
        static let defaultImage = R.image.loading.image
    }
}
