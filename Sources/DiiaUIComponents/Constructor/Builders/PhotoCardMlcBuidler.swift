
import UIKit
import DiiaCommonTypes

///design_system_code: photoCardMlc
public struct PhotoCardMlcBuidler: DSViewBuilderProtocol {
    public let modelKey = "photoCardMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let photoCardMlc: PhotoCardMlc = object.parseValue(forKey: self.modelKey) else { return nil }
        let viewModel = PhotoCardMlcViewModel(photoCardMlc: photoCardMlc, eventHandler: eventHandler)
        let view = self.makeView(from: viewModel, eventHandler: eventHandler)
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
    
    public func makeView(from viewModel: PhotoCardMlcViewModel,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> PhotoCardMlcView {
        let photoCardView = PhotoCardMlcView()
        photoCardView.configure(viewModel: viewModel)
        return photoCardView
    }
}
