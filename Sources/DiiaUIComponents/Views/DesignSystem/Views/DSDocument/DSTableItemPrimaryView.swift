import UIKit
import SwiftMessages

/// design_system_code: tableItemPrimaryMlc

public class DSTableItemPrimaryView: BaseCodeView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let iconButtonView = UIButton()
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        let valueIconStack = UIStackView.create(.horizontal,
                                                views: [valueLabel, iconButtonView, UIView()],
                                                spacing: Constants.stackSpacing,
                                                alignment: .center)
        stack([titleLabel, valueIconStack], spacing: Constants.stackSpacing)
        
        iconButtonView.withSize(Constants.imageSize)
        
        setupView()
    }
    
    public func configure(model: DSTableItemPrimaryMlc) {
        titleLabel.text = model.label
        valueLabel.text = model.value
        
        iconButtonView.isHidden = model.icon == nil
        
        if let iconName = model.icon?.code {
            iconButtonView.setImage(UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: iconName), for: .normal)
        }
    }
    
    private func setupView() {
        titleLabel.font = FontBook.usualFont
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .black
        valueLabel.font = FontBook.numbersHeadingFont
        valueLabel.numberOfLines = 1
        valueLabel.textColor = .black
        
        iconButtonView.addTarget(self, action: #selector(actionRecognizer), for: .touchUpInside)
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
        showSuccessMessage(message: R.Strings.general_number_copied.localized())
    }
    
    private func showSuccessMessage(message: String) {
        let messageView = MessageView.viewFromNib(layout: .statusLine)
        messageView.configureTheme(backgroundColor: .init(Constants.messageViewColor),
                                   foregroundColor: .black)
        messageView.configureContent(body: message)
        messageView.titleLabel?.text = nil
        messageView.button?.setTitle(nil, for: .normal)
        messageView.button?.backgroundColor = .clear
        messageView.button?.tintColor = .clear
        SwiftMessages.show(view: messageView)
    }
    
}

extension DSTableItemPrimaryView {
    enum Constants {
        static let messageViewColor = "#65C680"
        static let stackSpacing: CGFloat = 8
        static let imageSize = CGSize(width: 32, height: 32)
    }
}
