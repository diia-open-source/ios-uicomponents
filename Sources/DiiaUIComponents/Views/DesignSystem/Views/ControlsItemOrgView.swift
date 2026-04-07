
import UIKit
import DiiaCommonTypes

/// design_system_code: controlItemOrg
public struct ControlsItemOrgModel: Codable {
    public let componentId: String
    public let paddingMode: DSPaddingsModel
    public let selectorItem: AnyCodable
    public let size: SelectorSize
    public let alignment: SelectorAlignment
    public let item: AnyCodable
    public let code: String
    public let isSelected: Bool?
    public let isEnabled: Bool?
    public let innerSideSpacer: InnerSideSpacer
    
    public init(componentId: String, paddingMode: DSPaddingsModel, selectorItem: AnyCodable, size: SelectorSize, alignment: SelectorAlignment, item: AnyCodable, code: String, isSelected: Bool?, isEnabled: Bool?, innerSideSpacer: InnerSideSpacer) {
        self.componentId = componentId
        self.paddingMode = paddingMode
        self.selectorItem = selectorItem
        self.size = size
        self.alignment = alignment
        self.item = item
        self.code = code
        self.isSelected = isSelected
        self.isEnabled = isEnabled
        self.innerSideSpacer = innerSideSpacer
    }
    
    public enum InnerSideSpacer: String, Codable {
        case none, small
        
        var spacing: CGFloat {
            switch self {
            case .small: return 8
            case .none: return 0
            }
        }
    }
    
    public enum SelectorSize: String, Codable {
        case small, medium
        
        var sideSpacing: CGFloat {
            switch self {
            case .small: return 2
            case .medium: return 16
            }
        }
    }
    
    public enum SelectorAlignment: String, Codable {
        case top, center
        
        var stackAlignment: UIStackView.Alignment {
            switch self {
            case .top: return .top
            case .center: return .center
            }
        }
    }
}

public final class ControlsItemOrgViewModel: Hashable {
    public let model: ControlsItemOrgModel
    public let state: Observable<SelectorState> = .init(value: .enabled)
    public var onChangeSelection: ((Bool) -> Void)?
    
    public init(model: ControlsItemOrgModel) {
        self.model = model
        switch (model.isSelected ?? false, model.isEnabled ?? true) {
        case (true, true):
            self.state.value = .selected
        case (true, false):
            self.state.value = .selectedDisabled
        case (false, true):
            self.state.value = .enabled
        case (false, false):
            self.state.value = .disabled
        }
    }
    
    public enum SelectorState {
        case enabled
        case disabled
        case selected
        case selectedDisabled
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(model.componentId)
        hasher.combine(model.code)
    }
    
    public static func == (lhs: ControlsItemOrgViewModel, rhs: ControlsItemOrgViewModel) -> Bool {
        lhs.model.code == rhs.model.code && lhs.model.componentId == rhs.model.componentId
    }
}

public final class ControlsItemOrgView: BaseCodeView {
    private lazy var stackView = UIStackView.create(.horizontal, views: [selectorImageContainer, spacer, rightContainter])
    private lazy var spacer = UIView()
    private lazy var rightContainter = UIView()
    private lazy var selectorImageContainer = UIView()
    private lazy var selectorImageView = UIImageView()
    private var imageConstraints: AnchoredConstraints?
    private var spacerConstraints: AnchoredConstraints?

    private var viewModel: ControlsItemOrgViewModel?
    private var viewFabric: DSViewFabric = .instance
    private var eventHandler: ((ConstructorItemEvent) -> Void)?

    public override func setupSubviews() {
        addSubview(stackView)
        layer.cornerRadius = Constants.cornerRadius
        stackView.fillSuperview(padding: .allSides(Constants.baseSpacing))
        selectorImageView.withSize(Constants.imageSize)
        selectorImageContainer.addSubview(selectorImageView)
        imageConstraints = selectorImageView.fillSuperview(padding: .init(horizontal: Constants.baseSpacing, vertical: Constants.baseSpacing))
        spacerConstraints = spacer.anchor(size: .init(width: 1, height: 1))
        tapGestureRecognizer { [weak self] in
            self?.viewModel?.onChangeSelection?(false)
        }
    }
    
