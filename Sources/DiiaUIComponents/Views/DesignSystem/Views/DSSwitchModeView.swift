
import UIKit
import DiiaCommonTypes

public class DSSwitchModeViewModel {
    public let componentId: String?
    public let primaryIcon: DSIconModel
    public let secondaryIcon: DSIconModel
    public var isFocusedOnPrimaryIcon: Bool
    public var eventHandler: (ConstructorItemEvent) -> Void
    
    public init(
        componentId: String? = nil,
        primaryIcon: DSIconModel,
        secondaryIcon: DSIconModel,
        isFocusedOnPrimaryIcon: Bool = true,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) {
        self.componentId = componentId
        self.primaryIcon = primaryIcon
        self.secondaryIcon = secondaryIcon
        self.isFocusedOnPrimaryIcon = isFocusedOnPrimaryIcon
        self.eventHandler = eventHandler
    }
}

/// design_system_code: switchModeMlc
public class DSSwitchModeView: BaseCodeView {
    
    // MARK: - Subviews
    private let switchContainer = UIView()
    private let primaryIconView = UIImageView()
    private let secondaryIconView = UIImageView()
    
    // MARK: - Properties
    private var viewModel: DSSwitchModeViewModel?
    private var sizeSheme = DSSwitchModeSizeSсheme(size: .zero, borderWidth: Constants.borderWidth)
    
    // MARK: - Init
    public override func setupSubviews() {
        addTapGestureRecognizer()
        addSubview(switchContainer)
        switchContainer.fillSuperview()
        switchContainer.addSubviews([secondaryIconView, primaryIconView])
        
        primaryIconView.layer.cornerRadius = Constants.focusedIconCornerRadius
        primaryIconView.layer.masksToBounds = true
        primaryIconView.layer.borderWidth = Constants.borderWidth
        primaryIconView.layer.borderColor = Constants.borderColor
        
        secondaryIconView.layer.cornerRadius = Constants.unfocusedIconCornerRadius
        secondaryIconView.layer.masksToBounds = true
        secondaryIconView.layer.borderWidth = Constants.borderWidth
        secondaryIconView.layer.borderColor = UIColor.clear.cgColor
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        sizeSheme.size = frame.size
        
        let isFocusedOnPrimaryIcon = viewModel?.isFocusedOnPrimaryIcon ?? true
        primaryIconView.frame = sizeSheme.getPrimaryIconFrame(for: isFocusedOnPrimaryIcon)
        secondaryIconView.frame = sizeSheme.getSecondaryIconFrame(for: !isFocusedOnPrimaryIcon)
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSSwitchModeViewModel) {
        self.viewModel = viewModel
        primaryIconView.image = image(for: viewModel.primaryIcon.code)
        secondaryIconView.image = image(for: viewModel.secondaryIcon.code)
    }
    
    // MARK: - Private Methods
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onSwitch))
        switchContainer.addGestureRecognizer(tap)
        switchContainer.isUserInteractionEnabled = true
    }
    
    private func changeFocus() {
        guard let isFocusedOnPrimaryIcon = viewModel?.isFocusedOnPrimaryIcon else { return }
        primaryIconView.frame = sizeSheme.getPrimaryIconFrame(for: isFocusedOnPrimaryIcon)
        secondaryIconView.frame = sizeSheme.getSecondaryIconFrame(for: !isFocusedOnPrimaryIcon)
        primaryIconView.layer.cornerRadius = isFocusedOnPrimaryIcon ? Constants.focusedIconCornerRadius : Constants.unfocusedIconCornerRadius
        secondaryIconView.layer.cornerRadius = isFocusedOnPrimaryIcon ? Constants.unfocusedIconCornerRadius : Constants.focusedIconCornerRadius
        primaryIconView.layer.borderColor = isFocusedOnPrimaryIcon ? Constants.borderColor : UIColor.clear.cgColor
        secondaryIconView.layer.borderColor = isFocusedOnPrimaryIcon ? UIColor.clear.cgColor : Constants.borderColor
        switchContainer.bringSubviewToFront(isFocusedOnPrimaryIcon ? primaryIconView : secondaryIconView)
    }
    
    private func image(for code: String) -> UIImage? {
        UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: code)
    }
    
    // MARK: - Actions
    @objc private func onSwitch() {
        guard let viewModel = viewModel else { return }
        viewModel.isFocusedOnPrimaryIcon.toggle()
        
        let action = viewModel.isFocusedOnPrimaryIcon ? viewModel.primaryIcon.action : viewModel.secondaryIcon.action
        viewModel.eventHandler(.action(action ?? .init(type: Constants.defaultActionType)))
        
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            self?.changeFocus()
        }
    }
}

private struct DSSwitchModeSizeSсheme {
    private let overlaySize: CGFloat = 10
    var size: CGSize
    let borderWidth: CGFloat
    
    func getPrimaryIconFrame(for focus: Bool) -> CGRect {
        if focus {
            return CGRect(x: .zero, y: .zero, width: size.height, height: size.height)
        } else {
            let iconSize = size.height - overlaySize - borderWidth
            return CGRect(x: .zero, y: (size.height - iconSize) / 2, width: iconSize, height: iconSize)
        }
    }
    
    func getSecondaryIconFrame(for focus: Bool) -> CGRect {
        if focus {
            return .init(x: size.height / 2, y: .zero, width: size.height, height: size.height)
        } else {
            let iconSize = size.height - overlaySize - borderWidth
            return CGRect(x: size.height - overlaySize, y: (size.height - iconSize) / 2, width: iconSize, height: iconSize)
        }
    }
}

// MARK: - Constants
private extension DSSwitchModeView {
    enum Constants {
        static let defaultActionType = "switchModeMlc"
        static let containerSize: CGSize = .init(width: 66, height: 44)
        
        static let borderColor: CGColor = UIColor(hex: 0xD3DAEB).cgColor
        static let borderWidth: CGFloat = 1
        static let focusedIconCornerRadius: CGFloat = 11
        static let unfocusedIconCornerRadius: CGFloat = 8
        
        static let animationDuration: CGFloat = 0.2
    }
}
