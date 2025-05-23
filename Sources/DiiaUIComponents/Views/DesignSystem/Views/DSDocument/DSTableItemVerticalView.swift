import UIKit
import SwiftMessages

/// design_system_code: tableItemVerticalMlc
public class DSTableItemVerticalView: DSTableItemView {
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    private let mainStack = UIStackView.create(.horizontal, views: [], spacing: Constants.spacing, alignment: .top)
    private let labelStack = UIStackView.create(.horizontal, views: [], alignment: .top)
    private let labelValueStack = UIStackView.create(views: [], spacing: Constants.stackSpacing)
    
    public override func setupSubviews() {
        super.setupSubviews()
        translatesAutoresizingMaskIntoConstraints = false
        labelStack.addArrangedSubviews([label, UIView(), actionButton])
        labelValueStack.addArrangedSubviews([labelStack, subLabel, value, subValue, icon])
        mainStack.addArrangedSubviews([supportLabel, labelValueStack])
        addSubview(mainStack)
        mainStack.fillSuperview()
        icon.heightAnchor.constraint(equalTo: icon.widthAnchor,
                                     multiplier: Constants.signProportion).isActive = true
        setupUI()
    }
    
    public func configure(model: DSTableItemVerticalMlc, image: UIImage? = nil, eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        self.eventHandler = eventHandler
        label.attributedText = model.label?.attributed(font: FontBook.usualFont,
                                                       lineHeightMultiple: Constants.lineHeightMultiply,
                                                       lineHeight: Constants.lineHeight,
                                                       lineBreakMode: .byWordWrapping)
        subLabel.attributedText = model.secondaryLabel?.attributed(font: FontBook.usualFont,
                                                                   color: Constants.lightBlack,
                                                                   lineHeightMultiple: Constants.lineHeightMultiply,
                                                                   lineHeight: Constants.lineHeight,
                                                                   lineBreakMode: .byWordWrapping)
        value.attributedText = model.value?.attributed(font: FontBook.usualFont,
                                                       lineHeightMultiple: Constants.lineHeightMultiply,
                                                       lineHeight: Constants.lineHeight,
                                                       lineBreakMode: .byWordWrapping)
        
        subValue.attributedText = model.secondaryValue?.attributed(font: FontBook.usualFont,
                                                                   color: Constants.lightBlack,
                                                                   lineHeightMultiple: Constants.lineHeightMultiply,
                                                                   lineHeight: Constants.lineHeight,
                                                                   lineBreakMode: .byWordWrapping)
        supportLabel.attributedText = model.supportingValue?.attributed(font: FontBook.usualFont,
                                                                        lineHeightMultiple: Constants.lineHeightMultiply,
                                                                        lineHeight: Constants.lineHeight,
                                                                        textAlignment: .right,
                                                                        lineBreakMode: .byWordWrapping)
        
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        subLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        subLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        value.setContentCompressionResistancePriority(.required, for: .horizontal)
        value.setContentHuggingPriority(.required, for: .horizontal)
        
        subValue.setContentCompressionResistancePriority(.required, for: .horizontal)
        subValue.setContentHuggingPriority(.required, for: .horizontal)
        
        supportLabel.isHidden = model.supportingValue == nil
        label.isHidden = model.label == nil
        subLabel.isHidden = model.secondaryLabel == nil
        value.isHidden = model.value == nil
        subValue.isHidden = model.secondaryValue == nil
        icon.isHidden = image == nil
        actionButton.isHidden = model.icon == nil || value.isHidden
        
        if let icon = model.icon, let action = icon.action {
            actionButton.action = .init(image: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: icon.code), callback: { [weak self] in
                self?.handleClick(action: action)
            })
        }
        
        self.icon.image = image?.imageByMakingWhiteBackgroundTransparent()?.scaled(forFittingSize: Constants.signSize,
                                                                                   scale: UIScreen.main.scale)
        self.icon.contentMode = .left
        
        if !supportLabel.isHidden {
            supportLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.proportionMultiplier).isActive = true
        }
        if !actionButton.isHidden {
            actionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Constants.proportionMultiplier).isActive = true
        }

        mainStack.layoutIfNeeded()
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
        static let proportionMultiplier: CGFloat = 0.1
        static let signSize = CGSize(width: 120, height: 40)
    }
}
