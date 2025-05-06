
import UIKit
import Lottie
import DiiaCommonTypes

public class DSHalvedCardViewModel {
    public let id: String
    public let imageURL: String
    public let label: String
    public let title: String
    public var clickAction: Callback?
    
    public init(id: String,
         imageURL: String,
         label: String,
         title: String,
         clickAction: (Callback)? = nil) {
        self.id = id
        self.imageURL = imageURL
        self.label = label
        self.title = title
        self.clickAction = clickAction
    }
}

/// design_system_code: halvedCardMlc
final public class DSHalvedCardCell: UICollectionViewCell, Reusable {
    private let imageView = UIImageView()
    private let detailsLabel = UILabel().withParameters(
        font: FontBook.statusFont,
        textColor: .statusGray)
    private let titleLabel = UILabel().withParameters(
        font: FontBook.bigText,
        numberOfLines: Constants.titleNumberOfLines,
        lineBreakMode: .byTruncatingTail)
    
    private lazy var imagePlaceholder: LottieAnimationView = {
        let animation = LottieAnimation.named(Constants.animationName)
        let lottieView = LottieAnimationView(animation: animation)
        lottieView.loopMode = .loop
        lottieView.backgroundBehavior = .pauseAndRestore
        return lottieView
    }()
    
    // MARK: - Properties
    private var viewModel: DSHalvedCardViewModel?
    
    // MARK: - Lifecycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSHalvedCardViewModel) {
        self.viewModel = viewModel
        detailsLabel.text = viewModel.label
        titleLabel.text = viewModel.title
        imageView.loadImage(imageURL: viewModel.imageURL, completion: { [weak self] in
            self?.imagePlaceholder.stop()
            self?.imagePlaceholder.isHidden = true
        })
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        detailsLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        let infoStackView = UIStackView.create(
            views: [detailsLabel, titleLabel],
            spacing: Constants.itemSpacing)
        let infoBox = BoxView(subview: infoStackView).withConstraints(insets: Constants.infoStackPadding)
        contentView.stack([imageView, infoBox], spacing: Constants.itemSpacing)
        
        imageView.addSubview(imagePlaceholder)
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: Constants.imageHeightMultiplier).isActive = true
        imagePlaceholder.withSize(Constants.placeholderSize)
        imagePlaceholder.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        imagePlaceholder.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        setupUI()
        setupAccessibility()
        addTapGestureRecognizer()
        imagePlaceholder.play()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true
        
        imageView.backgroundColor = Constants.imageBackgroundColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = false
        detailsLabel.isAccessibilityElement = false
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        viewModel?.clickAction?()
    }
}

// MARK: - Constants
extension DSHalvedCardCell {
    private enum Constants {
        static let imageHeightMultiplier: CGFloat = 0.58
        static let infoStackPadding = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        static let titleNumberOfLines = 2
        static let cornerRadius: CGFloat = 16
        static let itemSpacing: CGFloat = 8
        static let imageBackgroundColor = UIColor("#FAFAFA")
        static let placeholderSize = CGSize(width: 60, height: 60)
        static let animationName = "placeholder_black"
    }
}
