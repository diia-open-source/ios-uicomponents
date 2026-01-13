
import UIKit
import DiiaCommonTypes

public struct DSDividerLineModel: Codable {
    public let componentId: String?
    public let type: String?
    
    public init(componentId: String?, type: String?) {
        self.componentId = componentId
        self.type = type
    }
}

/// design_system_code: dividerLineMlc
public final class DSDividerLineView: BaseCodeView {
    private var heightConstraint: NSLayoutConstraint?

    public override func setupSubviews() {
        setupUI()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func configure(with model: DSDividerLineModel) {
        accessibilityIdentifier = model.componentId
    }
    
    public func setupUI(
        height: CGFloat = 2.0,
        color: UIColor = .init(AppConstants.Colors.separatorColor)
    ) {
        heightConstraint?.isActive = false
        heightConstraint = self.heightAnchor.constraint(equalToConstant: height)
        heightConstraint?.isActive = true
        
        backgroundColor = color
    }
}
