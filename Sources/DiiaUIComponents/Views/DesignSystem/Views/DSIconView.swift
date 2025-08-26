
import UIKit
import DiiaCommonTypes

/// design_system_code: iconAtm
public class DSIconView: BaseCodeView {
    private let imageView = UIImageView()
    private var model: DSIconModel?

    var onClick: ((DSActionParameter?) -> Void)?

    // MARK: - Init
    public override func setupSubviews() {
        backgroundColor = .clear
        addSubview(imageView)
        imageView.fillSuperview()
        addTapGestureRecognizer()
    }

    // MARK: - Private
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(tap)
    }

    @objc private func onTap() {
        onClick?(model?.action)
    }

    // MARK: - Public Methods
    public func setIcon(_ icon: DSIconModel) {
        self.model = icon
        self.isUserInteractionEnabled = icon.action != nil

        accessibilityIdentifier = icon.componentId
        accessibilityLabel = icon.accessibilityDescription
        
        imageView.image = UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: icon.code)
    }
    
    public func setIcon(_ iconCode: String) {
        imageView.image = UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: iconCode)
        self.isUserInteractionEnabled = false
    }
}
