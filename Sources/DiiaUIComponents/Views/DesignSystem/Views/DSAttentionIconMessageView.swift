
import Foundation

import UIKit
import DiiaCommonTypes

/// design_system_code: attentionIconMessageMlc, attentionMessageGtMlc

final public class DSAttentionIconMessageView: BaseCodeView {
    private let iconImage = UIImageView()
    private let textLabel = UILabel().withParameters(font: FontBook.usualFont)
    
    public override func setupSubviews() {
        super.setupSubviews()
        layer.cornerRadius = Constants.cornerRadius
        iconImage.withSize(Constants.imageSize)
        hstack(iconImage, textLabel,
               spacing: Constants.spacing,
               alignment: .top,
               padding: .allSides(Constants.padding))
    }
    
    public func configure(with model: DSAttentionIconMessageMlc) {
        let imageProvider = UIComponentsConfiguration.shared.imageProvider
        iconImage.image = imageProvider?.imageForCode(imageCode: model.smallIconAtm.code)
        textLabel.attributedText = model.text.attributed(font: FontBook.usualFont,
                                                         lineHeight: Constants.lineHeight)
        backgroundColor = UIColor(hex: model.backgroundMode.color)
    }
}

extension DSAttentionIconMessageView {
    enum Constants {
        static let padding: CGFloat = 16
        static let spacing: CGFloat = 8
        static let lineHeight: CGFloat = 18
        static let cornerRadius: CGFloat = 16
        static let imageSize = CGSize(width: 24, height: 24)
    }
}
