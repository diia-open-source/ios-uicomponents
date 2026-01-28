
import UIKit
import Lottie
import DiiaCommonTypes

public final class CardImageMlcView: BaseCodeView {
    
    private let titleLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(16),
                                                      textColor: .black,
                                                      textAlignment: .center)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(12),
                                                            textColor: .black540,
                                                            textAlignment: .center)
    private let imageView = DSIconUrlAtmView()
    private let animationView = LottieAnimationView()
    
    private let attentionIconView = DSAttentionIconMessageView()
    
    private let mainStack = UIStackView.create(spacing: Constants.cornerRadius)
    
    public override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.layer.masksToBounds = true
        
        animationView.contentMode = .scaleAspectFit
        animationView.layer.cornerRadius = Constants.imageCornerRadius
        animationView.layer.masksToBounds = true
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: .allSides(Constants.padding))
        mainStack.addArrangedSubviews([titleLabel, descriptionLabel, imageView, animationView, attentionIconView])
        
        imageView.heightAnchor.constraint(
            equalTo: attentionIconView.widthAnchor,
            multiplier: 1/Constants.imageRatio).isActive = true
        
        animationView.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        setupAccessibility()
    }
    
    public func configure(with model: CardImageMlc) {
        accessibilityIdentifier = model.componentId
        
        titleLabel.isHidden = model.label == nil
        titleLabel.text = model.label
        titleLabel.accessibilityLabel = model.label
        
        descriptionLabel.isHidden = model.description == nil
        descriptionLabel.text = model.description
        descriptionLabel.accessibilityLabel = model.description
        
        imageView.isHidden = model.image == nil
        if let imageURL = model.image {
            imageView.configure(with: DSIconUrlAtmModel(
                componentId: nil,
                url: imageURL,
                accessibilityDescription: model.accessibilityDescription,
                action: model.action))
        }
        animationView.isHidden = model.gif == nil
        animationView.accessibilityLabel = model.gifAccessibilityDescription
        if let gifName = model.gif {
            animationView.animation = LottieAnimation.named(gifName, animationCache: nil)
            animationView.play()
        }
        attentionIconView.isHidden = model.attentionIconMessageMlc == nil
        if let attentionIconMessageMlc = model.attentionIconMessageMlc {
            attentionIconView.configure(with: attentionIconMessageMlc)
        }
    }
    
    // MARK: - Private methods
    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = [.staticText, .header]
        
        descriptionLabel.isAccessibilityElement = true
        descriptionLabel.accessibilityTraits = .staticText
        
        animationView.isAccessibilityElement = true
        animationView.accessibilityTraits = .image
    }
}

private extension CardImageMlcView {
    enum Constants {
        static let imageCornerRadius: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let padding: CGFloat = 16
        static let imageRatio: CGFloat = 1.6
        
    }
}
