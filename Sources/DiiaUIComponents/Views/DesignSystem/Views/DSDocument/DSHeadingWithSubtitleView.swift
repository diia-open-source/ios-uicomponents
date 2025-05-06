import UIKit

/// design_system_code: headingWithSubtitlesMlc

public class DSHeadingWithSubtitleView: BaseCodeView {
    private lazy var headingLabel: UILabel = {
        let label = UILabel().withParameters(
            font: Constants.headingFont,
            numberOfLines: Constants.headerNumberOfLines,
            lineBreakMode: .byClipping
        )
        label.minimumScaleFactor = Constants.minimumScaleFactor
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var stackView: UIStackView = UIStackView.create(views: [], spacing: Constants.stackSpacing)
    private var subLabels = [UILabel]()
    
    public override func setupSubviews() {
        addSubview(stackView)
        stackView.fillSuperview()
        stackView.addArrangedSubview(headingLabel)
        
        headingLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        headingLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    public func configure(model: DSHeadingWithSubtitlesModel) {
        headingLabel.text = model.value
        subLabels = []
        model.subtitles?.forEach({
            self.stackView.addArrangedSubview(self.subtitleLabel(text: $0))
        })
    }
    
    public func setupUI(textColor: UIColor, font: UIFont) {
        subLabels.forEach({$0.textColor = textColor})
        headingLabel.textColor = textColor
        headingLabel.font = font
    }
    
    private func subtitleLabel(text: String) -> UILabel {
        let label = UILabel()
        let attributed = text.attributed(font: FontBook.bigText,
                                         lineHeightMultiple: Constants.lineMultiplyHeight,
                                         lineHeight: Constants.lineTitleHeight)
        label.attributedText = attributed
        label.numberOfLines = 0
        
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        subLabels.append(label)
        return label
    }
}

extension DSHeadingWithSubtitleView {
    enum Constants {
        static let headerNumberOfLines: Int = 3
        static let lineMultiplyHeight: CGFloat = 0.95
        static let lineTitleHeight: CGFloat = 24
        static let lineSubtitleHeight: CGFloat = 16
        static let minimumScaleFactor: CGFloat = 0.2
        static let stackSpacing: CGFloat = 16
        static var headingFont: UIFont = {
            switch UIScreen.main.bounds.width {
            case 414, 428, 430:
                return FontBook.mainFont.regular.size(24)
            case 320:
                return FontBook.mainFont.regular.size(17)
            default:
                return FontBook.mainFont.regular.size(21)
            }
        }()
    }
}
