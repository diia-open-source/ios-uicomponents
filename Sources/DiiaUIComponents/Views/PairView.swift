import UIKit

public class PairView: BaseCodeView {
    private let stack = UIStackView()
    private let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let detailsLabel = UILabel().withParameters(font: FontBook.usualFont)
    
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
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(detailsLabel)
        
        setupUI()
    }
    
    public func configure(title: String, details: String) {
        titleLabel.text = title
        detailsLabel.text = details
        
        layoutIfNeeded()
    }
    
    public func configure(attributedTitle: NSAttributedString, attributedDetails: NSAttributedString) {
        titleLabel.attributedText = attributedTitle
        detailsLabel.attributedText = attributedDetails
        
        layoutIfNeeded()
    }
    
    public func setDetailsLabelAlignment(_ textAlignment: NSTextAlignment) {
        detailsLabel.textAlignment = textAlignment
    }
    
    public func setupUI(titleFont: UIFont = FontBook.usualFont,
                        detailsFont: UIFont = FontBook.usualFont,
                        titleProportion: CGFloat = 0.4,
                        titleColor: UIColor = .black,
                        detailsColor: UIColor = .black,
                        spacing: CGFloat = 16) {
        titleLabel.withParameters(font: titleFont, textColor: titleColor)
        detailsLabel.withParameters(font: detailsFont, textColor: detailsColor)
        
        proportionConstraint?.isActive = false
        proportionConstraint = detailsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: (1 - titleProportion))
        proportionConstraint?.isActive = true
        stack.spacing = spacing
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
