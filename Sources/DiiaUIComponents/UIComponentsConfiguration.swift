
import Foundation
import DiiaCommonTypes

public final class UIComponentsConfiguration {
    public static let shared = UIComponentsConfiguration()
    
    var imageProvider: DSImageNameProvider?
    var urlOpener: URLOpenerProtocol?
    var defaultDecoder: JSONDecoder = JSONDecoder()
    var logger: UIComponentsLogger?

    ///   - imageNameProvider: The image provider for DS components . Can be `nil` if not applicable.
    ///   - urlOpener: The object that responsible for handling URLs. Can be `nil` if not applicable.
    public func setup(imageNameProvider: DSImageNameProvider, urlOpener: URLOpenerProtocol?, defaultDecoder: JSONDecoder = JSONDecoder(), logger: UIComponentsLogger?) {
        self.imageProvider = imageNameProvider
        self.urlOpener = urlOpener
        self.defaultDecoder = defaultDecoder
        self.logger = logger
    }
}
