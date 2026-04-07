
import UIKit
import SwiftMessages

/// design_system_code: tableItemPrimaryMlc

public final class DSTableItemPrimaryView: BaseCodeView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let iconButtonView = UIButton()
    private let secondaryLabel = UILabel()
    private let secondaryValueLabel = UILabel()
    private let secondaryStack = UIStackView.create(spacing: Constants.stackSpacing)
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        let valueIconStack = UIStackView.create(.horizontal,
                                                views: [valueLabel, iconButtonView, UIView()],
                                                spacing: Constants.stackSpacing,
                                                alignment: .center)
        let mainStack = UIStackView.create(.vertical,
                                           views: [titleLabel, valueIconStack],
                                           spacing: Constants.stackSpacing)

        secondaryStack.addArrangedSubview(secondaryLabel)
        secondaryStack.addArrangedSubview(secondaryValueLabel)
        secondaryStack.isHidden = true

        let outerStack = stack([mainStack, secondaryStack])
        outerStack.setCustomSpacing(Constants.secondaryStackTopSpacing, after: mainStack)

        iconButtonView.withSize(Constants.imageSize)
        iconButtonView.contentHorizontalAlignment = .leading

        setupView()
    }
    
    public func configure(for title: String, value: String, withIcon: Bool) {
        titleLabel.text = title
        titleLabel.accessibilityLabel = title
        
        valueLabel.text = value
        valueLabel.accessibilityLabel = value
        
        iconButtonView.isHidden = !withIcon
        if withIcon {
            iconButtonView.setImage(UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: Constants.copyImage),
                                    for: .normal)
        }
    }
    
    public func configure(for title: String?, value: String, icon: DSIconModel?) {
        titleLabel.text = title
        valueLabel.text = value
        
        valueLabel.text = value
        valueLabel.accessibilityLabel = value
        
        iconButtonView.isHidden = icon == nil
        if let iconName = icon?.code {
            iconButtonView.setImage(UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: iconName),
                                    for: .normal)
        }
    }
    
    public func configure(model: DSTableItemPrimaryMlc) {
        configure(for: model.label, value: model.value, icon: model.icon)
    }
    
    public func configure(model: DSDocNumberCopyMlc) {
        configure(for: model.label, value: model.value, icon: model.icon)
        
        let hasSecondary = model.secondaryLabel != nil || model.secondaryValue != nil
        secondaryStack.isHidden = !hasSecondary
        secondaryLabel.text = model.secondaryLabel
        secondaryLabel.isHidden = model.secondaryLabel == nil
        secondaryValueLabel.text = model.secondaryValue
        secondaryValueLabel.isHidden = model.secondaryValue == nil
    }
    
    private func setupView() {
        titleLabel.font = FontBook.usualFont
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        valueLabel.font = FontBook.numbersHeadingFont
        valueLabel.numberOfLines = 1
        valueLabel.textColor = .black

        secondaryLabel.font = FontBook.mainFont.regular.size(14)
        secondaryLabel.numberOfLines = 0
        secondaryLabel.textColor = .black
        secondaryValueLabel.font = FontBook.mainFont.regular.size(14)
        secondaryValueLabel.numberOfLines = 0
        secondaryValueLabel.textColor = .black
        
        iconButtonView.addTarget(self, action: #selector(actionRecognizer), for: .touchUpInside)
        setupAccessibility()
    }
    
    public func setupUI(textColor: UIColor = .black,
                        titleFont: UIFont = FontBook.usualFont,
                        valueFont: UIFont = FontBook.numbersHeadingFont,
                        numberOfLines: Int = 1) {
        titleLabel.textColor = textColor
        valueLabel.textColor = textColor
        titleLabel.font = titleFont
        valueLabel.font = valueFont
        titleLabel.numberOfLines = numberOfLines
        valueLabel.numberOfLines = numberOfLines
        
        if numberOfLines == 1 {
            titleLabel.adjustsFontSizeToFitWidth = true
            valueLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @objc private func actionRecognizer(_ sender: UIButton) {
        guard let resource = valueLabel.text else { return }
        UIPasteboard.general.string = resource
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        SwiftMessages.showSuccessMessage(message: R.Strings.general_number_copied.localized())
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityTraits = .staticText
        
        valueLabel.isAccessibilityElement = true
        valueLabel.accessibilityTraits = .staticText
        
        iconButtonView.isAccessibilityElement = true
        iconButtonView.accessibilityTraits = .button
        iconButtonView.accessibilityLabel = R.Strings.general_accessibility_copy_button.localized()
    }
}

extension DSTableItemPrimaryView {
    enum Constants {
        static let stackSpacing: CGFloat = 8
        static let imageSize = CGSize(width: 44, height: 44)
        static let copyImage = "copy"
        static let secondaryStackTopSpacing: CGFloat = 16
        static let secondaryStackBottomSpacing: CGFloat = 8
    }
}
