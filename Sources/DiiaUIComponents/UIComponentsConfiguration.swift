
import Foundation
import DiiaCommonTypes

public final class UIComponentsConfiguration {
    public static let shared = UIComponentsConfiguration()
    
    public let imageProvider = DSImageNameResolver.instance
    var imageLoader: ImageLoaderProtocol?
    var urlOpener: URLOpenerProtocol?
    var defaultDecoder: JSONDecoder = JSONDecoder()
    var logger: UIComponentsLogger?

    ///   - imageNameProvider: The image provider for DS components . Can be `nil` if not applicable.
    ///   - urlOpener: The object that responsible for handling URLs. Can be `nil` if not applicable.
    public func setup(imageLoader: ImageLoaderProtocol?, urlOpener: URLOpenerProtocol?, defaultDecoder: JSONDecoder = JSONDecoder(), logger: UIComponentsLogger?) {
        self.imageLoader = imageLoader
        self.urlOpener = urlOpener
        self.defaultDecoder = defaultDecoder
        self.logger = logger
    }
}

import UIKit

final public class DSImageNameResolver: DSImageNameProvider {
    
    public static let instance = DSImageNameResolver()
    
    public func imageForCode(imageCode: String?) -> UIImage? {
        guard let imageCode else { return nil }
        return UIImage(named: "DS_" + imageCode, in: Bundle.module, compatibleWith: nil) ?? R.image.ds_placeholder.image
    }
    
    public func imageNameForCode(imageCode: String) -> String {
        return "DS_" + imageCode
    }
}
