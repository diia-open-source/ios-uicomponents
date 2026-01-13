
import UIKit
import DiiaCommonTypes

/// design_system_code: btnIconRoundedMlc
public final class DSButtonIconRoundedItemView: BaseCodeView {
    private let imageView: UIImageView = UIImageView().withSize(Constants.imageSize)
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    
    private var touchAction: Callback?
    
    override public func setupSubviews() {
        let imageContainer = UIView().withSize(Constants.imageContainerSize)
        imageContainer.backgroundColor = .black
        imageContainer.layer.cornerRadius = Constants.cornerRadius
        imageContainer.addSubview(imageView)
        imageView.fillSuperview(padding: Constants.imagePadding)
        
        stack([imageContainer, titleLabel],
              spacing: Constants.spacing,
              alignment: .center,
              padding: Constants.contentPadding)
        
        setupUI()
        setupAccessibility()
        addTapGestureRecognizer()
    }
    
    // MARK: - Public Methods
    public func configure(with model: DSButtonIconRoundedItemModel, touchAction: Callback?) {
        imageView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: model.icon)
        titleLabel.text = model.label
        accessibilityLabel = model.label
        self.touchAction = touchAction
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        titleLabel.textAlignment = .center
        imageView.contentMode = .scaleAspectFill
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = .button
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        touchAction?()
    }
}
    
// MARK: - Constants
extension DSButtonIconRoundedItemView {
    private enum Constants {
        static let cornerRadius: CGFloat = 16
        static let spacing: CGFloat = 8
        static let contentPadding = UIEdgeInsets(top: 24, left: 20, bottom: 16, right: 20)
        static let imageContainerSize = CGSize(width: 56, height: 56)
        
        static let imageSize = CGSize(width: 28, height: 28)
        static let imagePadding = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
    }
}
