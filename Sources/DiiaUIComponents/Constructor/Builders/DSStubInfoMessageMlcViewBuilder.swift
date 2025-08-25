
import UIKit
import DiiaCommonTypes

/// design_system_code: stubInfoMessageMlc
public struct DSStubInfoMessageMlcViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "stubInfoMessageMlc"
    
    public func makeView(from object: AnyCodable, withPadding padding: DSViewPaddingType, viewFabric: DSViewFabric?, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSEmptyStateMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSEmptyStateView()
        view.configure(with: data)
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPaddingV2(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSStubInfoMessageMlcViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSEmptyStateMlc(componentId: "componentId", iconAtm: .mock, title: "title(optional)", text: "text(optional)")
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
