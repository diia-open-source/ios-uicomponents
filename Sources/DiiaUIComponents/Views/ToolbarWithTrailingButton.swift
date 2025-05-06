
import UIKit

/// Use as inputAccessoryView
public final class ToolbarWithTrailingButton: UIToolbar {
    public enum ActionType {
        case done
        case custom(String)
        
        var buttonTitle: String {
            switch self {
            case .done: 
                return R.Strings.toolbar_done.localized()
            case .custom(let title):
                return title
            }
        }
    }
    // MARK: - Properties
    private let action: Selector
    private let actionType: ActionType
    private weak var target: AnyObject?
    
    // MARK: - Initialization
    public init(target: AnyObject, action: Selector, actionType: ActionType = .done) {
        self.action = action
        self.target = target
        self.actionType = actionType
        super.init(frame: CGRect(x: .zero, y: .zero, width: Constants.width, height: Constants.height))
        setupToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupToolbar() {
        sizeToFit()
        let trailingButton = UIBarButtonItem(title: actionType.buttonTitle, style: .done, target: target, action: action)
        let spacerButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setItems([spacerButton, trailingButton], animated: false)
    }
}

private struct Constants {
    static let height: CGFloat = 44.0
    static let width: CGFloat = UIScreen.main.bounds.width
}
