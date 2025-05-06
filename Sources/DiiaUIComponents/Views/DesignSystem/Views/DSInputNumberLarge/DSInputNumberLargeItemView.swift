
import UIKit
import DiiaCommonTypes

/// design_system_code: inputNumberLargeAtm
public class DSInputNumberLargeItemView: BaseCodeView {
    // MARK: - Subviews
    public let textField = DSInputNumberLargeTextField()
    
    // MARK: - Properties
    private var model: DSInputNumberLargeItemData?
    
    // MARK: - Init
    public override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        
        addSubview(textField)
        textField.fillSuperview(padding: Constants.textFieldPadding)
    }
    
    // MARK: - Public Methods
    public func configure(with model: DSInputNumberLargeItemData) {
        self.model = model
        textField.configure(with: model)
    }
}

// MARK: - Constants
extension DSInputNumberLargeItemView {
    private enum Constants {
        static let cornerRadius: CGFloat = 8
        static let textFieldPadding = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    }
}
