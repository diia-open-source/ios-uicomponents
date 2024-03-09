import Foundation

public final class UIComponentsConfiguration {
    public static let shared = UIComponentsConfiguration()
    
    internal var imageProvider: DSImageNameProvider?
    
    ///   - imageNameProvider: The image provider for DS components . Can be `nil` if not applicable.
    public func setup(imageNameProvider: DSImageNameProvider) {
        self.imageProvider = imageNameProvider
    }
}
