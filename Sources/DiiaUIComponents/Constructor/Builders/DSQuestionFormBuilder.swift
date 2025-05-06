
import UIKit
import DiiaCommonTypes

public struct DSQuestionFormBuilder: DSViewBuilderProtocol {
    public static let modelKey = "questionFormsOrg"
    
    public func makeView(from object: AnyCodable, withPadding padding: DSViewPaddingType, viewFabric: DSViewFabric?, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSQuestionFormsModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSBackgroundWhiteView()
        
        if let fabric = viewFabric {
            view.setFabric(fabric)
        }
        
        let viewModel = DSBackgroundWhiteViewModel(
            title: data.title,
            subviews: data.items,
            componentId: data.componentId,
            eventHandler: eventHandler
        )
        view.configure(for: viewModel)
        
        let container = BoxView(subview: view).withConstraints(insets: Constants.padding)
        return container
    }
}

private extension DSQuestionFormBuilder {
    enum Constants {
        static let padding = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
    }
}
