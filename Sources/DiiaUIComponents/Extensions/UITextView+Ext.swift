
import UIKit

public extension UITextView {
    func configureForParametrizedText(
        backgroundColor: UIColor = .clear,
        isEditable: Bool = false,
        isSelectable: Bool = true,
        isScrollEnabled: Bool = false,
        isUserInteractionEnabled: Bool = true,
        textContainerInset: UIEdgeInsets = .zero,
        lineFragmentPadding: CGFloat = .zero,
        linkTextColor: UIColor = .black
    ) {
        self.linkTextAttributes = [
            .foregroundColor: linkTextColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        self.isEditable = isEditable
        self.isSelectable = isSelectable
        self.isScrollEnabled = isScrollEnabled
        self.backgroundColor = backgroundColor
        self.isUserInteractionEnabled = isUserInteractionEnabled
        self.textContainerInset = textContainerInset
        self.textContainer.lineFragmentPadding = lineFragmentPadding
    }
}
