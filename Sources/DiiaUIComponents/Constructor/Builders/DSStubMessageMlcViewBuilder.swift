
import UIKit
import DiiaCommonTypes

/// design_system_code: stubMessageMlc
public struct DSStubMessageMlcViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "stubMessageMlc"
    
    public let padding: UIEdgeInsets?
    
    public init(padding: UIEdgeInsets? = nil) {
        self.padding = padding
    }
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let stub: DSStubMessageMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = StubMessageViewV2()
        view.configure(
            with: StubMessageViewModel(
                model: stub,
                repeatAction: {
                    guard let action = stub.btnStrokeAdditionalAtm?.action else { return }
                    eventHandler(.action((action)))
                }),
            urlOpener: UIComponentsConfiguration.shared.urlOpener)
        
        let defaultPaddings = padding ?? Constants.paddingInsets
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.insets(for: object, modelKey: modelKey, defaultInsets: defaultPaddings))
        return paddingBox
    }
}

private enum Constants {
    static let paddingInsets = UIEdgeInsets(top: 64, left: 24, bottom: 0, right: 24)
}

extension DSStubMessageMlcViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSStubMessageMlc.mock
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
