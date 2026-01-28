
import UIKit

public struct DSBtnAddOptionAtm: Codable {
    public let componentId: String
    public let label: String
    public let description: String?
    public let iconLeft: DSIconModel?
    public let state: DSButtonState?
    public let action: DSActionParameter?
}

///ds_code: btnAddOptionAtm
final public class DSBtnAddOptionAtmView: BaseCodeView {
    private let mainHStack = UIStackView.create(.horizontal, spacing: Constants.spacing, alignment: .center)
    private let labelDescriptionStack = UIStackView.create(.vertical, spacing: Constants.smallSpacing)
    private let textLabel = UILabel().withParameters(font: Constants.textLabelFont)
    private let descriptionLabel = UILabel().withParameters(font: Constants.descriptionLabelFont, textColor: Constants.descriptionLabelTextColor)
    private let addButton = DSIconView()
    
    public override func setupSubviews() {
        addSubview(mainHStack)
        mainHStack.fillSuperview(padding: Constants.paddings)
        mainHStack.addArrangedSubviews([
            addButton,
            labelDescriptionStack,
            UIView()
        ])
        labelDescriptionStack.addArrangedSubviews([
            textLabel,
            descriptionLabel
        ])
        self.layer.cornerRadius = Constants.cornerRadius
        self.backgroundColor = .white
    }
    
    public func configure(with model: DSBtnAddOptionAtm, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        accessibilityIdentifier = model.componentId
        textLabel.text = model.label

        descriptionLabel.isHidden = model.description == nil
        descriptionLabel.text = model.description

        addButton.isHidden = model.iconLeft == nil
        if let iconLeft = model.iconLeft {
            addButton.setIcon(iconLeft)
        }
        
        if let action = model.action {
            self.tapGestureRecognizer {
                eventHandler(.action(action))
            }
        }
        
        switch model.state {
        case .disabled:
            isUserInteractionEnabled = false
            alpha = Constants.disabledAlpha
        default:
            isUserInteractionEnabled = true
            alpha = Constants.defaultAlpha
        }
    }
}

private extension DSBtnAddOptionAtmView {
    enum Constants {
        static let paddings: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let textLabelFont = FontBook.usualFont.withSize(14)
        static let descriptionLabelFont = FontBook.usualFont.withSize(12)
        static let descriptionLabelTextColor: UIColor = .black.withAlphaComponent(0.54)
        static let spacing: CGFloat = 16
        static let smallSpacing: CGFloat = 4
        static let cornerRadius: CGFloat = 16
        static let defaultAlpha: CGFloat = 1
        static let disabledAlpha: CGFloat = 0.5
    }
}
