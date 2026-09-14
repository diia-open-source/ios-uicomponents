
import UIKit
import DiiaCommonTypes

/// design_system_code: switchItemMlc
public final class DSSwitchItemMlcView: BaseCodeView {
    private let mainStack = UIStackView.create(.horizontal, spacing: Constants.horizontalSpacing, alignment: .center)
    private let iconImageView = UIImageView().withSize(Constants.iconSize)
    private let labelsStack = UIStackView.create(.vertical, spacing: Constants.verticalSpacing)
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .black540)
    private let switchControl = UISwitch()

    private var viewModel: DSSwitchItemMlcViewModel?

    // MARK: - Lifecycle
    public override func setupSubviews() {
        iconImageView.contentMode = .scaleAspectFit
        switchControl.onTintColor = Constants.onTintColor
        switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)

        addSubview(mainStack)
        mainStack.addArrangedSubviews([iconImageView, labelsStack, switchControl])
        mainStack.fillSuperview(padding: Constants.innerPaddings)

        labelsStack.addArrangedSubviews([titleLabel, descriptionLabel])

        setupAccessibility()
    }

    // MARK: - Public Methods
    public func configure(with viewModel: DSSwitchItemMlcViewModel) {
        self.viewModel = viewModel

        accessibilityIdentifier = viewModel.model.componentId

        iconImageView.isHidden = viewModel.model.iconLeft == nil
        if let iconLeft = viewModel.model.iconLeft {
            iconImageView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: iconLeft)
        }

        titleLabel.text = viewModel.model.title

        descriptionLabel.isHidden = viewModel.model.description == nil
        descriptionLabel.text = viewModel.model.description

        viewModel.isSelected.observe(observer: self) { [weak self] isSelected in
            self?.switchControl.setOn(isSelected, animated: self?.window != nil)
        }
    }

    private func setupAccessibility() {
        isAccessibilityElement = false
        titleLabel.isAccessibilityElement = true
        descriptionLabel.isAccessibilityElement = true
    }

    @objc private func switchValueChanged() {
        setSelected(switchControl.isOn)
    }

    private func setSelected(_ isSelected: Bool) {
        guard let viewModel else { return }
        viewModel.isSelected.value = isSelected
        viewModel.onClick?()
    }
}

// MARK: - DSInputComponentProtocol
extension DSSwitchItemMlcView: DSInputComponentProtocol {
    public func isValid() -> Bool {
        return true
    }

    public func inputCode() -> String {
        return viewModel?.model.inputCode ?? ""
    }

    public func inputData() -> AnyCodable? {
        return .bool(viewModel?.isSelected.value ?? false)
    }
}

// MARK: - Constants
private extension DSSwitchItemMlcView {
    enum Constants {
        static let horizontalSpacing: CGFloat = 16.0
        static let verticalSpacing: CGFloat = 4.0
        static let innerPaddings = UIEdgeInsets.allSides(16.0)
        static let iconSize = CGSize(width: 24, height: 24)
        static let onTintColor = UIColor(red: 0.376, green: 0.784, blue: 0.392, alpha: 1)
    }
}
