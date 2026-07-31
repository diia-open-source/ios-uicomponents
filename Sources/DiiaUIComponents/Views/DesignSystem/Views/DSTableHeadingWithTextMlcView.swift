
import UIKit

public struct DSTableHeadingWithTextMlc: Codable {
    public let componentId: String
    public let heading: String
    public let text: String?
    public let iconLeft: DSIconModel?
}

public final class DSTableHeadingWithTextMlcView: BaseCodeView {
    private let headingLabel = UILabel().withParameters(
        font: FontBook.bigText.withSize(Constants.headingLabelTextSize),
        textColor: .black,
        numberOfLines: 0)
    private let textLabel = UILabel().withParameters(
        font: FontBook.usualFont.withSize(Constants.textLabelSize),
        textColor: .black,
        numberOfLines: 0)
    private let leftIcon = DSIconView()
    private let mainStack = UIStackView.create(spacing: Constants.spacing)
    private let horizontalStack = UIStackView.create(.horizontal, spacing: Constants.spacing, alignment: .top)
    
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
        horizontalStack.addArrangedSubviews([leftIcon, headingLabel])
        mainStack.addArrangedSubviews([horizontalStack, textLabel])
        leftIcon.withSize(Constants.iconSize)
    
        headingLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        textLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        backgroundColor = .clear
    }
    
    public func configure(with model: DSTableHeadingWithTextMlc) {
        self.accessibilityIdentifier = model.componentId
        headingLabel.text = model.heading
        
        textLabel.isHidden = model.text == nil
        if let text = model.text {
            textLabel.text = text
        }
        
        self.leftIcon.isHidden = model.iconLeft == nil
        if let leftIcon = model.iconLeft {
            self.leftIcon.setIcon(leftIcon)
        }
    }
}

private extension DSTableHeadingWithTextMlcView {
    enum Constants {
        static let headingLabelTextSize: CGFloat = 14
        static let textLabelSize: CGFloat = 12
        static let spacing: CGFloat = 8
        static let iconSize: CGSize = .init(width: 14, height: 14)
    }
}
