
import UIKit
import SwiftMessages

public extension SwiftMessages {
    
    static func showSuccessMessage(message: String) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .statusLine,
                                                               bundle: Bundle.module)
        messageView.configureTheme(backgroundColor: UIColor(AppConstants.Colors.sendCopiesSuccess),
                                   foregroundColor: UIColor.black)
        messageView.configureContent(body: message)
        messageView.bodyLabel?.font = FontBook.usualFont
        SwiftMessages.show(view: messageView)
    }
    
    static func showError(error: String) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .statusLine,
                                                               bundle: Bundle.module)
        messageView.configureTheme(backgroundColor: UIColor(AppConstants.Colors.yellowErrorColor),
                                   foregroundColor: .black)
        messageView.configureContent(body: error)
        messageView.bodyLabel?.font = FontBook.usualFont
        SwiftMessages.show(view: messageView)
    }
}
