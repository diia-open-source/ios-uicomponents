
import UIKit
import SwiftMessages
import DiiaCommonTypes

/// design_system_code: tableItemHorizontalMlc

public class DSTableItemHorizontalView: BaseCodeView {
    
    private let iconView = UIButton()
    private let supportLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let detailsLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let valueTextView = UITextView()
    private let valueDetailsLabel = UILabel().withParameters(font: FontBook.usualFont)
    
    private lazy var titleStack = UIStackView.create(views: [titleLabel, detailsLabel])
    private lazy var valueStack = UIStackView.create(views: [valueTextView, valueDetailsLabel])
    private lazy var stack = UIStackView.create(.horizontal,
                                                views: [supportLabel, titleStack, valueStack, iconView],
                                                spacing: Constants.bigStackSpacing,
                                                alignment: .top)
    
    private var supportProportionConstraint: NSLayoutConstraint?
    private var proportionConstraint: NSLayoutConstraint?
    private var urlOpener: URLOpenerProtocol?

    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        titleLabel.textAlignment = .left

        valueTextView.textAlignment = .left
        valueTextView.font = FontBook.usualFont

        addSubview(stack)
        stack.fillSuperview()
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)

        valueTextView.configureForParametrizedText()
        valueTextView.delegate = self
        valueTextView.textContainer.lineBreakMode = .byWordWrapping

        valueStack.alignment = .leading
        
        iconView.withSize(Constants.buttonSize)
        
        setupUI()
        setupAccessibility()
    }
    
    public func configure(item: DSTableItemHorizontalMlc, valueAlignment: NSTextAlignment = .natural, urlOpener: URLOpenerProtocol?) {
        self.urlOpener = urlOpener

        iconView.isHidden = item.icon == nil

        if let icon = item.icon {
            iconView.setImage(UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: icon.code)?.withRenderingMode(.alwaysTemplate),
                              for: .normal)
            iconView.addTarget(self, action: #selector(copyValue), for: .touchUpInside)
            iconView.accessibilityTraits = .button
            iconView.accessibilityLabel = R.Strings.general_accessibility_copy_button.localized()
        }
        iconView.tintColor = .black
        
        titleLabel.attributedText = item.label.attributed(font: titleLabel.font,
                                                          lineHeightMultiple: Constants.lineHeightMultiply,
                                                          lineBreakMode: .byWordWrapping)
        detailsLabel.attributedText = item.secondaryLabel?.attributed(font: titleLabel.font,
                                                                      color: .black540,
                                                                      lineHeightMultiple: Constants.lineHeightMultiply,
                                                                      lineBreakMode: .byWordWrapping)
        detailsLabel.accessibilityAttributedLabel = accessibilityLabel(for: item.secondaryLabel ?? "")
        
        setValueAlignment(item.orientation == true ? .right : .left)
        
        if let valueParameters = item.valueParameters {
            valueTextView.attributedText = item.value?.attributedTextWithParameters(parameters: valueParameters)
        } else {
            valueTextView.attributedText = item.value?.attributed(font: titleLabel.font,
                                                                  lineHeightMultiple: Constants.lineHeightMultiply,
                                                                  textAlignment: valueAlignment,
                                                                  lineBreakMode: .byWordWrapping)
        }

        valueDetailsLabel.attributedText = item.secondaryValue?.attributed(font: titleLabel.font,
                                                                           color: .black540,
                                                                           lineHeightMultiple: Constants.lineHeightMultiply,
                                                                           lineBreakMode: .byWordWrapping)
        valueDetailsLabel.accessibilityAttributedLabel = accessibilityLabel(for: item.secondaryValue ?? "")
        
        supportLabel.attributedText = item.supportingValue?.attributed(font: titleLabel.font,
                                                                       lineHeightMultiple: Constants.lineHeightMultiply,
                                                                       textAlignment: .right,
                                                                       lineBreakMode: .byWordWrapping)
        titleLabel.isHidden = item.label.isEmpty
        valueTextView.isHidden = item.value == nil
        detailsLabel.isHidden = item.secondaryLabel == nil
        valueDetailsLabel.isHidden = item.secondaryValue == nil
        supportLabel.isHidden = item.supportingValue == nil
        
        titleStack.isAccessibilityElement = false
        valueStack.isAccessibilityElement = false
        stack.accessibilityElements = [supportLabel, titleLabel, valueTextView, detailsLabel, valueDetailsLabel, iconView]
    }
    
    public func setValueAlignment(_ textAlignment: NSTextAlignment = .natural) {
        valueStack.alignment = textAlignment == .right ? .trailing : .leading
        valueTextView.textAlignment = textAlignment
        valueDetailsLabel.textAlignment = textAlignment
    }
    
    @discardableResult
    public func setupUI(iconImage: UIImage? = nil,
                        titleFont: UIFont = FontBook.usualFont,
                        valueFont: UIFont = FontBook.usualFont,
                        detailsFont: UIFont = FontBook.usualFont,
                        valueDetailsFont: UIFont = FontBook.usualFont,
                        detailsColor: UIColor = Constants.lightBlackColor,
                        iconProportion: CGFloat = Constants.iconProportion,
                        titleProportion: CGFloat = Constants.titleProportion,
                        numberOfLines: Int = 0) -> DSTableItemHorizontalView {
        
        iconView.setImage(iconImage, for: .normal)
        titleLabel.withParameters(font: titleFont)
        valueTextView.font = valueFont

        detailsLabel.withParameters(font: detailsFont, textColor: detailsColor)
        valueDetailsLabel.withParameters(font: valueDetailsFont, textColor: detailsColor)
        
        proportionConstraint?.isActive = false
        proportionConstraint = titleStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: iconImage == nil ? titleProportion : Constants.smallTitleProportion)
        proportionConstraint?.isActive = true
        
        supportProportionConstraint?.isActive = false
        supportProportionConstraint = supportLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.iconProportion)
        supportProportionConstraint?.isActive = true
        
        titleLabel.numberOfLines = numberOfLines
        valueTextView.textContainer.maximumNumberOfLines = numberOfLines
        
        if numberOfLines == 1 {
            titleLabel.minimumScaleFactor = Constants.minTextScaleFactor
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        
        return self
    }
    
    @objc private func copyValue() {
        guard let resource = valueTextView.text else { return }
        UIPasteboard.general.string = resource
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        SwiftMessages.showSuccessMessage(message: R.Strings.general_number_copied.localized())
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        detailsLabel.isAccessibilityElement = true
        detailsLabel.accessibilityTraits = .staticText
        
        valueDetailsLabel.isAccessibilityElement = true
        valueDetailsLabel.accessibilityTraits = .staticText
    }
    
    private func accessibilityLabel(for text: String) -> NSMutableAttributedString {
        let mutableAccessibilityLabel = NSMutableAttributedString(string: text)
        mutableAccessibilityLabel.addAttribute(
            .accessibilitySpeechLanguage,
            value: text.textLocale.rawValue,
            range: NSRange(location: 0, length: text.count)
        )
        
        return mutableAccessibilityLabel
    }
}

extension DSTableItemHorizontalView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

public extension DSTableItemHorizontalView {
    enum Constants {
        public static let iconProportion: CGFloat = 0.1
        public static let titleProportion: CGFloat = 0.5
        public static let lightBlackColor = UIColor.black.withAlphaComponent(0.4)
        static let smallTitleProportion: CGFloat = 0.4
        static let bigStackSpacing: CGFloat = 8
        static let minTextScaleFactor: CGFloat = 0.5
        static let buttonSize = CGSize(width: 24, height: 24)
        static let lineHeightMultiply: CGFloat = 1.25
    }
}
