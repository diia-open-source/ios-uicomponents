
import UIKit
import DiiaCommonTypes

public protocol DSViewBuilderProtocol {
    var modelKey: String { get }
    func makeView(from object: AnyCodable,
                  withPadding padding: DSViewPaddingType,
                  viewFabric: DSViewFabric?,
                  eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView?
}

public protocol DSViewMockableBuilderProtocol: DSViewBuilderProtocol {
    func makeMockModel() -> AnyCodable
    func makeMockView(withPadding padding: DSViewPaddingType,
                      viewFabric: DSViewFabric?,
                      eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView?
}

public extension DSViewMockableBuilderProtocol {
    func makeMockView(withPadding padding: DSViewPaddingType,
                      viewFabric: DSViewFabric?,
                      eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        return makeView(from: makeMockModel(), withPadding: padding, viewFabric: viewFabric, eventHandler: eventHandler)
    }
}
