
import UIKit

/// design_system_code: cardProgressMlc

final class CardProgressMlcView: BaseCodeView {
    
    private let statusBadge = DSChipStatusAtmView()
    private let rightSubtitle = UILabel().withParameters(
        font: FontBook.usualFont,
        textColor: .gray)
    private var topStackView = UIStackView()
    private let leftImageView = DSIconUrlAtmView().withSize(Constants.bigImageSize)
    private let rightImageView = BoxView(subview: UIImageView())
        .withConstraints(insets: Constants.imageInsets,
                         size: Constants.imageSize)
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText)
    private let descriptionLabel = UILabel().withParameters(
        font: FontBook.usualFont,
        textColor: .gray)
    private let progressView = ProgressBarView()

    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    override func setupSubviews() {
        setupViews()
        setupAccessibility()
    }

    func configure(with model: CardProgressMlc, eventHandler: ((ConstructorItemEvent) -> Void)?) {
        if let chipStatusAtm = model.chipStatusAtm {
            statusBadge.configure(for: chipStatusAtm)
        }
        statusBadge.isHidden = model.chipStatusAtm == nil
        descriptionLabel.isHidden = model.description == nil
        descriptionLabel.text = model.description
        titleLabel.isHidden = model.label == nil
        titleLabel.text = model.label
        titleLabel.accessibilityLabel = model.label
        rightSubtitle.isHidden = model.rightLabel == nil
        rightSubtitle.text = model.rightLabel
        
        topStackView.isHidden = rightSubtitle.isHidden && statusBadge.isHidden
        
        progressView.configure(for: model.progressBarAtm)
        
        if let iconUrlAtm = model.leftBigImage {
            leftImageView.configure(with: iconUrlAtm)
        }
        rightImageView.subview.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: model.iconRight?.code)
        
        self.eventHandler = eventHandler
        
        if let imageAction = model.leftBigImage?.action {
            leftImageView.tapGestureRecognizer {[weak self] in
                self?.eventHandler?(.action(imageAction))
            }
        }
        leftImageView.accessibilityLabel = model.leftBigImage?.accessibilityDescription
        leftImageView.isUserInteractionEnabled = !(model.leftBigImage?.action == nil)
        if let infoAction = model.iconRight?.action {
            rightImageView.tapGestureRecognizer {[weak self] in
                self?.eventHandler?(.action(infoAction))
            }
        }
        rightImageView.isUserInteractionEnabled = !(model.iconRight?.action == nil)
        if let cardAction = model.action {
            rightImageView.isAccessibilityElement = true
            rightImageView.accessibilityTraits = .button
            rightImageView.accessibilityLabel = model.iconRight?.accessibilityDescription
            
            tapGestureRecognizer {[weak self] in
                self?.eventHandler?(.action(cardAction))
            }
        }
    }

    // MARK: ‑‑ Private helpers
    
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        
        rightImageView.contentMode = .scaleAspectFit
        
        leftImageView.layer.cornerRadius = Constants.imageCornerRadius
        leftImageView.layer.masksToBounds = true
        
        let textStack = UIStackView.create(
            views:[titleLabel, descriptionLabel],
            spacing: Constants.smallPadding,
            alignment: .top)
        
        topStackView = UIStackView.create(
            .horizontal,
            views: [statusBadge, rightSubtitle],
            spacing: Constants.padding / 2,
            alignment: .trailing,
            distribution: .fill)
        
        let middleRightStack = UIStackView.create(
            .horizontal,
            views: [textStack, rightImageView],
            alignment: .top,
            distribution: .equalSpacing)
        
        let middleStack = UIStackView.create(
            .horizontal,
            views: [leftImageView, middleRightStack],
            spacing: Constants.padding,
            alignment: .top)
        
        let viewStack = UIStackView.create(views: [topStackView, middleStack, progressView],
                                           spacing: Constants.padding)
        addSubview(viewStack)
        viewStack.fillSuperview(padding: .allSides(Constants.padding))
    }
    
    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = .header
        
        leftImageView.isAccessibilityElement = true
        leftImageView.accessibilityTraits = .image
    }
}

private extension CardProgressMlcView {
    enum Constants {
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 4
        static let cornerRadius: CGFloat = 16
        static let bigImageSize = CGSize(width: 56, height: 56)
        static let imageCornerRadius: CGFloat = 8
        static let imageSize = CGSize(width: 24, height: 24)
        static let imageInsets = UIEdgeInsets(top: 2, left: 32, bottom: 30, right: 0)
    }
}
