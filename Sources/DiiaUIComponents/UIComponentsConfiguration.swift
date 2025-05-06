import Foundation
import DiiaCommonTypes

public final class UIComponentsConfiguration {
    public static let shared = UIComponentsConfiguration()
    
    internal var imageProvider: DSImageNameProvider?
    internal var urlOpener: URLOpenerProtocol?
    internal var defaultDecoder: JSONDecoder = JSONDecoder()

    ///   - imageNameProvider: The image provider for DS components . Can be `nil` if not applicable.
    ///   - urlOpener: The object that responsible for handling URLs. Can be `nil` if not applicable.
    public func setup(imageNameProvider: DSImageNameProvider, urlOpener: URLOpenerProtocol?, defaultDecoder: JSONDecoder = JSONDecoder()) {
        self.imageProvider = imageNameProvider
        self.urlOpener = urlOpener
        self.defaultDecoder = defaultDecoder
    }
}
