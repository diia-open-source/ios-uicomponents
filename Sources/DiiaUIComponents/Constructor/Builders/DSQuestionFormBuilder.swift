
import UIKit
import DiiaCommonTypes

public struct DSQuestionFormBuilder: DSViewBuilderProtocol {
    public let modelKey = "questionFormsOrg"
    
    public func makeView(from object: AnyCodable, withPadding padding: DSViewPaddingType, viewFabric: DSViewFabric?, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSQuestionFormsModel = object.parseValue(forKey: self.modelKey) else { return nil }
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
        
        let box = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return box
    }
}

extension DSQuestionFormBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSQuestionFormsModel(
            componentId: "componentId(optional)",
            id: "id",
            title: "title(optional)",
            condition: "condition(optional)",
            items: [
                DSRadioBtnGroupOrgV2Builder().makeMockModel(),
                DSListWidgetItemBuilder().makeMockModel()
            ]
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
