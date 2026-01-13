
import Foundation
import UIKit

public struct DSGreyTitleAtmModel: Codable {
    public let componentId: String
    public let label: String
}

/// design_system_code: greyTitleAtm
public final class DSGreyTitleAtm: BaseCodeView {
    private let textLabel = UILabel().withParameters(
        font: FontBook.usualFont,
        textColor: .black.withAlphaComponent(Constants.labelOpacity))
    
    override public func setupSubviews() {
        self.backgroundColor = .clear
        addSubview(textLabel)
        textLabel.fillSuperview()
    }
    
    // MARK: - Setup
    public func configure(with model: DSGreyTitleAtmModel) {
        textLabel.accessibilityIdentifier = model.componentId
        textLabel.text = model.label
        textLabel.textColor = .black.withAlphaComponent(Constants.labelOpacity)
    }
}

extension DSGreyTitleAtm {
    private enum Constants {
        static let edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        static let labelHeight: CGFloat = 16
        static let labelOpacity: CGFloat = 0.6
    }
}
