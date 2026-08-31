
import UIKit
import DiiaCommonTypes

public final class DSCheckboxMlcView: BaseCodeView {
    private let mainStack = UIStackView.create(.horizontal, spacing: Constants.horizontalSpacing, alignment: .top)
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let labelsStack = UIStackView.create(.vertical, spacing: Constants.verticalSpacing)
    private let descriptionsStack = UIStackView.create(.vertical, spacing: Constants.descriptionsStackSpacing)
    private let chipsWrapView = DSRowItemsWrapView()

    private let checkmarkImageView = UIImageView().withSize(Constants.checkmarkImageSize)

    private var viewModel: DSCheckboxMlcViewModel?

    private var accessibilityTraitsSet: Set<UIAccessibilityTraits> = [.button] {
        didSet {
            accessibilityTraits = UIAccessibilityTraits(accessibilityTraitsSet)
        }
    }

    private var descriptionTextColor: UIColor {
        switch viewModel?.model.descriptionStyle {
        case Constants.infoStyle:
            // NOTE: temporary color, not final. Real color for info style is not known yet.
            //TODO: -  Change this when we get the real color.
            return .blue
        default:
            return .black540
        }
    }

    // MARK: - Lifecycle
    public override func setupSubviews() {
        checkmarkImageView.contentMode = .scaleAspectFit

        addSubview(mainStack)
        mainStack.addArrangedSubviews([checkmarkImageView, labelsStack])
        mainStack.fillSuperview(padding: Constants.innerPaddings)

        labelsStack.addArrangedSubviews([titleLabel, descriptionLabel, descriptionsStack, chipsWrapView])

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
        descriptionLabel.textColor = descriptionTextColor
        
        descriptionsStack.safelyRemoveArrangedSubviews()
        descriptionsStack.isHidden = viewModel.model.descriptions == nil
        if let descriptions = viewModel.model.descriptions {
            descriptions.forEach {
                let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont,
                                                                textColor: descriptionTextColor)
                descriptionLabel.text = $0
                descriptionsStack.addArrangedSubview(descriptionLabel)
            }
        }

        let chipItems = (viewModel.model.chips ?? []).map { chip -> (view: UIView, width: CGFloat) in
            let chipView = DSChipStatusAtmView()
            chipView.configure(for: chip.chipStatusAtm)
            let width = DSChipStatusAtmView.widthForText(text: chip.chipStatusAtm.name)
            return (chipView, width)
        }
        chipsWrapView.configure(items: chipItems)

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

        checkmarkImageView.image = viewModel.isSelected.value ? R.image.checkbox_selected.image : R.image.checkbox_deselected.image

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
        return viewModel?.model.inputCode ?? "checkBoxMlc"
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
        static let descriptionsStackSpacing: CGFloat = 8.0
        static let infoStyle = "info"

        static let chipsHeight: CGFloat = 18
        static let chipsLineSpacing: CGFloat = 8
        static let chipsInteritemSpacing: CGFloat = 8
        static let chipsEstimatedWidth: CGFloat = 50
        static let chipsLayoutPriority = UILayoutPriority(999)
    }
}
