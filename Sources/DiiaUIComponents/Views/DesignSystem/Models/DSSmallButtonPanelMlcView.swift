
import UIKit

/// design_system_code: smallButtonPanelMlc
public struct DSSmallButtonPanelMlc: Codable {
    public let icon: String?
    public let label: String
    public let secondaryLabel: String?
    public let btnStrokeAdditionalAtm: DSButtonModel
    
    public init(icon: String?, label: String, secondaryLabel: String?, btnStrokeAdditionalAtm: DSButtonModel) {
        self.icon = icon
        self.label = label
        self.secondaryLabel = secondaryLabel
        self.btnStrokeAdditionalAtm = btnStrokeAdditionalAtm
    }
}

public class DSSmallButtonPanelMlcView: BaseCodeView {
    private let topLabel: UILabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let secondaryLabel: UILabel = UILabel().withParameters(font: FontBook.statusFont)
    private let button = ActionLoadingStateButton()
    
    override public func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        let stack = UIStackView.create(views: [topLabel, secondaryLabel], spacing: Constants.stackSpacing)
        addSubview(button)
        addSubview(stack)
        stack.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: button.leadingAnchor, padding: Constants.stackPadding)
        button.titleLabel?.font = FontBook.usualFont
        button.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: Constants.buttonPadding))
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.contentEdgeInsets = Constants.buttonInsets
        button.setStyle(style: .light)
    }
    
    public func configure(model: DSSmallButtonPanelMlc, action: @escaping (DSActionParameter) -> Void) {
        topLabel.text = [model.icon, model.label].compactMap { $0 }.joined(separator: " ")
        secondaryLabel.isHidden = model.secondaryLabel == nil
        secondaryLabel.text = model.secondaryLabel
        button.setLoadingState(model.btnStrokeAdditionalAtm.state == .enabled ? .enabled : .disabled, withTitle: model.btnStrokeAdditionalAtm.label)
        button.onClick = {
            if let actionParam = model.btnStrokeAdditionalAtm.action {
                action(actionParam)
            }
        }
    }
}

private extension DSSmallButtonPanelMlcView {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let stackSpacing: CGFloat = 4
        static let stackPadding: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 8)
        static let buttonInsets: UIEdgeInsets = .init(top: 10, left: 20, bottom: 10, right: 20)
        static let buttonPadding: CGFloat = 16
    }
}
