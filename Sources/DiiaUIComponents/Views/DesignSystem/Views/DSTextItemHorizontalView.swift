
import UIKit

public struct DSTextItemHorizontalModel: Codable {
    public let componentId: String
    public let label: String
    public let value: String
    
    public init(componentId: String, label: String, value: String) {
        self.componentId = componentId
        self.label = label
        self.value = value
    }
}

//ds_code: textItemHorizontalMlc
final class DSTextItemHorizontalView: BaseCodeView {
    
    private let mainStack = UIStackView.create(.horizontal, alignment: .center)
    private let labelValueStack = UIStackView.create(.horizontal, spacing: Constants.spacing, alignment: .center)
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .black)
    private let valueLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .black)
    private let valueContainer = UIView()
    private let spacerView = UIView()
    
    override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
        
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
        ])
        
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        withHeight(Constants.height)
        
        setupAccessibility()
    }
    
    public func configure(with model: DSTextItemHorizontalModel) {
        accessibilityIdentifier = model.componentId
        
        titleLabel.text = model.label
        valueLabel.text = model.value
        
        labelValueStack.accessibilityLabel = [model.label, model.value].compactMap({ $0 }).joined(separator: .empty)
    }
    
    // MARK: - Private
    private func setupAccessibility() {
        labelValueStack.isAccessibilityElement = true
        labelValueStack.accessibilityTraits = .staticText
    }
}

private extension DSTextItemHorizontalView {
    enum Constants {
        static let spacing: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let valueContainerColor: UIColor = .init("#E2ECF4")
        static let height: CGFloat = 34
        static let valuePaddings: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
    }
}
