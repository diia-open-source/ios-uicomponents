import UIKit
import DiiaCommonTypes

public enum ExpandableHeaderViewState {
    case opened
    case closed
    case loading
}

public class ExpandableHeaderView: BaseCodeView {
    private let expandIcon = UIImageView()
    private let titleLabel = UILabel()
    private var onChange: Callback?

    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(expandIcon)

        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil)
        titleLabel.numberOfLines = 0
        
        expandIcon.image = R.image.expand_plus.image
        expandIcon.anchor(top: nil, leading: titleLabel.trailingAnchor, bottom: nil, trailing: trailingAnchor, size: LocalConstants.expandImageSize)
        expandIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        expandIcon.contentMode = .scaleAspectFit

        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapped))
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
        
        configureUI()
    }
    
    public func configureUI(titleFont: UIFont = FontBook.bigText) {
        titleLabel.withParameters(font: titleFont)
        layoutIfNeeded()
    }
    
    public func configure(title: String, isOpened: Bool = false, onChange: Callback? = nil) {
        titleLabel.text = title
        setOpened(isOpened: isOpened)
        self.onChange = onChange
    }
    
    public func setState(_ state: ExpandableHeaderViewState) {
        isUserInteractionEnabled = state != .loading
        expandIcon.stopRotation()
        
        switch state {
        case .loading:
            expandIcon.image = R.image.receiptsLoading.image
            expandIcon.startRotating()
        case .opened:
            expandIcon.image = R.image.expand_minus.image
        case .closed:
            expandIcon.image = R.image.expand_plus.image
        }
    }
    
    public func setOpened(isOpened: Bool) {
        isOpened ? setState(.opened) : setState(.closed)
    }
    
    @objc private func onTapped() {
        onChange?()
    }
}

private extension ExpandableHeaderView {
    enum LocalConstants {
        static let defaultHorizontalSpacing: CGFloat = 16
        static let defaultVerticalSpacing: CGFloat = 16
        static let expandImageSize = CGSize(width: 24, height: 24)
    }
}
