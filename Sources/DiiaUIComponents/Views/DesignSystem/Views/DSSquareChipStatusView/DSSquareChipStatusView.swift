
import UIKit

/// design_system_code: squareChipStatusAtm
public class DSSquareChipStatusView: BaseCodeView {
    private let textLabel = UILabel().withParameters(font: FontBook.statusFont)
    
    // MARK: - Init
    public override func setupSubviews() {
        layer.masksToBounds = true
        
        addSubview(textLabel)
        textLabel.fillSuperview(padding: Constants.textPaddings)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 4
    }
    
    public func configure(with model: DSSquareChipStatusModel) {
        textLabel.text = model.name
        textLabel.textColor = UIColor(model.type.textColor)
        backgroundColor = UIColor(model.type.backgroundColor)
    }
}

// MARK: - Constants
private extension DSSquareChipStatusView {
    enum Constants {
        static let textPaddings = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
    }
}
