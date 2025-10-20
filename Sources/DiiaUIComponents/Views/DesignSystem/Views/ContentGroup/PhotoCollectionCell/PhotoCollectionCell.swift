
import UIKit
import DiiaCommonTypes

public class PhotoCollectionCell: BaseCollectionNibCell, NibLoadable {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var loadingTitle: UILabel!
    @IBOutlet weak private var loadingIndicator: UIProgressView!
    
    public static let nib = UINib(nibName: reuseID, bundle: Bundle.module)
    
    public func configure(with imageURL: String, accessibilityDescription: String? = nil, showLoading: Bool = false) {
        setupStaticViews()
        setupAccessibility()
        
        let completion = showImageLoading(isActive: showLoading)
        imageView.loadImage(imageURL: imageURL, completion: completion)
        
        imageView.accessibilityLabel = accessibilityDescription
    }
}

private extension PhotoCollectionCell {
    enum Constants {
        static let progressAnimationDuration: TimeInterval = 1.5
        static let cornerRadius: CGFloat = 8
    }
    
    func setupStaticViews() {
        loadingTitle.isHidden = true
        loadingTitle.font = FontBook.usualFont
        loadingTitle.text = R.Strings.general_loading.localized()
        imageView.layer.cornerRadius = Constants.cornerRadius
    }
    
    func showImageLoading(isActive: Bool) -> Callback {
        var completion: Callback = {}
        
        if isActive {
            setLoadingUI(isActive: true)
            
            completion = { [weak self] in
                DispatchQueue.main.async {
                    self?.setLoadingUI(isActive: false)
                }
            }
        }
        
        return completion
    }
    
    func setLoadingUI(isActive: Bool) {
        backgroundColor = isActive ? UIColor.init(AppConstants.Colors.imagePlaceholder) : .clear
        loadingTitle.isHidden = !isActive
        setLoadingIndicator(isActive: isActive)
    }
    
    func setLoadingIndicator(isActive: Bool) {
        loadingIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }
        loadingIndicator.setProgress(0.0, animated: false)
        loadingIndicator.isHidden = !isActive
        
        if !isActive { return }
        
        loadingIndicator.layoutIfNeeded()
        loadingIndicator.setProgress(1.0, animated: false)
        UIView.animate(withDuration: Constants.progressAnimationDuration, delay: 0, options: [.repeat], animations: { [unowned self] in
            self.loadingIndicator.layoutIfNeeded()
        })
    }
    
    func setupAccessibility() {
        loadingIndicator.isAccessibilityElement = false
        
        loadingTitle.isAccessibilityElement = true
        loadingTitle.accessibilityTraits = .staticText
        loadingTitle.accessibilityLabel = R.Strings.general_loading.localized()
        
        imageView.isAccessibilityElement = true
        imageView.accessibilityTraits = .image
    }
}
