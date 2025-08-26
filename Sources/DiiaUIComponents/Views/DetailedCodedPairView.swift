
import UIKit
import DiiaCommonTypes

public struct DetailedCodedPairModel {
    let code: String?
    let title: String
    let details: String?
    let value: String
    let valueDetails: String?
    
    public init(code: String? = nil,
                title: String,
                details: String? = nil,
                value: String,
                valueDetails: String? = nil,
                callback: Callback? = nil
    ) {
        self.code = code
        self.title = title
        self.details = details
        self.value = value
        self.valueDetails = valueDetails
    }
}

public class DetailedCodedPairView: BaseCodeView {
    private let stack = UIStackView()
    private let codeLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let detailsLabel = UILabel().withParameters(font: FontBook.usualFont)
    public let valueLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let valueDetailsLabel = UILabel().withParameters(font: FontBook.usualFont)
    
    private lazy var titleStack = UIStackView.create(.vertical, views: [titleLabel, detailsLabel], spacing: 4)
    private lazy var valueStack = UIStackView.create(.vertical, views: [valueLabel, valueDetailsLabel], spacing: 4)
    
    private var codeProportionConstraint: NSLayoutConstraint?
    private var proportionConstraint: NSLayoutConstraint?
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        addSubview(stack)
        stack.fillSuperview()
        stack.backgroundColor = .clear
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .top
        stack.spacing = 8
        
        stack.addArrangedSubview(codeLabel)
        stack.addArrangedSubview(titleStack)
        stack.addArrangedSubview(valueStack)
        
        valueStack.alignment = .leading
        
        codeLabel.textAlignment = .right
        
        withUIConfig()
    }
    
    public func configure(pair: DetailedCodedPairModel) {
        codeLabel.text = pair.code
        titleLabel.text = pair.title
        detailsLabel.text = pair.details
        valueLabel.text = pair.value
        valueDetailsLabel.text = pair.valueDetails
        
        detailsLabel.isHidden = pair.details?.count ?? 0 == 0
        valueDetailsLabel.isHidden = pair.valueDetails?.count ?? 0 == 0
        
        layoutIfNeeded()
    }
    
    public func setDetailsLabelAlignment(_ textAlignment: NSTextAlignment) {
        detailsLabel.textAlignment = textAlignment
    }
    
    @discardableResult
    public func withUIConfig(
        codeFont: UIFont = FontBook.usualFont,
        titleFont: UIFont = FontBook.usualFont,
        valueFont: UIFont = FontBook.usualFont,
        detailsFont: UIFont = FontBook.usualFont,
        valueDetailsFont: UIFont = FontBook.usualFont,
        detailsColor: UIColor = .black.withAlphaComponent(0.5),
        codeProportion: CGFloat = 0.1,
        titleProportion: CGFloat = 0.37)
    -> DetailedCodedPairView {
        codeLabel.withParameters(font: codeFont)
        titleLabel.withParameters(font: titleFont)
        valueLabel.withParameters(font: valueFont)
        detailsLabel.withParameters(font: detailsFont, textColor: detailsColor)
        valueDetailsLabel.withParameters(font: valueDetailsFont, textColor: detailsColor)
        
        proportionConstraint?.isActive = false
        proportionConstraint = titleStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: titleProportion)
        proportionConstraint?.isActive = true
        
        codeProportionConstraint?.isActive = false
        codeProportionConstraint = codeLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: codeProportion)
        codeProportionConstraint?.isActive = true
        
        setNeedsLayout()
        layoutIfNeeded()
        
        return self
    }
    
}
