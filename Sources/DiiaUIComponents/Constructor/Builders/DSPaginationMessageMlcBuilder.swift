
import UIKit
import DiiaCommonTypes

/// design_system_code: paginationMessageMlc
public struct DSPaginationMessageMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "paginationMessageMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSPaginationMessageMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSPaginationMessageMlcView()
        view.configure(with: data)
        view.setEventHandler(eventHandler)
        
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

// MARK: - Mock
extension DSPaginationMessageMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSPaginationMessageMlcModel(
            componentId: "componentId",
            title: "title",
            description: "description",
            btnStrokeAdditionalAtm: .mock
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
