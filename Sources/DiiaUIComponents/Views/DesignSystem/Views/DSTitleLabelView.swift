
import UIKit

public struct DSTitleLabelIconMlc: Codable {
    let componentId: String?
    let label: String
    let logoAtm: DSLogoAtm?
}

/// design_system_code: titleLabelIconMlc
public final class DSTitleLabelIconView: BaseCodeView {
    private let logoView = DSLogoLinkView().withSize(Constants.logoSize)
    private let titleLabel = UILabel().withParameters(font: FontBook.documentNumberHeadingFont)
    
    public override func setupSubviews() {
        hstack(logoView, titleLabel, spacing: Constants.spacing, alignment: .center)
    }
    
    public func configure(data: DSTitleLabelIconMlc) {
        logoView.isHidden = data.logoAtm == nil
        if let logo = data.logoAtm {
            logoView.configure(data: logo)
        }
        titleLabel.text = data.label
    }
}

private extension DSTitleLabelIconView {
    enum Constants {
        static let logoSize = CGSize(width: 64, height: 64)
        static let spacing: CGFloat = 16
    }
}
