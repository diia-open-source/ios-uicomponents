import UIKit
import DiiaCommonTypes

/// design_system_code: checkboxBtnOrg
public class BorderedCheckmarksWithButtonsViewModel: NSObject {
    public let checkmarkItems: [DSCheckboxSquareMlc]
    public let buttonActions: [Action]
    public let componentId: String?
    
    public init(
        checkmarkItems: [DSCheckboxSquareMlc],
        buttonActions: [Action],
        componentId: String? = nil
    ) {
        self.checkmarkItems = checkmarkItems
        self.buttonActions = buttonActions
        self.componentId = componentId
    }
    
    public init(
        checkmarksTexts: [String],
        buttonActions: [Action],
        componentId: String? = nil
    ) {
        self.checkmarkItems = checkmarksTexts.map({DSCheckboxSquareMlc(label: $0)})
        self.buttonActions = buttonActions
        self.componentId = componentId
    }
}

public class BorderedCheckmarksWithButtonsView: UIView {
    // MARK: - Outlets
    @IBOutlet private weak var borderedView: UIView!
    @IBOutlet private weak var checkmarkStack: UIStackView!
    @IBOutlet private weak var mainButton: DSPrimaryDefaultButton!
    @IBOutlet private weak var altButtonsStack: UIStackView!
    @IBOutlet private var buttonConstraints: [NSLayoutConstraint]!

    // MARK: - Properties
    private var buttonFont: UIFont = FontBook.bigText
    private var mainButtonAction: Callback?
    private var isActive = true
    
    private var checkMarksState: [Bool] = [] {
        didSet {
            updateActionButtonState()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib(bundle: Bundle.module)

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
    public func configureUI(mainButtonFont: UIFont = FontBook.bigText,
                            width: CGFloat = Constants.viewBorderWidth,
                            color: CGColor = Constants.viewBorderColor) {
        self.buttonFont = mainButtonFont
        self.borderedView.layer.borderWidth = width
        self.borderedView.layer.borderColor = color
    }

    public func configure(model: BorderedCheckmarksWithButtonsViewModel) {
        accessibilityIdentifier = model.componentId
        altButtonsStack.safelyRemoveArrangedSubviews()
        model.buttonActions.enumerated().forEach { index, item in
            if index == 0 {
                mainButton.setLoadingState(.disabled, withTitle: item.title ?? "")
                self.mainButtonAction = item.callback
            } else {
                let altButton = BoxView(subview: ActionButton(action: item, type: .full))
                altButton.withConstraints(size: .init(width: 0, height: Constants.altButtonHeight))
                altButton.subview.setupUI(font: buttonFont, secondaryColor: .clear)
                altButtonsStack.addArrangedSubview(altButton)
            }
        }
        altButtonsStack.isHidden = model.buttonActions.count < 2
        checkMarksState = .init(repeating: false, count: model.checkmarkItems.count)

        checkmarkStack.safelyRemoveArrangedSubviews()
        model.checkmarkItems.enumerated().forEach { index, item in
            let checkmark = BoxView(subview: CheckmarkView())
            checkmarkStack.addArrangedSubview(checkmark)
            checkmark.subview.configure(text: item.label,
                                        isChecked: item.isSelected ?? false,
                                        componentId: item.componentId,
                                        onChange: { [weak self] isChecked in
                self?.checkMarksState[index] = isChecked
            })
        }
        borderedView.layer.borderWidth = checkmarkStack.arrangedSubviews.count > 0 ? Constants.viewBorderWidth : 0
        buttonConstraints.forEach {
            $0.constant = checkmarkStack.arrangedSubviews.count > 0 ? Constants.buttonInset : 0
        }
        updateActionButtonState()
    }

    func setupBorder(width: CGFloat = Constants.viewBorderWidth,
                     color: CGColor = Constants.viewBorderColor) {
        borderedView.layer.borderWidth = width
        borderedView.layer.borderColor = color
    }
    
    public func forceSetMainButtonState(_ state: LoadingStateButton.LoadingState, title: String? = nil) {
        if let title = title {
            mainButton.setLoadingState(state, withTitle: title)
        } else {
            mainButton.setLoadingState(state)
        }
    }
    
    public func setMainButtonState(_ state: LoadingStateButton.LoadingState, title: String? = nil) {
        forceSetMainButtonState(state, title: title)
        switch state {
        case .enabled:
            updateActionButtonState()
        default:
            break
        }
    }
    
    public func setActive(isActive: Bool) {
        self.isActive = isActive
        if isActive {
            updateActionButtonState()
        } else {
            mainButton.setLoadingState(.disabled)
        }
    }
    
    // MARK: - Actions
    @IBAction func onTapOnMainActionButton(_ sender: Any) {
        mainButtonAction?()
    }
    
    // MARK: - Private methods
    private func setup() {
        setupFonts()
        
        borderedView.layer.cornerRadius = Constants.viewCornerRadius
        
        borderedView.layer.borderWidth = Constants.viewBorderWidth
        borderedView.layer.borderColor = Constants.viewBorderColor
    }
    
    private func setupFonts() {
        mainButton.titleLabel?.font = buttonFont
    }
    
    private func updateActionButtonState() {
        mainButton.setLoadingState(
            (checkMarksState.allSatisfy({$0}) || checkMarksState.count == 0) && isActive
            ? .enabled
            : .disabled)
    }
}

// MARK: - Constants
public extension BorderedCheckmarksWithButtonsView {
    enum Constants {
        static let viewCornerRadius: CGFloat = 8
        public static let viewBorderWidth: CGFloat = 1
        public static let viewBorderColor: CGColor = UIColor(AppConstants.Colors.emptyDocumentsBackground).cgColor

        static let buttonInset: CGFloat = 17
        static let altButtonHeight: CGFloat = 48
    }
}
