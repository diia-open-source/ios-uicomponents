
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
}

public class DSChipBlackMlcViewModel {
    public let componentId: String?
    public let label: String
    public let code: String
    public var state: Observable<ChipState>
    public var onClick: Callback?
    
    public init(componentId: String?,
                label: String,
                code: String,
                state: Observable<ChipState> = .init(value: .unselected),
                onClick: Callback? = nil) {
        self.componentId = componentId
        self.label = label
        self.code = code
        self.state = state
        self.onClick = onClick
    }
}

public enum ChipState {
    case selected
    case unselected
    case disabled
}

//DS code chipBlackMlc
public class DSChipBlackMlcView: BaseCodeView {
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
        viewModel?.onClick?()
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
