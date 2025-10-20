import UIKit

///DS_code: textItemVerticalMlc
public struct DSTextItemVerticalMlc: Codable {
    public let componentId: String
    public let label: String
    public let value: String
    public let iconRight: DSIconModel?
    
    public init(componentId: String, label: String, value: String, iconRight: DSIconModel?) {
        self.componentId = componentId
        self.label = label
        self.value = value
        self.iconRight = iconRight
    }
}

public class TextItemVerticalMlcView: BaseCodeView {

    private let stackView = UIStackView.create(spacing: Constants.smallSpacing)
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont, numberOfLines: 1)
    private let valueLabel = UILabel().withParameters(font: FontBook.usualFont, numberOfLines: 1)
    private let valueConainer = UIView()
    private let iconView = UIImageView()

    public override func setupSubviews() {
        addSubview(stackView)
        stackView.fillSuperview()
        valueConainer.addSubview(valueLabel)
        valueLabel.fillSuperview(padding: Constants.valuePadding)
        valueConainer.backgroundColor = .blackSqueeze
        valueConainer.layer.cornerRadius = Constants.cornerRadius
        iconView.withSize(Constants.iconSize)
        
        let horizontalStack = UIStackView.create(.horizontal, views: [valueConainer, iconView], spacing: Constants.spacing, alignment: .center)
        
        stackView.addArrangedSubviews([titleLabel, horizontalStack])
    }
    
    public func configure(model: DSTextItemVerticalMlc) {
        accessibilityIdentifier = model.componentId
        titleLabel.text = model.label
        valueLabel.text = model.value
        iconView.isHidden = model.iconRight == nil
        if let icon = model.iconRight {
            iconView.image = UIComponentsConfiguration.shared.imageProvider?.imageForCode(
                imageCode: icon.code)
            iconView.accessibilityIdentifier = icon.componentId
        }
    }
}

private extension TextItemVerticalMlcView {
    enum Constants {
        static let smallSpacing: CGFloat = 4
        static let spacing: CGFloat = 8
        static let cornerRadius: CGFloat = 4
        static let iconSize = CGSize(width: 24, height: 24)
        static let valuePadding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
