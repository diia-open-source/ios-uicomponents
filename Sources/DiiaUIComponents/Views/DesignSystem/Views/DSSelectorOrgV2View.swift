
import UIKit
import DiiaCommonTypes

/// design_system_code: selectorOrgV2
public class DSSelectorOrgV2View: BaseCodeView, DSInputComponentProtocol {
    private let borderedView = UIView()

    private let titleLabel = UILabel().withParameters(font: FontBook.statusFont, numberOfLines: Constants.titleNumberOfLines)
    private let textLabel = UILabel().withParameters(font: FontBook.bigText, numberOfLines: Constants.textNumberOfLines)
    private let hintLabel = UILabel().withParameters(font: FontBook.statusFont, numberOfLines: Constants.hintNumberOfLines)

    private let arrowIconView: UIImageView = .init().withSize(Constants.arrowImageSize)

    private lazy var labelsVStack = UIStackView.create(
        views: [titleLabel, textLabel],
        spacing: Constants.labelsSpacing,
        alignment: .leading)

    private lazy var innerHStack = UIStackView.create(
        .horizontal,
        views: [labelsVStack, arrowIconView],
        spacing: Constants.horizontalInnerHStackSpacing,
        alignment: .center)

    private var viewModel: DSSelectorViewModel?

    // MARK: - Init
    public override func setupSubviews() {
        addSubview(borderedView)
        borderedView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor)

        borderedView.addSubview(innerHStack)
        innerHStack.fillSuperview(padding: Constants.insets)

        borderedView.layer.cornerRadius = Constants.cornerRadius
        borderedView.layer.borderWidth = Constants.borderWidth
        borderedView.layer.borderColor = Constants.borderColor.cgColor
        borderedView.backgroundColor = .white

        arrowIconView.image = R.image.arrowRight.image

        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        tap.cancelsTouchesInView = false
        borderedView.addGestureRecognizer(tap)
    }

    // MARK: - Public Methods
    public func configure(with viewModel: DSSelectorViewModel) {
        accessibilityIdentifier = viewModel.componentId

        self.viewModel?.state.removeObserver(observer: self)
        self.viewModel = viewModel

        titleLabel.text = viewModel.title

        viewModel.state.observe(observer: self) { [weak self] state in
            self?.setState(state)
        }

        setHint(viewModel.hint)
        setupAccessibility()
    }

    // MARK: - Private Methods
    private func setState(_ state: DropContentState) {
        guard let viewModel else { return }
        setAlpha(Constants.activeAlpha)
        isUserInteractionEnabled = true

        switch state {
        case .disabled:
            setAlpha(Constants.inactiveAlpha)
            textLabel.text = viewModel.placeholder
            isUserInteractionEnabled = false
        case .enabled:
            textLabel.text = viewModel.placeholder
            textLabel.accessibilityLabel = viewModel.placeholder
            textLabel.alpha = Constants.inactiveAlpha
            hintLabel.alpha = Constants.hintActiveAlpha
        case .selected(let text):
            textLabel.text = text
            textLabel.accessibilityLabel = text
            hintLabel.alpha = Constants.hintActiveAlpha
        case .single(let text):
            setAlpha(Constants.inactiveAlpha)
            textLabel.text = text
            textLabel.accessibilityLabel = text
            isUserInteractionEnabled = false
        default:
            break
        }
    }

    private func setAlpha(_ alpha: CGFloat) {
        titleLabel.alpha = alpha
        textLabel.alpha = alpha
        arrowIconView.alpha = alpha
        hintLabel.alpha = alpha
    }

    private func setHint(_ hint: String?) {
        hintLabel.text = hint

        if hint != nil {
            addSubview(hintLabel)
            hintLabel.anchor(
                top: borderedView.bottomAnchor,
                leading: labelsVStack.leadingAnchor,
                bottom: bottomAnchor,
                trailing: trailingAnchor,
                padding: .init(right: Constants.insets.right, top: Constants.hintTopSpacing))
        } else {
            hintLabel.removeFromSuperview()
        }
    }

    // MARK: - Accessibility
    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = .staticText
        titleLabel.accessibilityLabel = viewModel?.title

        textLabel.isAccessibilityElement = true
        textLabel.accessibilityTraits = .button
    }

    // MARK: - Action
    @objc private func onClick() {
        viewModel?.onClick?()
    }

    // MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        guard viewModel?.mandatory == true else { return true }
        return viewModel?.selectedCode != nil
    }

    public func inputCode() -> String {
        return viewModel?.code ?? Constants.inputCode
    }

    public func inputData() -> AnyCodable? {
        guard let data = viewModel?.selectedCode else { return nil }
        return .string(data)
    }
}

// MARK: - Constants
extension DSSelectorOrgV2View {
    private enum Constants {
        static let insets: UIEdgeInsets = .allSides(12)
        static let labelsSpacing: CGFloat = 4
        static let hintTopSpacing: CGFloat = 4
        static let horizontalInnerHStackSpacing: CGFloat = 4
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let arrowImageSize = CGSize(width: 16, height: 16)
        static let borderColor = UIColor("#C5D9E9")

        static let inactiveAlpha: CGFloat = 0.3
        static let activeAlpha: CGFloat = 1.0
        static let hintActiveAlpha: CGFloat = 0.5

        static let titleNumberOfLines = 1
        static let textNumberOfLines = 1
        static let hintNumberOfLines = 1

        static let inputCode = "selector"
    }
}
