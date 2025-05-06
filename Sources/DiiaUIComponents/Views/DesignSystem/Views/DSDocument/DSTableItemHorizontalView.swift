import UIKit
import SwiftMessages

/// design_system_code: tableItemHorizontalMlc

public class DSTableItemHorizontalView: BaseCodeView {
    
    private let iconView = UIButton()
    private let supportLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let detailsLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let valueLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let valueDetailsLabel = UILabel().withParameters(font: FontBook.usualFont)
    
    private lazy var titleStack = UIStackView.create(views: [titleLabel, detailsLabel])
    private lazy var valueStack = UIStackView.create(views: [valueLabel, valueDetailsLabel])
    private lazy var stack = UIStackView.create(.horizontal,
                                                views: [supportLabel, titleStack, valueStack, iconView],
                                                spacing: Constants.bigStackSpacing,
                                                alignment: .top)
    
    private var supportProportionConstraint: NSLayoutConstraint?
    private var proportionConstraint: NSLayoutConstraint?
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        titleLabel.textAlignment = .left
        valueLabel.textAlignment = .left
        addSubview(stack)
        stack.fillSuperview()
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        valueStack.alignment = .leading
        
        iconView.withSize(Constants.buttonSize)
        
        setupUI()
    }
    
    public func configure(item: DSTableItemHorizontalMlc) {
        iconView.isHidden = item.icon == nil
        if let icon = item.icon {
            iconView.setImage(UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: icon.code)?.withRenderingMode(.alwaysTemplate),
                              for: .normal)
            iconView.addTarget(self, action: #selector(copyValue), for: .touchUpInside)
            iconView.accessibilityTraits = .button
        }
        iconView.tintColor = .black
        
        titleLabel.attributedText = item.label.attributed(font: titleLabel.font,
                                                          lineHeightMultiple: Constants.lineHeightMultiply,
                                                          lineBreakMode: .byWordWrapping)
        detailsLabel.attributedText = item.secondaryLabel?.attributed(font: titleLabel.font,
                                                                      color: Constants.lightBlackColor,
                                                                      lineHeightMultiple: Constants.lineHeightMultiply,
                                                                      lineBreakMode: .byWordWrapping)
        valueLabel.attributedText = item.value?.attributed(font: titleLabel.font,
                                                           lineHeightMultiple: Constants.lineHeightMultiply,
                                                           lineBreakMode: .byWordWrapping)
        
        valueDetailsLabel.attributedText = item.secondaryValue?.attributed(font: titleLabel.font,
                                                                           color: Constants.lightBlackColor,
                                                                           lineHeightMultiple: Constants.lineHeightMultiply,
                                                                           lineBreakMode: .byWordWrapping)
        supportLabel.attributedText = item.supportingValue?.attributed(font: titleLabel.font,
                                                                       lineHeightMultiple: Constants.lineHeightMultiply,
                                                                       textAlignment: .right,
                                                                       lineBreakMode: .byWordWrapping)
        titleLabel.isHidden = item.label.isEmpty
        valueLabel.isHidden = item.value == nil
        detailsLabel.isHidden = item.secondaryLabel == nil
        valueDetailsLabel.isHidden = item.secondaryValue == nil
        supportLabel.isHidden = item.supportingValue == nil
    }
    
    public func setDetailsLabelAlignment(_ textAlignment: NSTextAlignment) {
        detailsLabel.textAlignment = textAlignment
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
        valueLabel.withParameters(font: valueFont)
        
        detailsLabel.withParameters(font: detailsFont, textColor: detailsColor)
        valueDetailsLabel.withParameters(font: valueDetailsFont, textColor: detailsColor)
        
        proportionConstraint?.isActive = false
        proportionConstraint = titleStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: iconImage == nil ? titleProportion : Constants.smallTitleProportion)
        proportionConstraint?.isActive = true
        
        supportProportionConstraint?.isActive = false
        supportProportionConstraint = supportLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.iconProportion)
        supportProportionConstraint?.isActive = true
        
        titleLabel.numberOfLines = numberOfLines
        valueLabel.numberOfLines = numberOfLines
        
        if numberOfLines == 1 {
            titleLabel.minimumScaleFactor = Constants.minTextScaleFactor
            valueLabel.minimumScaleFactor = Constants.minTextScaleFactor
            valueLabel.adjustsFontSizeToFitWidth = true
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        
        return self
    }
    
    @objc private func copyValue() {
        guard let resource = valueLabel.text else { return }
        UIPasteboard.general.string = resource
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        SwiftMessages.showSuccessMessage(message: R.Strings.general_number_copied.localized())
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
