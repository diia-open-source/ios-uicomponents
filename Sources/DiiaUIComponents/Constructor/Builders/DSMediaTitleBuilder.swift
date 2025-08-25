
import UIKit
import DiiaCommonTypes

public struct DSMediaTitleBuilder: DSViewBuilderProtocol {
    public let modelKey = "mediaTitleOrg"

    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSMediaTitleModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSMediaTitleView()
        view.configure(
            with: DSMediaTitleViewModel(model: data) {
                if let action = data.btnPlainIconAtm.action {
                    eventHandler(.action(action))
                }
            }
        )

        let insets = (paddingType == .default) ? Constants.defaultPaddings : Constants.smallPaddings
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSMediaTitleBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSMediaTitleModel(
            title: "Media Title",
            secondaryLabel: "Secondary Label",
            btnPlainIconAtm: DSBtnPlainIconModel(
                id: "componentId",
                state: nil,
                label: "Button Label",
                icon: "home",
                action: .mock,
                componentId: "componentId"
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

private enum Constants {
    static let defaultPaddings = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    static let smallPaddings = UIEdgeInsets(top: 8, left: 24, bottom: 0, right: 24)
}
