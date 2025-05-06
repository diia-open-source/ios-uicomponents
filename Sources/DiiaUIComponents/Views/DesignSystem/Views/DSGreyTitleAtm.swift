
import Foundation
import UIKit

public struct DSGreyTitleAtmModel: Codable {
    public let componentId: String
    public let label: String
}

/// design_system_code: greyTitleAtm
public class DSGreyTitleAtm: BaseCodeView {
    private let textLabel = UILabel().withParameters(
        font: FontBook.usualFont,
        textColor: .black.withAlphaComponent(Constants.labelOpacity))
    private let container = UIView()
    
    override public func setupSubviews() {
        self.backgroundColor = .clear
        container.backgroundColor = .clear
        addSubview(container)
        container.fillSuperview()
        container.addSubview(textLabel)
        textLabel.withHeight(Constants.labelHeight)
        textLabel.fillSuperview(padding: Constants.edgeInsets)
    }
    
    // MARK: - Setup
    public func configure(with model: DSGreyTitleAtmModel) {
        container.accessibilityIdentifier = model.componentId
        textLabel.text = model.label
    }
}

extension DSGreyTitleAtm {
    private enum Constants {
        static let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        static let labelHeight: CGFloat = 16
        static let labelOpacity: CGFloat = 0.3
    }
}
