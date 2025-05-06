
import UIKit
import Lottie
import DiiaCommonTypes

// MARK: - View Model
public class DSVerticalCardViewModel {
    public let title: String
    public let badgeCount: String
    public let imageUrl: String?
    public let touchAction: Callback?
    
    public init(model: DSVerticalCardCarouselItemModel,
         touchAction: Callback? = nil) {
        self.title = model.title
        self.imageUrl = model.image
        self.touchAction = touchAction
        self.badgeCount = (model.badgeCounterAtm.count > 99)
            ? "99+"
            : String(describing: model.badgeCounterAtm.count)
    }
}

/// design_system_code: verticalCardMlc
final public class DSVerticalCardCell: UICollectionViewCell, Reusable {
    private let backgroundImageView = UIImageView()
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont, textColor: .black)
    private let countView = DSBadgeCounterView()
    
    private lazy var imagePlaceholder: LottieAnimationView = {
        let animation = LottieAnimation.named(Constants.animationName)
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    // MARK: - Properties
    private var viewModel: DSVerticalCardViewModel?
    
    // MARK: - Lifecycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSVerticalCardViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        countView.set(count: viewModel.badgeCount)
        backgroundImageView.loadImage(imageURL: viewModel.imageUrl, completion: { [weak self] in
            self?.imagePlaceholder.stop()
            self?.imagePlaceholder.isHidden = true
        })
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        contentView.addSubview(backgroundImageView)
        backgroundImageView.fillSuperview()
        
        backgroundImageView.addSubview(imagePlaceholder)
        imagePlaceholder.withSize(Constants.placeholderSize)
        imagePlaceholder.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true
        imagePlaceholder.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor).isActive = true
        
        backgroundImageView.hstack(
            titleLabel, countView,
            spacing: Constants.spacing,
            alignment: .top,
            padding: Constants.contentInsets)
        
        setupUI()
        addTapGestureRecognizer()
        imagePlaceholder.play()
    }
    
    private func setupUI() {
        contentView.backgroundColor = Constants.backgroundColor
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        viewModel?.touchAction?()
    }
}

private extension DSVerticalCardCell {
    enum Constants {
        static let backgroundColor: UIColor = .white.withAlphaComponent(0.4)
        static let cornerRadius: CGFloat = 16
        static let spacing: CGFloat = 16
        static let contentInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        static let placeholderSize = CGSize(width: 60, height: 60)
        static let animationName = "placeholder_black"
    }
}
