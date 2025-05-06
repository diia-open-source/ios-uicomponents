
import Foundation
import UIKit

public struct DSAmountAtmModel: Codable {
    public let componentId: String
    public let value: String
    public let colour: DSAmountAtmColorType
    
    public var amountViewColor: String {
        switch colour {
        case .black:
            return AppConstants.Colors.black
        case .green:
            return AppConstants.Colors.statusGreen
        case .red:
            return AppConstants.Colors.persianRed
        }
    }
}

public enum DSAmountAtmColorType: String, Codable {
    case black
    case green
    case red
}

/// design_system_code: amountAtm
public class DSAmountAtm: BaseCodeView {
    private let valueLabel = UILabel().withParameters(font: FontBook.bigText)
    
    override public func setupSubviews() {
        self.backgroundColor = .clear
        addSubview(valueLabel)
        valueLabel.fillSuperview()
    }
    
    public func configure(with model: DSAmountAtmModel, textAlignment: NSTextAlignment = .natural) {
        self.accessibilityIdentifier = model.componentId
        valueLabel.text = model.value
        valueLabel.textAlignment = textAlignment
        valueLabel.textColor = UIColor(model.amountViewColor)
    }
}
