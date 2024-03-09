import UIKit
import SwiftMessages

public class DSTablePrimaryItemView: BaseCodeView {
    
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont, numberOfLines: 0)
    private let subtitleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont, numberOfLines: 0)
    private let iconView: UIImageView = .init(image: UIImage(named: Constants.iconName)?
        .withRenderingMode(.alwaysTemplate))
        .withSize(Constants.iconSize)
    private let verticalStackView = UIStackView.create(views: [], spacing: Constants.spacing)
    private let horizontalStackView = UIStackView.create(.horizontal, views: [], spacing: Constants.spacing, alignment: .bottom)
    
    // MARK: Life cycle
    public override func setupSubviews() {
        super.setupSubviews()
        setupViews()
    }
    
    // MARK: Setup
    
    public func configure(for title: String, value: String, withIcon: Bool) {
        titleLabel.text = title
        subtitleLabel.text = value
        iconView.isHidden = !withIcon
    }
    
    public func configure(for model: DSTableItemPrimaryMlc, withIcon: Bool) {
        titleLabel.text = model.label
        subtitleLabel.text = model.value
        iconView.isHidden = !withIcon
    }
    
    public func configure(for model: DSTableItemPrimaryMlc) {
        titleLabel.text = model.label
        iconView.isHidden = model.icon == nil
        if let icon = model.icon {
            iconView.image = UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: icon.code)
        }
        subtitleLabel.text = model.value
    }
    
    // MARK: Private methods
    private func setupViews() {
        addSubview(horizontalStackView)
        horizontalStackView.fillSuperview()
        verticalStackView.addArrangedSubviews([titleLabel, subtitleLabel])
        horizontalStackView.addArrangedSubviews([verticalStackView, iconView])
        
        iconView.tintColor = .black
        iconView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(copyValue))
        tapGestureRecognizer.numberOfTapsRequired = 1
        iconView.addGestureRecognizer(tapGestureRecognizer)
        layoutIfNeeded()
        
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        subtitleLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    @objc private func copyValue() {
        guard let value = subtitleLabel.text else { return }
        UIPasteboard.general.string = value
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        showSuccessMessage(message: R.Strings.general_number_copied.localized())
    }
    
    private func showSuccessMessage(message: String) {
        let messageView = MessageView.viewFromNib(layout: .statusLine)
        messageView.configureTheme(backgroundColor: .init(Constants.messageViewColor), foregroundColor: .black)
        messageView.configureContent(body: message)
        messageView.titleLabel?.text = nil
        messageView.button?.setTitle(nil, for: .normal)
        messageView.button?.backgroundColor = .clear
        messageView.button?.tintColor = .clear
        SwiftMessages.show(view: messageView)
    }
}

extension DSTablePrimaryItemView {
    private enum Constants {
        static let iconSize: CGSize = .init(width: 24, height: 24)
        static let spacing: CGFloat = 8
        static let iconName = "copyIcon"
        static let messageViewColor = "#65C680"
    }
}
