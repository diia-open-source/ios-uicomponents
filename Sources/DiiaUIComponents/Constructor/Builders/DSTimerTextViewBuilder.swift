
import UIKit
import DiiaCommonTypes

/// design_system_code: timerMlc
public struct DSTimerTextViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "timerMlc"
    
    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSTimerTextModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSTimerTextView()
        view.withHeight(Constants.viewHeight)
        
        let viewModel = DSTimerTextViewModel(model: data)
        if let action = data.stateAfterExpiration.btnLinkAtm.action {
            viewModel.onClick = { eventHandler(.action(action)) }
        }
        view.configure(with: viewModel)
        
        let insets = padding.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

// MARK: - Constants
extension DSTimerTextViewBuilder {
    private enum Constants {
        static let viewHeight: CGFloat = 40
    }
}
