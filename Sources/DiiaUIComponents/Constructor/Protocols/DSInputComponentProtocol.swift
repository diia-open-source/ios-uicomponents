
import UIKit
import DiiaCommonTypes

public protocol DSInputComponentProtocol {
    func isValid() -> Bool
    func inputCode() -> String
    func inputData() -> AnyCodable?
    func isVisible() -> Bool
    
    func setOnChangeHandler(_ handler: @escaping Callback)
}

public extension DSInputComponentProtocol where Self: UIView {
    func isVisible() -> Bool {
        return self.window != nil
    }
    
    func setOnChangeHandler(_ handler: @escaping Callback) {}
}
