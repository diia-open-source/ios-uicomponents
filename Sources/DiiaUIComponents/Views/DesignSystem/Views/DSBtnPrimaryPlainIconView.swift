
import Foundation
import UIKit

public struct DSBtnPrimaryPlainIconAtm: Codable {
    public let componentId: String?
    public let label: String
    public let state: DSButtonState?
    public let icon: DSIconModel?
    public let action: DSActionParameter?
    
    public init(componentId: String?,
                label: String,
                state: DSButtonState?,
                icon: DSIconModel?,
                action: DSActionParameter?) {
        self.componentId = componentId
        self.label = label
        self.state = state
        self.icon = icon
        self.action = action
    }
}

//MARK: - ds_code: btnPrimaryPlainIconAtm
public final class DSBtnPrimaryPlainIconView: BaseCodeView {
    private let mainHStack = UIStackView.create(.horizontal, spacing: Constants.spacing, alignment: .center)
    private let iconView = DSIconView()
    private let titleLabel = UILabel().withParameters(font: Constants.titleLabelFont, textColor: .white)
    
    //MARK: Lifecycle
    public override func setupSubviews() {
        addSubview(mainHStack)
        mainHStack.translatesAutoresizingMaskIntoConstraints = false
        mainHStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mainHStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconView.withSize(Constants.iconSize)
        self.withHeight(Constants.height)
        mainHStack.addArrangedSubviews([
            iconView,
            titleLabel
        ])
        
        self.layer.cornerRadius = Constants.cornerRadius
        self.backgroundColor = .black
    }
    
    //MARK: Public methods
    public func configure(with model: DSBtnPrimaryPlainIconAtm, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        accessibilityIdentifier = model.componentId
        titleLabel.text = model.label
        
        if let icon = model.icon {
            iconView.setIcon(icon)
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

private extension DSBtnPrimaryPlainIconView {
    enum Constants {
        static let spacing: CGFloat = 8
        static let iconSize = CGSize(width: 20, height: 20)
        static let titleLabelFont = FontBook.usualFont.withSize(12)
        static let paddings = UIEdgeInsets(top: 16, left: 40, bottom: 16, right: 40)
        static let height: CGFloat = 56
        static let cornerRadius: CGFloat = 8
        static let defaultAlpha: CGFloat = 1
        static let disabledAlpha: CGFloat = 0.54
    }
}
