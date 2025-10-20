
import UIKit

public class ExpandableContentView: BaseCodeView {
    private let stack = UIStackView.create(spacing: 16)
    private let expandableHeader = ExpandableHeaderView()
    private var subview: UIView?

    public override func setupSubviews() {
        backgroundColor = .clear
        addSubview(stack)
        stack.fillSuperview()
    }
    
    public func configure(title: String, subview: UIView, titleFont: UIFont = FontBook.smallHeadingFont) {
        stack.safelyRemoveArrangedSubviews()
        self.subview = subview
        stack.addArrangedSubview(expandableHeader)
        stack.addArrangedSubview(subview)
        subview.isHidden = true
        expandableHeader.configure(title: title,
                                   isOpened: false,
                                   onChange: { [weak self] in
            self?.subview?.isHidden.toggle()
            self?.expandableHeader.setOpened(isOpened: self?.subview?.isHidden == false)
        })
        expandableHeader.configureUI(titleFont: titleFont)
    }
}
