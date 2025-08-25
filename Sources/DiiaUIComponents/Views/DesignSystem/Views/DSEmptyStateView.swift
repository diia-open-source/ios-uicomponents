
import UIKit

public struct DSEmptyStateMlc: Codable {
    public let componentId: String
    public let iconAtm: DSIconModel?
    public let title: String?
    public let text: String?
    
    public init(componentId: String, iconAtm: DSIconModel?, title: String?, text: String?) {
        self.componentId = componentId
        self.iconAtm = iconAtm
        self.title = title
        self.text = text
    }
}

//ds_code: emptyStateMlc
final public class DSEmptyStateView: BaseCodeView {
    private let mainStack = UIStackView.create(.vertical,spacing: Constants.smallSpacing, alignment: .center)
    private let iconLabelStack = UIStackView.create(.vertical,spacing: Constants.bigSpacing, alignment: .center)
    private let titleLabel = UILabel().withParameters(font: FontBook.documentNumberHeadingFont, textColor: .black)
    private let textLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .black)
    private let iconView = DSIconView().withSize(Constants.iconSize)
    
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.paddings)
        iconLabelStack.addArrangedSubviews([
            iconView,
            titleLabel
        ])
        mainStack.addArrangedSubviews([
            iconLabelStack,
            textLabel
        ])
        textLabel.textAlignment = .center
        self.layer.cornerRadius = Constants.cornerRadius
        self.withBorder(width: Constants.borderWidth, color: Constants.borderColor)
    }
    
    public func configure(with model: DSEmptyStateMlc) {
        self.accessibilityIdentifier = model.componentId
        
        iconLabelStack.isHidden = model.iconAtm == nil && model.title == nil
        iconView.isHidden = model.iconAtm == nil
        if let iconAtm = model.iconAtm {
            iconView.setIcon(iconAtm)
        }
        
        titleLabel.isHidden = model.title == nil
        titleLabel.text = model.title
        
        textLabel.isHidden = model.text == nil
        textLabel.text = model.text
    }
}

private extension DSEmptyStateView {
    enum Constants {
        static let smallSpacing: CGFloat = 8
        static let bigSpacing: CGFloat = 16
        static let iconSize: CGSize = .init(width: 32, height: 32)
        static let paddings: UIEdgeInsets = .init(top: 24, left: 32, bottom: 24, right: 32)
        static let cornerRadius: CGFloat = 24
        static let borderWidth: CGFloat = 2
        static let borderColor: UIColor = .init("#FFFFFF")
    }
}