    public func configure(_ viewModel: ControlsItemOrgViewModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.viewModel?.state.removeObserver(observer: self)
        self.viewModel = viewModel
        rightContainter.subviews.forEach { $0.removeFromSuperview() }
        if let view = viewFabric.makeView(from: viewModel.model.item, withPadding: .fixed(paddings: .zero), eventHandler: eventHandler) {
            rightContainter.addSubview(view)
            view.fillSuperview()
        }
        stackView.alignment = viewModel.model.alignment.stackAlignment
        imageConstraints?.leading?.constant = viewModel.model.size.sideSpacing
        imageConstraints?.trailing?.constant = -viewModel.model.size.sideSpacing
        
        let style = styleFromObject(viewModel.model.selectorItem)
        spacerConstraints?.width?.constant = viewModel.model.innerSideSpacer.spacing
        spacerConstraints?.height?.constant = style == .radioButton ? Constants.radioButtonHeight : 1
        viewModel.state.observe(observer: self) { [weak self] state in
            self?.updateSelectorImage(style: style, state: state)
            self?.updateBackground(style: style, state: state)
        }
        
        layoutIfNeeded()
    }
    
    public func setupFabric(_ viewFabric: DSViewFabric) {
        self.viewFabric = viewFabric
    }
    
    private func updateBackground(style: SelectorStyle, state: ControlsItemOrgViewModel.SelectorState) {
        switch state {
        case .enabled, .disabled:
            backgroundColor = style.deselectedBackground
        case .selected, .selectedDisabled:
            backgroundColor = style.selectedBackground
        }
    }
    
    private func updateSelectorImage(style: SelectorStyle, state: ControlsItemOrgViewModel.SelectorState) {
        switch state {
        case .enabled:
            selectorImageView.image = style.deselectedImage
        case .selected:
            selectorImageView.image = style.selectedImage
        case .selectedDisabled:
            selectorImageView.image = style.disableSelectedImage
        case .disabled:
            selectorImageView.image = style.disabledImage
        }
    }
    
    private func styleFromObject(_ object: AnyCodable) -> SelectorStyle {
        let keys = object.keys()
        for style in SelectorStyle.allCases {
            if keys.contains(style.objectKey()) {
                return style
            }
        }
        
        return .checkbox
    }
    
    private enum SelectorStyle: CaseIterable {
        case radioButton, checkbox
        
        func objectKey() -> String {
            switch self {
            case .radioButton:
                return "radioButtonAtm"
            case .checkbox:
                return "checkBoxSquareAtm"
            }
        }
        
        public var selectedBackground: UIColor {
            switch self {
            case .radioButton:
                return UIColor("#F1F6F6")
            case .checkbox:
                return .clear
            }
        }
        
        public var deselectedBackground: UIColor {
            return .clear
        }
        
        public var deselectedImage: UIImage? {
            switch self {
            case .checkbox:
                return R.image.checkbox_deselected.image
            case .radioButton:
                return R.image.roundButton_deselected.image
            }
        }
        
        public var selectedImage: UIImage? {
            switch self {
            case .checkbox:
                return R.image.checkbox_selected.image
            case .radioButton:
                return R.image.roundButton_selected.image
            }
        }
        
        public var disabledImage: UIImage? {
            switch self {
            case .checkbox:
                return R.image.checkbox_disabled.image
            case .radioButton:
                return R.image.roundButton_disabled.image
            }
        }
        
        public var disableSelectedImage: UIImage? {
            switch self {
            case .checkbox:
                return R.image.checkbox_selected_disabled.image
            case .radioButton:
                return R.image.roundButton_selected_disabled.image
            }
        }
    }
}

extension ControlsItemOrgView {
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let baseSpacing: CGFloat = 4
        static let imageSize: CGSize = .init(width: 20, height: 20)
        static let radioButtonHeight: CGFloat = 56
    }
}
