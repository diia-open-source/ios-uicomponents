
import UIKit

public protocol FixSizedViewProtocol {
    func setHeight(constant: CGFloat)
    func setHeightEqual(to view: UIView)
}

public extension FixSizedViewProtocol where Self: UIView {
    func setHeight(constant: CGFloat) {
        self.withHeight(constant)
    }
    
    func setHeightEqual(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
    }
}

public protocol FullSizedViewProtocol: FixSizedViewProtocol {}
