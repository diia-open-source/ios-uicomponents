
import UIKit
import DiiaCommonTypes

public struct DSDetailsTextValueViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "detailsTextValueMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSDetailsTextValueMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSDetailsTextValueView()
        view.setup(with: data)
        let container = UIView()
        container.addSubview(view)
        view.fillSuperview(padding: .init(top: Constants.offset, left: Constants.offset, bottom: Constants.offset, right: Constants.offset))
        return container
    }
}

private extension DSDetailsTextValueViewBuilder {
    enum Constants {
        static let offset: CGFloat = 16
    }
}
