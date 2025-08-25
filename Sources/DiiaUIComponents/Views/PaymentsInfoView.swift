
import UIKit

public struct PaymentPair {
    public let title: String
    public let sum: String
    
    public init(title: String, sum: String) {
        self.title = title
        self.sum = sum
    }
}

/// design_system_code: paymentInfoOrg (DSTableBlockItemModel)

public class PaymentsInfoView: BaseCodeView {

    private let stackView = UIStackView.create(views: [], spacing: Constants.spacing)
    
    public override func setupSubviews() {
        backgroundColor = .white.withAlphaComponent(Constants.backgroundAlpha)
        layer.cornerRadius = Constants.cornerRadius
        
        addSubview(stackView)
        stackView.fillSuperview(padding: Constants.stackPadding)
    }
    
    public func setupPaymentInfo(pairs: [PaymentPair]) {
        stackView.safelyRemoveArrangedSubviews()
        for index in pairs.indices {
            stackView.addArrangedSubview(sumPair(title: pairs[index].title, sum: pairs[index].sum))
            if index == pairs.count - 2 {
                stackView.addArrangedSubview(separator())
            }
        }
        layoutIfNeeded()
    }
    
    public func setupPaymentInfo(paymentInfoOrg: DSTableBlockItemModel) {
        accessibilityIdentifier = paymentInfoOrg.componentId
        stackView.safelyRemoveArrangedSubviews()
        let horizontalMlcbuilder = DSTableItemHorizontalMlcBuilder()
        let horizontalLargeMlcbuilder = DSTableItemHorizontalMlcBuilder()

        guard let paymentItems = paymentInfoOrg.items else { return }
        for tableItem in paymentItems {
            if let tableItemHorizontalMlc = tableItem.tableItemHorizontalMlc {
                let pairView = BoxView(subview: horizontalMlcbuilder.makeView(model: tableItemHorizontalMlc))
                    .withConstraints(insets: Constants.sumPairPadding)
                stackView.addArrangedSubview(pairView)
            }
            if let tableItemHorizontalLargeMlc = tableItem.tableItemHorizontalLargeMlc {
                stackView.addArrangedSubview(separator())
                let pairView = BoxView(subview: horizontalLargeMlcbuilder.makeView(model: tableItemHorizontalLargeMlc))
                    .withConstraints(insets: Constants.sumPairPadding)
                stackView.addArrangedSubview(pairView)
            }
        }
        layoutIfNeeded()
    }
    
    public func setupUI(backgroundColor: UIColor = .white) {
        self.backgroundColor = backgroundColor
    }
    
    private func separator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(AppConstants.Colors.separatorColor)
        separator.withHeight(Constants.separatorHeight)
        return separator
    }
    
    private func sumPair(title: String, sum: String, font: UIFont = FontBook.usualFont) -> UIView {
        let container = UIView()
        
        container.backgroundColor = .clear
        
        let sumTitleLabel = UILabel().withParameters(font: font)
        let sumLabel = UILabel().withParameters(font: font)
        container.addSubview(sumTitleLabel)
        container.addSubview(sumLabel)

        sumTitleLabel.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: nil, padding: Constants.sumPairPadding)
        sumLabel.anchor(top: container.topAnchor, leading: nil, bottom: container.bottomAnchor, trailing: container.trailingAnchor, padding: Constants.sumPairPadding)
        
        sumTitleLabel.text = title
        sumLabel.text = sum
        
        return container
    }
}

private extension PaymentsInfoView {
    enum Constants {
        static let separatorHeight: CGFloat = 1
        static let spacing: CGFloat = 12
        static let cornerRadius: CGFloat = 8
        static let backgroundAlpha: CGFloat = 0.5
        static let sumPairPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let stackPadding = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}
