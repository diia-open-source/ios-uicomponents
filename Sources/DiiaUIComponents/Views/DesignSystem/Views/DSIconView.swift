
import UIKit
import DiiaCommonTypes

/// design_system_code: iconAtm
public class DSIconView: BaseCodeView {
    private let imageView = UIImageView()
    private var model: DSIconModel?

    var onClick: ((DSActionParameter?) -> Void)?
    
    public enum TappableArea {
        case natural
        case expanded(size: CGSize)
        case superviewBounds
    }
    
    public var tapArea: TappableArea = .natural
    
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
    
    //MARK: - Tap Area
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        switch tapArea {
        case .natural:
            return super.point(inside: point, with: event)
        case .expanded(let size):
            let targetWidth = max(bounds.width,  size.width)
            let targetHeight = max(bounds.height, size.height)
            let horizontalInset = (targetWidth - bounds.width) * 0.5
            let verticalInset = (targetHeight - bounds.height) * 0.5
            let expandedBounds = bounds.insetBy(dx: -horizontalInset, dy: -verticalInset)
            return expandedBounds.contains(point)
        case .superviewBounds:
            guard let superview = superview else {
                return super.point(inside: point, with: event)
            }
            let pointInSuperview = convert(point, to: superview)
            return superview.bounds.contains(pointInSuperview)
        }
    }
}
