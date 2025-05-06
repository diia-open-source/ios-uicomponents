
import UIKit
import DiiaCommonTypes

/// design_system_code: iconAtm
public class DSIconView: BaseCodeView {
    private let imageView = UIImageView()
    
    // MARK: - Init
    public override func setupSubviews() {
        backgroundColor = .clear
        addSubview(imageView)
        imageView.fillSuperview()
    }

    // MARK: - Public Methods
    public func setIcon(_ icon: DSIconModel) {
        accessibilityIdentifier = icon.componentId
        accessibilityLabel = icon.accessibilityDescription
        
        imageView.image = UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: icon.code)
    }
    
    public func setIcon(_ iconCode: String) {
        imageView.image = UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: iconCode)
    }
}
