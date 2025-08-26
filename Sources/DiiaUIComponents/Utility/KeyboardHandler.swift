
import UIKit
import DiiaCommonTypes

public final class KeyboardHandler {
    
    var tokens: [Any] = []
    
    let type: KeyboardHandlingType
    
    public var onShowKeyboard: Callback?
    public var onHideKeyboard: Callback?

    public init(type: KeyboardHandlingType) {
        self.type = type
        
        handleKeyboard()
    }
    
    public func handleKeyboard() {
        weak var weakSelf = self
        
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notif in
            weakSelf?.keyboardWillShow(notif)
        }
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil) { notif in
            weakSelf?.keyboardWillShow(notif)
        }
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { notif in
            weakSelf?.keyboardWillHide(notif)
        }
        tokens.append(token)
    }
    
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    func keyboardWillShow(_ notif: Notification) {
        guard let keyboardFrame = ((notif as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        else {
            return
        }
        type.implement(keyboardFrame: keyboardFrame)
        onShowKeyboard?()
    }
    
    func keyboardWillHide(_ notif: Notification) {
        type.implement(keyboardFrame: .zero)
        onHideKeyboard?()
    }
}

public enum KeyboardHandlingType {
    case constraint(constraint: NSLayoutConstraint, withoutInset: CGFloat, keyboardInset: CGFloat, superview: UIView)
    case scroll(scrollView: UIScrollView, offset: CGFloat)
    case combined(scrollView: UIScrollView, constraint: NSLayoutConstraint, initialBottomInset: CGFloat, keyboardInset: CGFloat, superview: UIView)
    
    func implement(keyboardFrame: CGRect) {
        switch self {
        
        case .constraint(let constraint, let withoutInset, let keyboardInset, let superview):
            var safeAreaOffset: CGFloat = 0
            let window = UIApplication.shared.keyWindow
            safeAreaOffset = window?.safeAreaInsets.bottom ?? 0

            if keyboardFrame.height == .zero {
                constraint.constant = withoutInset
            } else {
                constraint.constant = keyboardFrame.height + keyboardInset - safeAreaOffset
            }
            UIView.animate(withDuration: 0.25) {
                superview.layoutIfNeeded()
            }
            
        case .scroll(let scrollView, let offset):
            if let superview = scrollView.superview {
                let keyboardSize = superview.convert(keyboardFrame, from: nil).size
                let contentInset = UIEdgeInsets(top: scrollView.contentInset.top, left: 0, bottom: keyboardSize.height + offset, right: 0)
                scrollView.contentInset = contentInset
                scrollView.scrollIndicatorInsets = contentInset
            }
            
        case .combined(let scrollView, let constraint, let initialBottomInset, let keyboardInset, let superview):
            let contentInset = UIEdgeInsets(top: scrollView.contentInset.top, left: 0, bottom: Constants.spaceToContent, right: 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
            
            let window = UIApplication.shared.keyWindow
            let safeAreaOffset = window?.safeAreaInsets.bottom ?? 0
            let updatedBottomInset = keyboardFrame.height + keyboardInset - safeAreaOffset
            constraint.constant = (keyboardFrame.height == .zero) ? initialBottomInset : updatedBottomInset
            UIView.animate(withDuration: 0.25) {
                superview.layoutIfNeeded()
            }
        }
    }
    
    private enum Constants {
        static let spaceToContent: CGFloat = 100
    }
}
