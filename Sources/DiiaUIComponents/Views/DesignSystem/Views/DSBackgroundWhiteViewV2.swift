
import DiiaCommonTypes
import UIKit

/// design_system_code: backgroundWhiteOrgV2
public final class DSBackgroundWhiteViewV2: BaseCodeView {
    private let inputFieldsStack = UIStackView.create()
    
    private var viewFabric = DSViewFabric.instance
    
    public override func setupSubviews() {
        super.setupSubviews()
        
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = .white
        
        addSubview(inputFieldsStack)
        inputFieldsStack.fillSuperview()
    }
    
    public func configure(for model: DSBackgroundWhiteViewModel) {
        accessibilityIdentifier = model.componentId
        inputFieldsStack.safelyRemoveArrangedSubviews()
        
        for subview in model.items {
            if let subview = viewFabric.makeView(from: subview,
                                                 withPadding: .default,
                                                 eventHandler: model.eventHandler) {
                self.inputFieldsStack.addArrangedSubview(subview)
            }
        }
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
}

extension DSBackgroundWhiteViewV2 {
    enum Constants {
        static let cornerRadius: CGFloat = 16
    }
}
