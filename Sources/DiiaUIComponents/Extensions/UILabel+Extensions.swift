import UIKit

public extension UILabel {
    func setTextWithCurrentAttributes(text: String, font: UIFont? = nil, lineHeightMultiple: CGFloat? = nil, lineHeight: CGFloat? = nil, lineSpacing: CGFloat? = nil, forceNeedLayout: Bool = false) {
        self.attributedText = text.attributed(
            font: font ?? self.font,
            color: textColor,
            backgroundColor: backgroundColor ?? .clear,
            lineHeightMultiple: lineHeightMultiple,
            lineHeight: lineHeight,
            lineSpacing: lineSpacing,
            textAlignment: textAlignment,
            lineBreakMode: lineBreakMode
        )
        setNeedsLayout()
        if forceNeedLayout { layoutIfNeeded() }
    }
    
    @discardableResult
    func withParameters(font: UIFont, textColor: UIColor = .black, numberOfLines: Int = 0, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> UILabel {
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        self.lineBreakMode = lineBreakMode
        
        return self
    }
}

extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let font = self.font ?? UIFont.systemFont(ofSize: 12)
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        
        return Int(ceil(textHeight / lineHeight))
    }
}
