
import UIKit

/// design_system_code: collapsibleTitleMlc
final public class DSCollapsibleTitleMlcView: BaseCodeView {
    private let mainStack = UIStackView.create(.vertical, spacing: Constants.spacing, alignment: .fill)
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont, lineBreakMode: .byTruncatingTail)
    private let expandContainer = UIView()
    private let expandStack = UIStackView.create(.horizontal, spacing: Constants.expandSpacing, alignment: .center)
    private let actionLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let expandIcon = UIImageView()

    private var expandModel: DSCollapsibleTitleMlcExpanded?
    private var isExpanded = false
    private var eventHandler: ((ConstructorItemEvent) -> Void)?

    // MARK: - Lifecycle
    public override func setupSubviews() {
        super.setupSubviews()
        addSubview(mainStack)
        mainStack.fillSuperview()

        expandIcon.withSize(Constants.expandIconSize)
        expandStack.addArrangedSubviews([actionLabel, expandIcon])

        expandContainer.addSubview(expandStack)
        expandStack.anchor(
            top: expandContainer.topAnchor,
            leading: expandContainer.leadingAnchor,
            bottom: expandContainer.bottomAnchor
        )

        mainStack.addArrangedSubviews([titleLabel, expandContainer])

        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        expandStack.addGestureRecognizer(gesture)

        setupAccessibility()
    }

    // MARK: - Public Methods
    public func configure(model: DSCollapsibleTitleMlcModel) {
        accessibilityIdentifier = model.componentId
        titleLabel.text = model.title
        titleLabel.accessibilityLabel = model.title

        expandModel = model.expanded
        expandContainer.isHidden = model.expanded == nil

        if let expanded = model.expanded {
            isExpanded = expanded.isExpanded ?? false
            setState(isExpanded, animated: false)
        } else {
            titleLabel.numberOfLines = 0
        }
    }

    public func setEventHandler(_ eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }

    // MARK: - Private Methods
    private func setState(_ isExpanded: Bool, animated: Bool) {
        guard let model = expandModel else { return }
        actionLabel.text = isExpanded ? model.collapsedText : model.expandedText
        expandIcon.image = isExpanded ? R.image.arrowUp.image : R.image.arrowDown.image
        expandStack.accessibilityLabel = isExpanded ? model.collapsedText : model.expandedText

        titleLabel.numberOfLines = isExpanded ? 0 : Constants.collapsedNumberOfLines
        titleLabel.invalidateIntrinsicContentSize()

        if animated {
            UIView.animate(withDuration: Constants.animationDuration) {
                self.superview?.layoutIfNeeded()
            }
        } else {
            eventHandler?(.componentSizeDidChange)
        }
    }

    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = .header

        expandStack.isAccessibilityElement = true
        expandStack.accessibilityTraits = .button
    }

    // MARK: - Actions
    @objc private func onTapped() {
        isExpanded.toggle()
        setState(isExpanded, animated: true)
    }
}

// MARK: - DSCollapsibleTitleMlcView+Constants
private extension DSCollapsibleTitleMlcView {
    enum Constants {
        static let spacing: CGFloat = 12
        static let expandSpacing: CGFloat = 4
        static let expandIconSize = CGSize(width: 16, height: 16)
        static let collapsedNumberOfLines = 2
        static let animationDuration: TimeInterval = 0.2
    }
}
