
import UIKit
import DiiaCommonTypes

public struct DSStaticTickerAtmViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "staticTickerAtm"

    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSStaticTickerAtmModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let viewModel = DSStaticTickerViewModel(model: model)
        let view = DSStaticTickerView()
        view.configure(with: viewModel, eventHandler: eventHandler)

        eventHandler(.onComponentConfigured(with: .staticTicker(viewModel: viewModel)))

        return view
    }
}

// MARK: - Mock
extension DSStaticTickerAtmViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSStaticTickerAtmModel(
            type: .neutral,
            componentId: "componentId",
            label: "labelmlabelmlabel label label labellabel label label labellabellabellabel label label",
            expireLabel: .init(expireLabelFirst: "expireLabelFirst", expireLabelLast: "min", timer: 5),
            action: .mock
        )

        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
