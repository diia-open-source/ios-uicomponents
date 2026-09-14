
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
        
        for (index, subview) in model.items.enumerated() {
            if let subview = viewFabric.makeView(from: subview,
                                                 withPadding: .default,
                                                 eventHandler: model.eventHandler) {
                self.inputFieldsStack.addArrangedSubview(subview)
                if model.showDivider == true && index < (model.items.count - 1) {
                    self.inputFieldsStack.addArrangedSubview(divider())
                }
            }
        }
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
    
    // MARK: - Private Methods
    private func divider() -> UIView {
        let view = UIView().withHeight(1)
        view.backgroundColor = Constants.dividerColor
        return BoxView(subview: view).withConstraints(insets: Constants.dividerInsets)
    }
}

extension DSBackgroundWhiteViewV2 {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let dividerColor = UIColor("#E2ECF4")
        static let dividerInsets = UIEdgeInsets(horizontal: 16)
    }
}
