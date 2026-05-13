
import UIKit
import DiiaCommonTypes

public final class DSButtonPlainAtmView: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText, numberOfLines: 1, lineBreakMode: .byTruncatingTail)
    private let leftIconView = UIImageView().withSize(Constants.leftIconSize)
    private lazy var contentHStackView = UIStackView.create(.horizontal, views: [leftIconView, titleLabel], spacing: Constants.stackSpacing, alignment: .center)

    var onClick: (() -> Void)?

    override public func setupSubviews() {
        addSubview(contentHStackView)
        contentHStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentHStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.horizontalInset),
            contentHStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -Constants.horizontalInset),
            contentHStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Constants.centerYOffset),
            contentHStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        tapGestureRecognizer { [weak self] in
            self?.onClick?()
        }
    }

    // MARK: - Public Methods
    public func configure(with model: DSButtonPlainAtmModel) {
        titleLabel.text = model.label
        leftIconView.isHidden = model.iconLeft == nil

        if let iconModel = model.iconLeft {
            leftIconView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: iconModel.code)
        }
    }
}

// MARK: - Constants
private extension DSButtonPlainAtmView {
    enum Constants {
        static let leftIconSize = CGSize(width: 24, height: 24)
        static let horizontalInset: CGFloat = 40
        static let centerYOffset: CGFloat = 4
        static let buttonHeight: CGFloat = 56
        static let stackSpacing: CGFloat = 8
    }
}
