
import UIKit

/// design_system_code: alertCardMlc
public struct DSAlertCardMlc: Codable {
    public let icon: String?
    public let label: String
    public let text: String
    public let btnAlertAdditionalAtm: DSButtonModel?
    
    public init(icon: String? = nil, label: String, text: String, btnAlertAdditionalAtm: DSButtonModel?) {
        self.icon = icon
        self.label = label
        self.text = text
        self.btnAlertAdditionalAtm = btnAlertAdditionalAtm
    }
}

public final class DSAlertCardMlcView: BaseCodeView {
    private let iconLabel: UILabel = UILabel().withParameters(font: FontBook.detailsTitleHeadFont)
    private let topLabel: UILabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let secondaryLabel: UILabel = UILabel().withParameters(font: FontBook.usualFont)
    private let button = ActionButton()
    
    override public func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        let stack = UIStackView.create(views: [iconLabel, topLabel, secondaryLabel, button], spacing: Constants.stackSpacing, alignment: .center)
        addSubview(stack)
        stack.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: Constants.stackPadding)
        iconLabel.textAlignment = .center
        topLabel.textAlignment = .center
        secondaryLabel.textAlignment = .center
        
        button.titleLabel?.font = FontBook.usualFont
        button.backgroundColor = .init(Constants.backgroundColor)
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.contentEdgeInsets = Constants.buttonInsets
        button.withHeight(Constants.buttonHeight)
        stack.setCustomSpacing(Constants.buttonSpacing, after: secondaryLabel)
    }
    
    public func configure(model: DSAlertCardMlc, action: @escaping (DSActionParameter) -> Void) {
        iconLabel.text = model.icon
        iconLabel.isHidden = model.icon == nil
        topLabel.text = model.label
        secondaryLabel.text = model.text
        button.isHidden = model.btnAlertAdditionalAtm == nil
        button.action = .init(title: model.btnAlertAdditionalAtm?.label, iconName: nil, callback: {
            if let actionParam = model.btnAlertAdditionalAtm?.action {
                action(actionParam)
            }
        })
    }
}

private extension DSAlertCardMlcView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let stackSpacing: CGFloat = 8
        static let stackPadding: UIEdgeInsets = .init(top: 16, left: 16, bottom: 24, right: 16)
        static let buttonInsets: UIEdgeInsets = .init(top: 10, left: 20, bottom: 10, right: 20)
        static let backgroundColor: String = "#EC0312"
        static let buttonCornerRadius: CGFloat = 18
        static let buttonHeight: CGFloat = 36
        static let buttonSpacing: CGFloat = 16
    }
}
