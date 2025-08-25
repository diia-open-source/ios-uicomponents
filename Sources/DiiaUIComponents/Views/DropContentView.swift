import UIKit
import DiiaCommonTypes

public enum DropContentState {
    case disabled
    case enabled
    case single(text: String)
    case selected(text: String)
    case error(errorText: String)
}

public class DropContentViewModel: NSObject {
    let title: String
    let placeholder: String
    
    public var items: [SearchItemModel] = [] {
        didSet {
            switch items.count {
            case 1: selectedItem = items[0]
            case 1...: state = .enabled
            default: state = .disabled
            }
        }
    }

    public var selectedItem: SearchItemModel? {
        didSet {
            guard let selectedItem else { return }

            if items.count == 1 {
                state = .single(text: selectedItem.title)
            } else {
                state = .selected(text: selectedItem.title)
            }
        }
    }
    
    public var onClick: Callback?
    public var state: DropContentState = .disabled {
        didSet {
            stateWasUpdated = true
        }
    }
    @objc dynamic var stateWasUpdated: Bool = false
    
    public init(title: String,
                placeholder: String) {
        self.title = title
        self.placeholder = placeholder
    }
}

public class DropContentView: UIView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var bottomLineView: UIView!

    private var placeholder: String = ""
    private var underlineColor: UIColor = .black
    private var underlineInactiveColor: UIColor = .black
    
    private var onClickAction: Callback?
    private var stateChangeObservation: NSKeyValueObservation?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fromNib(bundle: Bundle.module)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fromNib(bundle: Bundle.module)
    }
    
    // MARK: - Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    // MARK: - Setup
    private func setup() {
        setupUI()
        setupAccessibility()
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        tap.cancelsTouchesInView = false
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    public func setupUI(titleFont: UIFont = FontBook.smallTitle,
                        textFont: UIFont = FontBook.usualFont,
                        textColor: UIColor = .black,
                        errorFont: UIFont = FontBook.smallTitle,
                        errorColor: UIColor = Constants.errorColor,
                        backgroundColor: UIColor = .clear,
                        underlineColor: UIColor = .black,
                        underlineInactiveColor: UIColor = .black.withAlphaComponent(0.3)
        ) {
        titleLabel?.font = titleFont
        titleLabel?.textColor = textColor
        textLabel?.font = textFont
        textLabel?.textColor = textColor
        errorLabel?.font = errorFont
        errorLabel?.textColor = errorColor
        errorLabel.numberOfLines = 0
        self.underlineColor = underlineColor
        self.underlineInactiveColor = underlineInactiveColor
        self.backgroundColor = backgroundColor
    }
    
    // MARK: - Setup
    public func configure(title: String, placeholder: String, onClick: @escaping Callback) {
        self.placeholder = placeholder
        titleLabel.text = title
        textLabel.text = placeholder
        self.onClickAction = onClick
    }
    
    public func setupState(state: DropContentState) {
        textLabel.textColor = titleLabel.textColor
        bottomLineView.backgroundColor = titleLabel.textColor
        switch state {
        case .disabled:
            textLabel.text = placeholder
            textLabel.alpha = 0.3
            titleLabel.alpha = 0.3
            bottomLineView.backgroundColor = underlineInactiveColor
            iconView.alpha = 0.3
            errorLabel.isHidden = true
            isUserInteractionEnabled = false
        case .enabled:
            textLabel.text = placeholder
            textLabel.alpha = 0.3
            titleLabel.alpha = 1
            bottomLineView.backgroundColor = underlineInactiveColor
            iconView.alpha = 1
            iconView.isHidden = false
            errorLabel.isHidden = true
            isUserInteractionEnabled = true
        case .selected(let text):
            textLabel.alpha = 1
            titleLabel.alpha = 1
            bottomLineView.backgroundColor = underlineColor
            textLabel.text = text
            iconView.alpha = 1
            iconView.isHidden = false
            errorLabel.isHidden = true
            isUserInteractionEnabled = true
        case .single(let text):
            textLabel.alpha = 1
            titleLabel.alpha = 1
            bottomLineView.backgroundColor = underlineColor
            textLabel.text = text
            iconView.isHidden = true
            errorLabel.isHidden = true
            isUserInteractionEnabled = false
        case .error(let errorText):
            textLabel.alpha = 1
            bottomLineView.backgroundColor = errorLabel.textColor
            textLabel.textColor = errorLabel.textColor
            errorLabel.isHidden = false
            errorLabel.text = errorText
            iconView.isHidden = false
            isUserInteractionEnabled = true
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func configure(viewModel: DropContentViewModel) {
        self.placeholder = viewModel.placeholder
        titleLabel.text = viewModel.title
        textLabel.text = placeholder
        self.onClickAction = viewModel.onClick
        
        stateChangeObservation = viewModel.observe(\.stateWasUpdated, onChange: { [weak self, weak viewModel] _ in
            if let vm = viewModel {
                self?.setupState(state: vm.state)
            }
        })
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        textLabel.isAccessibilityElement = true
        textLabel.accessibilityTraits = .button
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        onClickAction?()
    }
}

// MARK: - Constants
public extension DropContentView {
    enum Constants {
        public static let errorColor = UIColor(AppConstants.Colors.persianRed)
    }
}
