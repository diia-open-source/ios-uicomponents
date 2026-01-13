
import UIKit
import DiiaCommonTypes

/// design_system_code: paymentInfoOrgV2

final class PaymentsInfoV2View: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont, textColor: .black, textAlignment: .center)
    private let subTitleLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: .gray, textAlignment: .center)
    private let itemsStackView = UIStackView.create(spacing: Constants.stackSpacing)
    private let separator = DSDividerLineView()
    private let totalView = DSTableItemHorizontalView()
    
    override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        
        totalView.setupUI(titleFont: FontBook.bigText, valueFont: FontBook.bigText)
        totalView.setValueAlignment(.right)
        separator.setupUI(height: 1, color: Constants.separatorColor)
        
        let titleStack = UIStackView.create(views: [titleLabel, subTitleLabel],
                                            spacing: Constants.stackSpacing)
        addSubviews([titleStack, itemsStackView, separator, totalView])
        
        titleStack.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          trailing: trailingAnchor,
                          padding: .allSides(Constants.padding))
        
        itemsStackView.anchor(top: titleStack.bottomAnchor,
                              leading: leadingAnchor,
                              trailing: trailingAnchor,
                              padding: .init(top: Constants.largePadding,
                                             left: Constants.padding,
                                             bottom: .zero,
                                             right: Constants.padding))
        separator.anchor(top: itemsStackView.bottomAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor,
                         padding: .allSides(Constants.padding))
        totalView.anchor(top: separator.bottomAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: .allSides(Constants.padding))
    }
    
    public func configure(for model: PaymentInfoOrg, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        titleLabel.text = model.title
        subTitleLabel.text = model.subtitle
        
        if !model.items.isEmpty {
            for item in model.items {
                if let view = DSViewFabric.instance.makeView(from: item,
                                                             withPadding: .fixed(paddings: .zero),
                                                             eventHandler: eventHandler) {
                    itemsStackView.addArrangedSubview(view)
                    if let view = view as? BoxView<DSTableItemHorizontalView> {
                        view.subview.setValueAlignment(.right)
                    }
                }
            }
        }
        if let total = model.tableItemHorizontalLargeMlc {
            totalView.configure(item: total, urlOpener: UIComponentsConfiguration.shared.urlOpener)
            totalView.setValueAlignment(.right)
        }
    }
}

private extension PaymentsInfoV2View {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let stackSpacing: CGFloat = 8
        static let padding: CGFloat = 16
        static let largePadding: CGFloat = 32
        static let separatorColor: UIColor = #colorLiteral(red: 0.8862745098, green: 0.9254901961, blue: 0.9568627451, alpha: 1)
    }
}
