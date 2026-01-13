
import UIKit
import DiiaCommonTypes

/// design_system_code: btnLinkAtm
public final class DSLinkButton: UIButton {
    public var onClick: Callback?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        self.backgroundColor = .clear
        self.setTitleColor(.black, for: .normal)
        self.layer.borderColor = UIColor.black.cgColor
        self.addTarget(self, action: #selector(onTouch), for: .touchUpInside)
    }
    
    // MARK: - Public Methods
    public func setTitle(_ title: String) {
        let underlineAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.underlineColor: UIColor.black,
            NSAttributedString.Key.font: FontBook.statusFont,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        let attributedString = NSMutableAttributedString(
            string: title,
            attributes: underlineAttributes)
        self.setAttributedTitle(attributedString, for: .normal)
        self.setAttributedTitle(attributedString, for: .highlighted)
    }

    // MARK: - Actions
    @objc private func onTouch() {
        self.onClick?()
    }
}
