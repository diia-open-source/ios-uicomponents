
import UIKit
import DiiaCommonTypes

/// design_system_code: subTitleCentralizedMlc
public struct DSSubTitleCentralizedMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "subTitleCentralizedMlc"

    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSSubTitleCentralizedMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSSubTitleCentralizedMlcView()
        let viewModel = DSTitleMlcViewModel(componentId: model.componentId,
                                            label: model.label)
        view.configure(with: viewModel)
        eventHandler(.onComponentConfigured(with: .titledView(viewModel: viewModel)))
        let box = BoxView(subview: view)
            .withConstraints(
                insets: paddingType.insets(
                for: object,
                modelKey: modelKey,
                defaultInsets: Constants.defaultInsets))
        return box
    }
}

extension DSSubTitleCentralizedMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSSubTitleCentralizedMlcModel(componentId: "componentId", label: "label")
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

private extension DSSubTitleCentralizedMlcBuilder {
    enum Constants {
        static let defaultInsets = UIEdgeInsets(top: 8, left: 24, bottom: .zero, right: 24)
    }
}
