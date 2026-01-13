
import UIKit
import Foundation
import DiiaCommonTypes

public final class VideoCollectionCell: UICollectionViewCell, Reusable {
    
    private var imageView = UIImageView()
    private var playImage = UIImageView()
    private var loadingTitle = UILabel()
    private var loadingIndicator = UIProgressView()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    public func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        let viewArray = [imageView, loadingTitle, loadingIndicator, playImage]
        addSubviews(viewArray)
        viewArray.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        imageView.fillSuperview()
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        loadingIndicator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        loadingIndicator.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        loadingIndicator.heightAnchor.constraint(equalToConstant: Constants.loadingHeight).isActive = true
        loadingTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loadingTitle.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor).isActive = true
        loadingTitle.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor).isActive = true
        playImage.withSize(Constants.playSize)
        playImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playImage.image = UIImage(named: Constants.playImageName)
        playImage.isUserInteractionEnabled = false
    }
    
    public func configure(with imageURL: String, accessibilityDescription: String? = nil, showLoading: Bool = false) {
        setupStaticViews()
        setupAccessibility()
        
        let completion = showImageLoading(isActive: showLoading)
        imageView.loadImage(imageURL: imageURL, completion: completion)
        imageView.contentMode = .scaleAspectFill
        
        imageView.accessibilityLabel = accessibilityDescription
    }
}

private extension VideoCollectionCell {
    
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
                onMainQueue {
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
        imageView.accessibilityValue = R.Strings.pdr_penalty_accessibility_video.localized()
        imageView.accessibilityTraits = .button
    }
}

private extension VideoCollectionCell {
    enum Constants {
        static let progressAnimationDuration: TimeInterval = 1.5
        static let cornerRadius: CGFloat = 8
        static let loadingHeight: CGFloat = 4
        static let playSize = CGSize(width: 44, height: 44)
        static let playImageName = "playVideo"
    }
}
