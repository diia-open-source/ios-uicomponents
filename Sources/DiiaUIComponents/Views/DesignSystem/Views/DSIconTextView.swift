
import UIKit

public struct DSIconTextModel: Codable {
    public let iconLeft: DSIconModel?
    public let text: String?

    public init(iconLeft: DSIconModel? = nil, text: String? = nil) {
        self.iconLeft = iconLeft
        self.text = text
    }
}

public final class DSIconTextView: BaseCodeView {
    private let iconView = DSIconView()
    private let textLabel = UILabel().withParameters(font: FontBook.usualFont)
    private lazy var stackView = UIStackView.create(.horizontal, views: [iconView, textLabel], spacing: Constants.spacing, alignment: .top)

    private var iconWidthConstraint: NSLayoutConstraint?
    private var iconHeightConstraint: NSLayoutConstraint?

    public override func setupSubviews() {
        addSubview(stackView)
        stackView.fillSuperview()

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconWidthConstraint = iconView.widthAnchor.constraint(equalToConstant: Constants.defaultIconSize.width)
        iconHeightConstraint = iconView.heightAnchor.constraint(equalToConstant: Constants.defaultIconSize.height)
        iconWidthConstraint?.isActive = true
        iconHeightConstraint?.isActive = true
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        iconView.setContentCompressionResistancePriority(.required, for: .horizontal)

        textLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    public func configure(
        with model: DSIconTextModel,
        textColor: UIColor = .gray,
        iconSize: CGSize = CGSize(width: 16, height: 16),
        alignment: UIStackView.Alignment = .top,
        textFillsWidth: Bool = true
    ) {
        stackView.alignment = alignment
        iconWidthConstraint?.constant = iconSize.width
        iconHeightConstraint?.constant = iconSize.height

        iconView.isHidden = model.iconLeft == nil
        if let iconLeft = model.iconLeft {
            iconView.setIcon(iconLeft)
        }

        textLabel.isHidden = model.text == nil
        textLabel.text = model.text
        textLabel.textColor = textColor
        let huggingPriority: UILayoutPriority = textFillsWidth ? .init(1) : .required
        textLabel.setContentHuggingPriority(huggingPriority, for: .horizontal)
        textLabel.setContentCompressionResistancePriority(huggingPriority, for: .horizontal)
    }
}

public extension DSIconTextView {
    static func width(for model: DSIconTextModel, textFont: UIFont = FontBook.usualFont, iconSize: CGSize = CGSize(width: 16, height: 16)) -> CGFloat {
        var width: CGFloat = 0
        if model.iconLeft != nil {
            width += iconSize.width + Constants.spacing
        }
        if let text = model.text {
            width += text.width(withConstrainedHeight: .greatestFiniteMagnitude, font: textFont)
        }
        return width
    }
}

private extension DSIconTextView {
    enum Constants {
        static let spacing: CGFloat = 4
        static let defaultIconSize = CGSize(width: 16, height: 16)
    }
}
