
import UIKit
import DiiaCommonTypes

struct DSPaymentInfoBuilder: DSViewBuilderProtocol {
    public static let modelKey = "paymentInfoOrg"
    
    func makeView(from object: AnyCodable,
                  withPadding padding: DSViewPaddingType,
                  viewFabric: DSViewFabric?,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTableBlockItemModel = object.parseValue(forKey: DSPaymentInfoBuilder.modelKey) else { return nil }
        
        let view = PaymentsInfoView()
        view.setupPaymentInfo(paymentInfoOrg: data)
        view.setupUI(backgroundColor: .white)
        let insets = padding.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSPaymentInfoBuilder {
    enum Constants {
        static let padding = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
    }
}
