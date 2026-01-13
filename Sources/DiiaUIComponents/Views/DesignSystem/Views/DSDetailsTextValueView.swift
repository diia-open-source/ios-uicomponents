
import Foundation
import UIKit
import DiiaCommonTypes

public final class DSDetailsTextValueView: BaseCodeView {
    // MARK: - Outlets
    private let itemTitle = UILabel().withParameters(font: FontBook.usualFont)
    private let itemValue = UILabel().withParameters(font: FontBook.usualFont)
    
    private var itemLogo = UIImageView()
    private var itemAction = UIButton(type: .system)
    // MARK: - Properties
    public var callback: Callback?
    
    // MARK: - LifeCycle
    override public func setupSubviews() {
        
        let valueStack = hstack(itemLogo, itemValue, itemAction, spacing: Constants.standardSpacing, alignment: .center)
        stack([itemTitle, valueStack], spacing: Constants.smallSpacing, alignment: .leading)
        
        [itemLogo.heightAnchor.constraint(equalToConstant: Constants.smallItemSize),
         itemLogo.widthAnchor.constraint(equalToConstant: Constants.smallItemSize),
         itemAction.heightAnchor.constraint(equalToConstant: Constants.smallItemSize),
         itemAction.heightAnchor.constraint(equalToConstant: Constants.smallItemSize)
        ].forEach { $0.isActive = true }
        
        setupUI()
    }
    
    // MARK: - Public Methods
    
    public func setup(with item: DSDetailsTextValueMlc) {
        configure(with: item.label, value: item.value, logoName: item.logo, actionCode: item.icon?.code)
    }
    
    public func configure(
        with label: String,
        value: String,
        logoName: String? = nil,
        actionCode: String? = nil
    ) {
        
        itemValue.text = value
        itemTitle.text = label
        
        if let logoName = logoName, let logoData = Data(base64Encoded: logoName,
                                                        options: .ignoreUnknownCharacters) {
            itemLogo.image = UIImage(data: logoData)
            itemLogo.isHidden = false
        }
        if let actionImageName = actionCode {
            itemAction.setImage(UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: actionImageName), for: .normal)
            itemAction.isHidden = false
        }
        
        itemAction.addTarget(self,
                             action: #selector(iconAction),
                             for: .touchUpInside)
    }
    
    public func setupUI(titleFont: UIFont = FontBook.usualFont,
                 valueFont: UIFont = FontBook.usualFont,
                 titleColor: UIColor = Constants.titleDefaultColor,
                 valueColor: UIColor = .black) {
        
        backgroundColor = .clear
        
        itemTitle.textColor = titleColor
        itemValue.textColor = valueColor
        
        [itemTitle, itemValue].forEach({
            $0.font = titleFont
            $0.text = nil
        })
        
        [itemLogo, itemAction].forEach({
            $0.isHidden = true
        })
        itemAction.tintColor = .black
    }
    
    // MARK: - Private Methods
    @objc private func iconAction() {
        callback?()
    }
}

// MARK: - Constants
extension DSDetailsTextValueView {
    public enum Constants {
        public static let titleDefaultColor: UIColor = .black.withAlphaComponent(0.4)
        public static let standardSpacing: CGFloat = 12
        public static let smallSpacing: CGFloat = 2
        public static let smallItemSize: CGFloat = 24
    }
}
