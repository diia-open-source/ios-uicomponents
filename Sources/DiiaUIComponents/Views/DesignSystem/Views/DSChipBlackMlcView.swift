
import UIKit
import DiiaCommonTypes

public struct DSChipBlackMlcItemModel: Codable {
   public let chipBlackMlc: DSChipBlackMlcModel
}

public struct DSChipBlackMlcModel: Codable {
    public let componentId: String?
    public let label: String
    public let code: String
    public let active: Bool?
    public let action: DSActionParameter?
    public let dataJson: AnyCodable?
    
    public init(componentId: String?,
                label: String,
                code: String,
                active: Bool?,
                action: DSActionParameter?,
                dataJson: AnyCodable? = nil) {
        self.componentId = componentId
        self.label = label
        self.code = code
        self.active = active
        self.action = action
        self.dataJson = dataJson
    }
}

public final class DSChipBlackMlcViewModel: NSObject {
    public let componentId: String?
    public let label: String
    public let code: String
    public var state: Observable<ChipState>
    public var onClick: ((ConstructorItemEvent?) -> Void)?
    public var action: DSActionParameter?
    public var dataJson: AnyCodable?

    public init(componentId: String?,
                label: String,
                code: String,
                dataJson: AnyCodable? = nil,
                state: Observable<ChipState> = .init(value: .unselected),
                onClick: ((ConstructorItemEvent?) -> Void)? = nil,
                action: DSActionParameter?) {
        self.componentId = componentId
        self.label = label
        self.code = code
        self.state = state
        self.onClick = onClick
        self.action = action
        self.dataJson = dataJson
    }
    
    public init(model: DSChipBlackMlcModel) {
        self.componentId = model.componentId
        self.label = model.label
        self.code = model.code
        self.state = .init(value: .unselected)
        self.action = model.action
        self.dataJson = model.dataJson
    }
}

public enum ChipState {
    case selected
    case unselected
    case disabled
}

//DS code chipBlackMlc
public final class DSChipBlackMlcView: BaseCodeView {
    private let containerView = UIView()
    private let textLabel = UILabel().withParameters(font: FontBook.usualFont)
    private weak var viewModel: DSChipBlackMlcViewModel?
    
    public override func setupSubviews() {
        addSubview(containerView)
        containerView.fillSuperview()
        containerView.addSubview(textLabel)
        textLabel.fillSuperview(padding: Constants.insets)
       
        containerView.withBorder(width: Constants.borderWidth, color: Constants.borderColor)
        textLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        textLabel.numberOfLines = 1
        textLabel.textAlignment = .center
        addTapGestureRecognizer()
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = frame.height / 2
        containerView.clipsToBounds = true
    }
    public func configure(with viewModel: DSChipBlackMlcViewModel) {
        viewModel.state.removeObserver(observer: self)
        accessibilityIdentifier = viewModel.componentId
        self.viewModel = viewModel
        self.textLabel.text = viewModel.label
        viewModel.state.observe(observer: self) { [weak self] state in
            self?.updateChipView(state)
        }
    }
    
    private func updateChipView(_ state: ChipState) {
        switch state {
        case .selected:
            containerView.isUserInteractionEnabled = true
            containerView.backgroundColor = .black
            textLabel.textColor = .white
        case .unselected:
            containerView.isUserInteractionEnabled = true
            containerView.backgroundColor = .white
            textLabel.textColor = .black
        case .disabled:
            containerView.isUserInteractionEnabled = false
            containerView.backgroundColor = .white
            textLabel.textColor = Constants.disabledStateColor
        }
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc private func onClick() {
        if let action = viewModel?.action {
            viewModel?.onClick?(.action(action))
        } else {
            viewModel?.onClick?(nil)
        }
    }
    
    static func widthForText(text: String) -> CGFloat {
        text.width(withConstrainedHeight: .greatestFiniteMagnitude, font: FontBook.usualFont) + Constants.insets.left + Constants.insets.right + 2 * Constants.borderWidth
    }
    
}
extension DSChipBlackMlcView {
    private enum Constants {
        static let insets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        static let borderWidth: CGFloat = 1
        static let borderColor: UIColor = .black.withAlphaComponent(0.3)
        static let disabledStateColor: UIColor = .black.withAlphaComponent(0.2)
    }
}
