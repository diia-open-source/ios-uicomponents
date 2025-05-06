
import UIKit
import DiiaCommonTypes

/// design_system_code: stubMessageMlc
public struct DSEmptyStateViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "stubMessageMlc"
    
    public let padding: UIEdgeInsets?
    
    public init(padding: UIEdgeInsets? = nil) {
        self.padding = padding
    }
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let stub: DSStubMessageMlc = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = StubMessageViewV2()
        view.configure(
            with: StubMessageViewModel(
                model: stub,
                repeatAction: {
                    guard let action = stub.btnStrokeAdditionalAtm?.action else { return }
                    eventHandler(.action((action)))
                }),
            urlOpener: UIComponentsConfiguration.shared.urlOpener)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding ?? Constants.paddingInsets)
        return paddingBox
    }
}

private enum Constants {
    static let paddingInsets = UIEdgeInsets(top: 64, left: 24, bottom: 0, right: 24)
}
