
import UIKit

final public class DSTitleCentralizedMlcView: BaseCodeView {
    private let centralizedLabel = UILabel().withParameters(font: FontBook.mainFont.regular.size(21))
    
    public override func setupSubviews() {
        addSubview(centralizedLabel)
        centralizedLabel.fillSuperview(padding: Constants.paddings)
        centralizedLabel.textAlignment = .center
        centralizedLabel.numberOfLines = 0
    }
    
    public func configure(with model: DSTitleCentralizedMlcModel) {
        accessibilityIdentifier = model.componentId
        centralizedLabel.text = model.label
    }
}

private extension DSTitleCentralizedMlcView {
    enum Constants {
        static let paddings: UIEdgeInsets = .init(top: 8, left: 16, bottom: 0, right: 16)
    }
}
