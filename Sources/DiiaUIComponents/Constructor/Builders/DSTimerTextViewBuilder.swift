
import UIKit
import DiiaCommonTypes

/// design_system_code: timerMlc
public struct DSTimerTextViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "timerMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSTimerTextModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSTimerTextView()
        view.withHeight(Constants.viewHeight)
        
        let viewModel = DSTimerTextViewModel(model: data)
        eventHandler(.onComponentConfigured(with: .timer(viewModel: viewModel)))
        if let action = data.stateAfterExpiration.btnLinkAtm.action {
            viewModel.onClick = {
                eventHandler(.action(action))
            }
        }
        view.configure(with: viewModel)
        
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

// MARK: - Constants
extension DSTimerTextViewBuilder {
    private enum Constants {
        static let viewHeight: CGFloat = 40
        static let timerLength: TimeInterval = 180
    }
}

extension DSTimerTextViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTimerTextModel(
            componentId: "componentId",
            expireLabel: DSExpireLabelBox(
                expireLabelFirst: "expireLabelFirst",
                expireLabelLast: "expireLabelLast",
                timer: 300
            ),
            stateAfterExpiration: DSTimerTextExpirationModel(btnLinkAtm: .mock)
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
