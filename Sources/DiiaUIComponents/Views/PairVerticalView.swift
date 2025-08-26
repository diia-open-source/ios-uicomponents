
import UIKit

public struct DocumentItem {
    public let title: String
    public let value: String
    public let isCopyable: Bool
    public let oneLineAligned: Bool
    
    public init(title: String, value: String, isCopyable: Bool = false, oneLineAligned: Bool = false) {
        self.title = title
        self.value = value
        self.isCopyable = isCopyable
        self.oneLineAligned = oneLineAligned
    }
}

public class PairVerticalView: BaseCodeView {
    
    // MARK: - Outlets
    private var stackView: UIStackView?
    private let itemTitle = UILabel().withParameters(font: FontBook.usualFont)
    private let itemValue = UILabel().withParameters(font: FontBook.usualFont)
    
    // MARK: - Properties
    private var lineHeightMultiple: CGFloat?
    
    // MARK: - LifeCycle
    public override func setupSubviews() {
        stackView = stack([itemTitle, itemValue], alignment: .leading)
        setupUI()
    }
    
    // MARK: - Public Methods
    
    public func setup(with item: DocumentItem) {
        configure(with: item.title, value: item.value)
    }
    
    public func configure(with label: String, value: String) {
        if let lineHeightMultiple = lineHeightMultiple {
            itemTitle.setTextWithCurrentAttributes(
                text: label,
                lineHeightMultiple: lineHeightMultiple
            )
            itemValue.setTextWithCurrentAttributes(
                text: value,
                lineHeightMultiple: lineHeightMultiple
            )
        } else {
            itemTitle.text = label
            itemValue.text = value
        }
    }
    
    public func setupUI(titleFont: UIFont = FontBook.usualFont,
                        valueFont: UIFont = FontBook.usualFont,
                        titleColor: UIColor = Constants.titleDefaultColor,
                        valueColor: UIColor = .black,
                        titleNumberOfLines: Int = .zero,
                        valueNumberOfLines: Int = .zero,
                        titleLineBreakMode: NSLineBreakMode = .byWordWrapping,
                        valueLineBreakMode: NSLineBreakMode = .byWordWrapping,
                        stackSpacing: CGFloat = Constants.defaultSpacing,
                        lineHeightMultiple: CGFloat? = nil) {
        itemTitle.text = nil
        itemValue.text = nil
        
        itemTitle.withParameters(font: titleFont, textColor: titleColor, numberOfLines: titleNumberOfLines, lineBreakMode: titleLineBreakMode)
        itemValue.withParameters(font: valueFont, textColor: valueColor, numberOfLines: valueNumberOfLines, lineBreakMode: valueLineBreakMode)
        stackView?.spacing = stackSpacing
        
        self.lineHeightMultiple = lineHeightMultiple
    }
}

// MARK: - Constants
public extension PairVerticalView {
    enum Constants {
        public static let defaultSpacing: CGFloat = 2
        public static let titleDefaultColor: UIColor = .black.withAlphaComponent(0.4)
    }
}
