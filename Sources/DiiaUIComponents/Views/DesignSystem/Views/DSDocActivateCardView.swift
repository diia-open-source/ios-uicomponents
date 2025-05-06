
import UIKit
import Lottie
import DiiaCommonTypes

public struct DSDocActivateCardViewModel {
    public let image: String
    public let title: String
    public let description: String
    public let btnStrokeDefaultAtm: DSButtonModel
    public let btnPlainAtm: DSButtonModel?
    public let eventHandler: (ConstructorItemEvent) -> Void
    
    public init(
        image: String,
        title: String,
        description: String,
        btnStrokeDefaultAtm: DSButtonModel,
        btnPlainAtm: DSButtonModel?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) {
        self.image = image
        self.title = title
        self.description = description
        self.btnStrokeDefaultAtm = btnStrokeDefaultAtm
        self.btnPlainAtm = btnPlainAtm
        self.eventHandler = eventHandler
    }
}

/// design_system_code: docActivateCardOrg
public class DSDocActivateCardView: BaseCodeView {
    
    // MARK: - Subviews
    private let imageView = UIImageView()
    private let titleLabel = UILabel().withParameters(font: FontBook.emptyStateTitleFont, numberOfLines: Constants.titleNumberOfLines, textAlignment: .center)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont, numberOfLines: Constants.descriptionNumberOfLines, textAlignment: .center)
    private let defaultButton = ActionLoadingStateButton()
    private let plainButton = DSLoadingButton()
    
    private lazy var imagePlaceholder: LottieAnimationView = {
        let animation = LottieAnimation.named(Constants.animationName)
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()

    // MARK: - Properties
    private var viewModel: DSDocActivateCardViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        setupUI()
        
        let containerView = UIView()
        let buttonsStack = UIStackView.create(views: [defaultButton, plainButton], alignment: .center)
        addSubview(containerView)
        containerView.addSubviews([imageView, titleLabel, descriptionLabel, buttonsStack])
        imageView.addSubview(imagePlaceholder)

        containerView.fillSuperview(padding: Constants.containerViewInsets)
        imageView.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor)
        imageView.heightAnchor.constraint(
            equalTo: heightAnchor,
            multiplier: Constants.imageSizeMultiplier).isActive = true
        titleLabel.anchor(
            top: imageView.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: Constants.titleInsets)
        descriptionLabel.anchor(
            top: titleLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            trailing: containerView.trailingAnchor,
            padding: Constants.descriptionInsets)
        descriptionLabel.bottomAnchor.constraint(
            lessThanOrEqualTo: buttonsStack.topAnchor,
            constant: Constants.descriptionBottomInset).isActive = true
        buttonsStack.anchor(
            leading: containerView.leadingAnchor,
            bottom: containerView.bottomAnchor,
            trailing: containerView.trailingAnchor)
        
        imagePlaceholder.withSize(Constants.placeholderSize)
        imagePlaceholder.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        imagePlaceholder.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSDocActivateCardViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        
        imagePlaceholder.play()
        imageView.loadImage(imageURL: viewModel.image, completion: { [weak self] in
            self?.imagePlaceholder.stop()
            self?.imagePlaceholder.isHidden = true
        })
        
        defaultButton.setLoadingState(.enabled, withTitle: viewModel.btnStrokeDefaultAtm.label)
        defaultButton.onClick = {
            guard let action = viewModel.btnStrokeDefaultAtm.action else { return }
            viewModel.eventHandler(.action(action))
        }
        
        plainButton.isHidden = viewModel.btnPlainAtm == nil
        if let btnPlainAtm = viewModel.btnPlainAtm {
            let plainBtnViewModel = DSLoadingButtonViewModel(title: btnPlainAtm.label, state: .enabled)
            plainBtnViewModel.callback = { [weak plainBtnViewModel] in
                guard let plainBtnViewModel = plainBtnViewModel, let action = btnPlainAtm.action else { return }
                viewModel.eventHandler(.buttonAction(parameters: action, viewModel: plainBtnViewModel))
            }
            plainButton.configure(viewModel: plainBtnViewModel)
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = Constants.backgroundCornerRadius
        layer.masksToBounds = true
        
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.layer.masksToBounds = true
        
        defaultButton.setStyle(style: .light)
        defaultButton.titleLabel?.font = FontBook.bigText
        defaultButton.contentEdgeInsets = Constants.defaultButtonInsets
        defaultButton.withHeight(Constants.defaultButtonHeight)

        plainButton.setStyle(style: .plain)
        plainButton.titleLabel?.font = FontBook.bigText
        plainButton.titleEdgeInsets = Constants.plainButtonInsets
        plainButton.withHeight(Constants.plainButtonHeight)
    }
}

// MARK: - Constants
private extension DSDocActivateCardView {
    enum Constants {
        static let backgroundCornerRadius: CGFloat = 24
        static let imageCornerRadius: CGFloat = 16
        static let defaultButtonHeight: CGFloat = 48
        static let plainButtonHeight: CGFloat = 56
        
        static let titleNumberOfLines = 2
        static let descriptionNumberOfLines = 4
        
        static let containerViewInsets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let titleInsets: UIEdgeInsets = .init(top: 16, left: .zero, bottom: .zero, right: .zero)
        static let descriptionInsets: UIEdgeInsets = .init(top: 16, left: .zero, bottom: .zero, right: .zero)
        static let defaultButtonInsets: UIEdgeInsets = .init(top: .zero, left: 60, bottom: .zero, right: 60)
        static let plainButtonInsets: UIEdgeInsets = .init(top: 24, left: 40, bottom: 16, right: 40)
        
        static let descriptionBottomInset: CGFloat = -16
        static let imageSizeMultiplier: CGFloat = 0.33
        static let placeholderSize = CGSize(width: 60, height: 60)
        
        static let animationName = "placeholder_black"
    }
}
