
import UIKit
import Foundation
import Lottie

/// design_system_code: bankingCardMlc
public final class BankingCardView: BaseCodeView {
    
    private let titleLabel = UILabel().withParameters(font: FontBook.cardsHeadingFont)
    private let cardNumMaskLabel = UILabel().withParameters(font: FontBook.lightSmallHeadingFont,
                                                            textColor: .white)
    private let expirationDateLabel = UILabel().withParameters(font: FontBook.bigText,
                                                               textColor: Constants.textColor)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.bigText)
    private let logosIconViews = [DSIconView]()
    private let paymentIconView = DSIconView().withSize(Constants.largeIconSize)
    
    private let imageBackground = UIImageView()
    private lazy var backgroundAnimationView: LottieAnimationView = {
        let animation = LottieAnimation.named(Constants.animationName)
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.contentMode = .scaleAspectFill
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    private var logosStack: UIStackView?
    private var cardInfoStack: UIStackView?
    
    private var viewModel: BankingCardViewModel?
    
    override public func setupSubviews() {
        backgroundColor = .white
        
        layer.cornerRadius = Constants.cornerRadius
        
        backgroundAnimationView.layer.cornerRadius = Constants.cornerRadius
        imageBackground.layer.cornerRadius = Constants.cornerRadius
        
        backgroundAnimationView.isHidden = true
        imageBackground.isHidden = true
        
        let logosStack = UIStackView.create(
            .horizontal,
            views: logosIconViews,
            spacing: Constants.smallPadding)
        self.logosStack = logosStack
        
        let cardInfoStack = UIStackView.create(
            views: [cardNumMaskLabel, expirationDateLabel],
            spacing: Constants.smallPadding)
        self.cardInfoStack = cardInfoStack
        addSubviews([imageBackground,
                     backgroundAnimationView,
                     logosStack,
                     titleLabel,
                     paymentIconView,
                     cardInfoStack,
                     descriptionLabel])
        
        imageBackground.fillSuperview()
        backgroundAnimationView.fillSuperview()
        
        titleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            padding: .allSides(Constants.defaultPadding))
        paymentIconView.anchor(
            top: topAnchor,
            leading: titleLabel.trailingAnchor,
            trailing: trailingAnchor,
            padding: .init(
                top: Constants.defaultPadding,
                left: Constants.mediumPadding,
                bottom: .zero,
                right: Constants.defaultPadding))
        logosStack.anchor(
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .allSides(Constants.defaultPadding))
        cardInfoStack.anchor(
            top: titleLabel.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: .init(
                top: Constants.mediumPadding,
                left: Constants.defaultPadding,
                bottom: .zero,
                right: Constants.defaultPadding))
        descriptionLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: .allSides(Constants.defaultPadding))
        
        logosStack.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor,
                                                 constant: Constants.smallPadding).isActive = true
        
        withHeight(Constants.viewHeight)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapAction))
        addGestureRecognizer(tapRecognizer)
    }
    
    public func configure(with model: BankingCardViewModel) {
        self.viewModel = model
        
        titleLabel.text = model.title
        cardNumMaskLabel.text = model.cardNumMask
        expirationDateLabel.text = model.expirationDate
        descriptionLabel.text = model.description
        if let image = model.image {
            imageBackground.loadImage(imageURL: image,
                                      placeholder: UIImage.from(color: .lightGray))
            backgroundAnimationView.isHidden = true
            imageBackground.isHidden = false
        }
        if model.gradient != nil {
            backgroundAnimationView.isHidden = false
            imageBackground.isHidden = true
            backgroundAnimationView.play()
        }
        if let paymentSystemLogo = model.paymentSystemLogo {
            paymentIconView.setIcon(paymentSystemLogo)
        }
        if !model.logos.isEmpty {
            for logo in model.logos {
                let logoImage = DSIconView().withSize(Constants.mediumIconSize)
                logoImage.setIcon(logo.code)
                logosStack?.addArrangedSubview(logoImage)
            }
            logosStack?.addArrangedSubview(UIView())
        }
        setupForType(model.type)
    }
    
    private func setupForType(_ type: BankingCardType) {
        descriptionLabel.isHidden = type != .empty
        cardInfoStack?.isHidden = type == .empty
        paymentIconView.isHidden = type == .empty
        
        titleLabel.textColor = type == .empty ? .black : .white
        descriptionLabel.textColor = type == .empty ? .black : .white
        
    }
    
    @objc
    private func viewTapAction() {
        viewModel?.action()
    }
}

private extension BankingCardView {
    enum Constants {
        static let viewHeight: CGFloat = 208
        static let cornerRadius: CGFloat = 16
        static let largeIconSize = CGSize(width: 68, height: 28)
        static let mediumIconSize = CGSize(width: 48, height: 48)
        static let viewMultiplier: CGFloat = 0.63
        static let smallPadding: CGFloat = 8
        static let mediumPadding: CGFloat = 16
        static let defaultPadding: CGFloat = 24
        static let textColor = UIColor.white.withAlphaComponent(0.6)
        static let animationName = "bankcard"
    }
}
