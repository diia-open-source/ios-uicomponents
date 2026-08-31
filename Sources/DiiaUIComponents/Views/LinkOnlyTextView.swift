
import UIKit

public final class LinkOnlyTextView: UITextView {
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureForParametrizedText()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureForParametrizedText()
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let position = closestPosition(to: point),
              let characterRange = tokenizer.rangeEnclosingPosition(position, with: .character, inDirection: .layout(.left)),
              let attributedText = self.attributedText
        else { return false }

        let index = offset(from: beginningOfDocument, to: characterRange.start)
        guard index < attributedText.length else { return false }
        return attributedText.attribute(.link, at: index, effectiveRange: nil) != nil
    }
}
