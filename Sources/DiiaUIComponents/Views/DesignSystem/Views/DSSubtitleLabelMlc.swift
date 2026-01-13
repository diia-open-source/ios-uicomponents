
import UIKit

public struct DSSubtitleLabelMlc: Codable {
    public let label: String
    public let icon: String?
    public let componentId: String?
    
    public init(label: String, icon: String?, componentId: String? = nil) {
        self.label = label
        self.icon = icon
        self.componentId = componentId ?? String(describing: Self.self)
    }
}

/// design_system_code: subtitleLabelMlc
public final class DSSubtitleLabelMlcView: BaseCodeView {
    private let iconView = UIImageView()
    private let label = UILabel().withParameters(font: FontBook.smallHeadingFont)
    
    override public func setupSubviews() {
        iconView.withSize(Constants.iconSize)
        hstack(iconView, label, spacing: Constants.stackSpacing, alignment: .center)
    }
    
    public func configure(model: DSSubtitleLabelMlc) {
        label.text = model.label
        let icon = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: model.icon)
        iconView.isHidden = icon == nil
        iconView.image = icon
    }
}

private extension DSSubtitleLabelMlcView {
    enum Constants {
        static let stackSpacing: CGFloat = 8
        static let iconSize: CGSize = .init(width: 24, height: 24)
    }
}
