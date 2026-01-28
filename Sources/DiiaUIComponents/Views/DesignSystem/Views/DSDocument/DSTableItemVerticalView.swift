
import UIKit
import SwiftMessages
import DiiaCommonTypes

/// design_system_code: tableItemVerticalMlc
public final class DSTableItemVerticalView: DSTableItemView {
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    private let mainStack = UIStackView.create(.horizontal, spacing: Constants.spacing, alignment: .top)
    private let labelValueStack = UIStackView.create(spacing: Constants.stackSpacing)
    
    private var urlOpener: URLOpenerProtocol?
    
    public override func setupSubviews() {
        super.setupSubviews()
        translatesAutoresizingMaskIntoConstraints = false
        labelValueStack.addArrangedSubviews([label, subLabel, value, subValue, icon])
        mainStack.addArrangedSubviews([supportLabel, labelValueStack, actionButton])
        addSubview(mainStack)
        
        value.configureForParametrizedText()
        value.delegate = self
        value.textContainer.lineBreakMode = .byWordWrapping
        
        mainStack.fillSuperview()
        icon.heightAnchor.constraint(equalTo: icon.widthAnchor,
                                     multiplier: Constants.signProportion).isActive = true
        setupUI()
        setupAccessibility()
    }
    
    public func configure(model: DSTableItemVerticalMlc,
                          image: UIImage? = nil,
                          imageAltText: String? = nil,
                          eventHandler: ((ConstructorItemEvent) -> Void)? = nil,
                          urlOpener: URLOpenerProtocol? = nil) {
        self.urlOpener = urlOpener
        self.eventHandler = eventHandler
        self.accessibilityIdentifier = model.componentId
        
        label.accessibilityAttributedLabel = accessibilityLabel(for: model.label ?? "")
        label.attributedText = model.label?.attributed(font: FontBook.usualFont,
                                                       lineHeightMultiple: Constants.lineHeightMultiply,
                                                       lineHeight: Constants.lineHeight,
                                                       lineBreakMode: .byWordWrapping)
        
        subLabel.attributedText = model.secondaryLabel?.attributed(font: FontBook.usualFont,
                                                                   color: .black540,
                                                                   lineHeightMultiple: Constants.lineHeightMultiply,
                                                                   lineHeight: Constants.lineHeight,
                                                                   lineBreakMode: .byWordWrapping)
        subLabel.accessibilityAttributedLabel = accessibilityLabel(for: model.secondaryLabel ?? "")
        
        value.accessibilityAttributedLabel = accessibilityLabel(for: model.value ?? "")
        
        if let valueParameters = model.valueParameters {
            value.attributedText = model.value?.attributedTextWithParameters(parameters: valueParameters)
        } else {
            value.attributedText = model.value?.attributed(font: FontBook.usualFont,
                                                           lineHeightMultiple: Constants.lineHeightMultiply,
                                                           lineHeight: Constants.lineHeight,
                                                           lineBreakMode: .byWordWrapping)
        }
        
        subValue.attributedText = model.secondaryValue?.attributed(font: FontBook.usualFont,
                                                                   color: .black540,
                                                                   lineHeightMultiple: Constants.lineHeightMultiply,
                                                                   lineHeight: Constants.lineHeight,
                                                                   lineBreakMode: .byWordWrapping)
        subValue.accessibilityAttributedLabel = accessibilityLabel(for: model.secondaryValue ?? "")

        configureSupportingLabel(model: model)

        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        subLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        value.setContentCompressionResistancePriority(.required, for: .horizontal)
        value.setContentHuggingPriority(.required, for: .horizontal)
        
        subValue.setContentCompressionResistancePriority(.required, for: .horizontal)
        subValue.setContentHuggingPriority(.required, for: .horizontal)
        
        label.isHidden = model.label == nil
        subLabel.isHidden = model.secondaryLabel == nil
        value.isHidden = model.value == nil || model.value?.isEmpty == true
        subValue.isHidden = model.secondaryValue == nil
        icon.isHidden = image == nil
        actionButton.isHidden = model.icon == nil || value.isHidden
        
        if let icon = model.icon, let action = icon.action {
            actionButton.action = .init(image: UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: icon.code),
                                        callback: { [weak self] in
                self?.handleClick(action: action)
            })
        }
        
        self.icon.image = image?
            .imageByMakingWhiteBackgroundTransparent()?
            .scaled(
                forFittingSize: Constants.signSize,
                scale: UIScreen.main.scale
            )
        self.icon.accessibilityLabel = imageAltText
        self.icon.contentMode = .left

        if !actionButton.isHidden {
            actionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.actionButtonWidthMultiplier).isActive = true
        }

        mainStack.layoutIfNeeded()
    }

    private func configureSupportingLabel(model: DSTableItemVerticalMlc) {
        let isHidden = model.supportingValue == nil && model.pointSupportingValue == nil
        supportLabel.isHidden = isHidden

        if let pointSupportingValue = model.pointSupportingValue {
            supportLabel.attributedText = pointSupportingValue
                .attributed(
                    font: FontBook.usualFont,
                    lineHeightMultiple: Constants.lineHeightMultiply,
                    lineHeight: Constants.lineHeight,
                    textAlignment: .left,
                    lineBreakMode: .byWordWrapping
                )
            supportLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.pointSupportLabelWidthMultiplier).isActive = true
            mainStack.setCustomSpacing(Constants.supportLabelRightOffset, after: supportLabel)
        } else if let supportingValue = model.supportingValue {
            supportLabel.attributedText = supportingValue
                .attributed(
                    font: FontBook.usualFont,
                    lineHeightMultiple: Constants.lineHeightMultiply,
                    lineHeight: Constants.lineHeight,
                    textAlignment: .right,
                    lineBreakMode: .byWordWrapping
                )
            supportLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.supportLabelWidthMultiplier).isActive = true
        }
    }

    private func handleClick(action: DSActionParameter) {
        switch action.type {
        case "copy":
            guard let resource = value.text else { return }
            UIPasteboard.general.string = resource
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            SwiftMessages.showSuccessMessage(message: R.Strings.general_number_copied.localized())
        default:
            eventHandler?(.action(action))
        }
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        label.isAccessibilityElement = true
        label.accessibilityTraits = .staticText
        
        value.isAccessibilityElement = true
        value.accessibilityTraits = .staticText
        
        subLabel.isAccessibilityElement = true
        subLabel.accessibilityTraits = .staticText
        
        subValue.isAccessibilityElement = true
        subValue.accessibilityTraits = .staticText
        
        icon.isAccessibilityElement = true
        icon.accessibilityTraits = .image
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

extension DSTableItemVerticalView: UITextViewDelegate {
    public func textView(_ textView: UITextView,
                         shouldInteractWith URL: URL,
                         in characterRange: NSRange,
                         interaction: UITextItemInteraction) -> Bool {
        return !(urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

extension DSTableItemVerticalView {
    enum Constants {
        static let signProportion: CGFloat = 3/8
        static let stackSpacing: CGFloat = 4
        static let horizontalSpacing: CGFloat = 12
        static let lineHeightMultiply: CGFloat = 1.25
        static let spacing: CGFloat = 12
        static let lineHeight: CGFloat = 24
        static let lightBlack = UIColor.black.withAlphaComponent(0.4)
        static let actionButtonWidthMultiplier: CGFloat = 0.1
        static let supportLabelWidthMultiplier: CGFloat = 0.1
        static let supportLabelRightOffset: CGFloat = 4.0
        static let pointSupportLabelWidthMultiplier: CGFloat = 0.07
        static let signSize = CGSize(width: 120, height: 40)
    }
}
