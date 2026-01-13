
import UIKit
import DiiaCommonTypes

public final class DSCheckboxMlcView: BaseCodeView {
    private let mainStack = UIStackView.create(.horizontal, spacing: Constants.horizontalSpacing, alignment: .top)
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: Constants.descriptionLabelTextColor)
    private let labelsStack = UIStackView.create(.vertical, spacing: Constants.verticalSpacing, alignment: .leading)

    private let checkmarkImageView = UIImageView().withSize(Constants.checkmarkImageSize)

    private var viewModel: DSCheckboxMlcViewModel?

    private var accessibilityTraitsSet: Set<UIAccessibilityTraits> = [.button] {
        didSet {
            accessibilityTraits = UIAccessibilityTraits(accessibilityTraitsSet)
        }
    }

    // MARK: - Lifecycle
    public override func setupSubviews() {
        checkmarkImageView.contentMode = .scaleAspectFit

        addSubview(mainStack)
        mainStack.addArrangedSubviews([checkmarkImageView, labelsStack])
        mainStack.fillSuperview(padding: Constants.innerPaddings)

        labelsStack.addArrangedSubviews([titleLabel, descriptionLabel])

        addTapGestureRecognizer()
        setupAccessibility()
    }

    // MARK: - Public Methods
    public func configure(with viewModel: DSCheckboxMlcViewModel) {
        self.viewModel = viewModel

        accessibilityLabel = [viewModel.model.label,
                              viewModel.model.description].compactMap { $0 }.joined(separator: ",")

        titleLabel.text = viewModel.model.label

        descriptionLabel.isHidden = viewModel.model.description == nil
        descriptionLabel.text = viewModel.model.description

        viewModel.isSelected.observe(observer: self) { [weak self] _ in
            self?.updateSelectionState()
        }
        viewModel.isEnabled.observe(observer: self) { [weak self] isEnabled in
            self?.updateAvailabilityState(isEnabled: isEnabled)
        }
    }

    private func setupAccessibility() {
        isAccessibilityElement = true
    }

    private func addTapGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        self.addGestureRecognizer(gesture)
        self.isUserInteractionEnabled = true
    }

    private func updateSelectionState() {
        guard let viewModel else { return }

        checkmarkImageView.image = viewModel.isSelected.value ? R.image.checkbox_enabled.image : R.image.checkbox_disabled.image

        if viewModel.isSelected.value {
            accessibilityTraitsSet.insert(.selected)
        } else {
            accessibilityTraitsSet.remove(.selected)
        }
    }

    private func updateAvailabilityState(isEnabled: Bool) {
        isUserInteractionEnabled = isEnabled
        labelsStack.alpha = isEnabled ? Constants.enabledAlpha : Constants.disabledAlpha
        checkmarkImageView.alpha = isEnabled ? Constants.enabledAlpha : Constants.disabledAlpha

        if isEnabled {
            accessibilityTraitsSet.remove(.notEnabled)
        } else {
            accessibilityTraitsSet.insert(.notEnabled)
        }
    }

    @objc private func onTapped() {
        guard let viewModel, viewModel.isEnabled.value else { return }
        viewModel.isSelected.value.toggle()
        viewModel.onClick?()
    }
}

// MARK: - DSInputComponentProtocol
extension DSCheckboxMlcView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        return viewModel?.isSelected.value == true
    }

    public func inputCode() -> String {
        return viewModel?.model.inputCode ?? "tableItemCheckboxMlc"
    }

    public func inputData() -> AnyCodable? {
        return .bool(viewModel?.isSelected.value ?? false)
    }
}

// MARK: - Constants
private extension DSCheckboxMlcView {
    enum Constants {
        static let verticalSpacing: CGFloat = 4.0
        static let disabledAlpha: CGFloat = 0.3
        static let enabledAlpha: CGFloat = 1.0
        static let horizontalSpacing: CGFloat = 16.0
        static let innerPaddings = UIEdgeInsets.allSides(16.0)
        static let checkmarkImageSize = CGSize(width: 20, height: 20)
        static let descriptionLabelTextColor = UIColor.black.withAlphaComponent(0.5)
    }
}
