
import UIKit
import DiiaCommonTypes

/// design_system_code: blackCardMlc
final public class DSBlackCardView: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont, textColor: .white)
    private let detailsLabel = UILabel().withParameters(font: FontBook.bigText, textColor: Constants.detailsTextColor)
    private let doubleIconView: UIImageView = UIImageView().withSize(Constants.doubleImageSize)
    private let singleIconView: UIImageView = UIImageView().withSize(Constants.singleImageSize)
    private let arrowIconView: UIImageView = UIImageView().withSize(Constants.arrowImageSize)
    
    private var touchAction: Callback?
    var viewId: String?
    
    override public func setupSubviews() {
        let itemsStackView = UIStackView.create(
            .horizontal,
            views: [doubleIconView, singleIconView, titleLabel],
            spacing: Constants.spacing,
            distribution: .fillProportionally)
        let topStackView = UIStackView.create(
            .horizontal,
            views: [itemsStackView, arrowIconView],
            spacing: Constants.spacing,
            alignment: .center)
        
        let topViewBox = BoxView(subview: topStackView).withConstraints(insets: Constants.topViewInsets)
        let separator = UIView().withHeight(Constants.separatorHeight)
        separator.backgroundColor = Constants.separatorColor
        
        let bottomViewBox = BoxView(subview: detailsLabel).withConstraints(insets: Constants.topViewInsets)
        stack([topViewBox, separator, bottomViewBox])
        
        setupUI()
        addTapGestureRecognizer()
    }
    
    // MARK: - Public Methods
    public func configure(with model: DSBlackCardModel, touchAction: Callback?) {
        titleLabel.text = model.title
        detailsLabel.text = model.label
        
        doubleIconView.isHidden = model.doubleIconAtm == nil
        if let doubleIcon = model.doubleIconAtm {
            doubleIconView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: doubleIcon.code)
        }
        
        singleIconView.isHidden = model.iconAtm == nil
        if let singleIcon = model.iconAtm {
            singleIconView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: singleIcon.code)
        }
        
        arrowIconView.isHidden = model.smallIconAtm == nil
        if let smallIcon = model.smallIconAtm {
            arrowIconView.image = UIComponentsConfiguration.shared.imageProvider.imageForCode(imageCode: smallIcon.code)
        }
        
        self.touchAction = touchAction
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .black
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true
        
        doubleIconView.contentMode = .scaleAspectFill
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    @objc private func onClick() {
        touchAction?()
    }
}

private extension DSBlackCardView {
    enum Constants {
        static let spacing: CGFloat = 8
        static let cornerRadius: CGFloat = 16
        static let topViewInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        static let detailsTextColor: UIColor = .white.withAlphaComponent(0.6)
        static let separatorHeight: CGFloat = 1
        static let separatorColor: UIColor = .white.withAlphaComponent(0.2)
        
        static let doubleImageSize = CGSize(width: 58, height: 32)
        static let singleImageSize = CGSize(width: 32, height: 32)
        static let arrowImageSize = CGSize(width: 24, height: 24)
    }
}
