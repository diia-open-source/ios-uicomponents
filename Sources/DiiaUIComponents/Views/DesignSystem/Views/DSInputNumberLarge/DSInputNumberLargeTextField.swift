
import UIKit

public class DSInputNumberLargeTextField: UITextField {
    public var focusPlaceholder: String? {
        didSet {
            self.placeholder = focusPlaceholder
        }
    }
    
    public override func deleteBackward() {
        super.deleteBackward()
        
        if (text ?? "").isEmpty {
            sendActions(for: .editingChanged)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.tintColor = .black
        self.textColor = .black
        self.font = FontBook.bigHeading
        self.textAlignment = .center
        self.keyboardType = .numberPad
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.textContentType = .oneTimeCode
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: DSInputNumberLargeItemData) {
        self.accessibilityIdentifier = viewModel.componentId
        self.focusPlaceholder = viewModel.placeholder
    }
}
