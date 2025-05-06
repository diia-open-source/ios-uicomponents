
import UIKit
import DiiaCommonTypes

public class ActionLoadingStateButton: LoadingStateButton {
    public var onClick: Callback?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    
    @objc private func click() {
        onClick?()
    }
}
