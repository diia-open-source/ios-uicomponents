
import UIKit

public struct DSTextItemHorizontalModel: Codable {
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

//ds_code: textItemHorizontalMlc
final class DSTextItemHorizontalView: BaseCodeView {
    
    private let mainStack = UIStackView.create(.horizontal, alignment: .center)
    private let labelValueStack = UIStackView.create(.horizontal, spacing: Constants.spacing, alignment: .center)
    private let iconRight = DSIconView()
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .black)
    private let valueLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .black)
    private let valueContainer = UIView()
    private let spacerView = UIView()
    
    override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
        iconRight.withSize(Constants.iconSize)
        
        valueContainer.addSubview(valueLabel)
        valueLabel.fillSuperview(padding: Constants.valuePaddings)
        valueContainer.layer.cornerRadius = Constants.cornerRadius
        valueContainer.backgroundColor = Constants.valueContainerColor
        
        labelValueStack.addArrangedSubviews([
            titleLabel,
            valueContainer
        ])
        
        mainStack.addArrangedSubviews([
            labelValueStack,
            spacerView,
            iconRight
        ])
        
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        withHeight(Constants.height)
    }
    
    public func configure(with model: DSTextItemHorizontalModel) {
        accessibilityIdentifier = model.componentId
        iconRight.isHidden = model.iconRight == nil
        if let iconRight = model.iconRight {
            self.iconRight.setIcon(iconRight)
        }
        titleLabel.text = model.label
        valueLabel.text = model.value
    }
}

private extension DSTextItemHorizontalView {
    enum Constants {
        static let spacing: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let valueContainerColor: UIColor = .init("#E2ECF4")
        static let iconSize: CGSize = .init(width: 24, height: 24)
        static let height: CGFloat = 34
        static let valuePaddings: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    }
}
