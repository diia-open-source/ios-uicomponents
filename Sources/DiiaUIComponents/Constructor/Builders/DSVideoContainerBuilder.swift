
import UIKit
import DiiaCommonTypes

public struct DSVideoContainerBuilder: DSViewBuilderProtocol {
    public static let modelKey = "articleVideoMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSVideoData = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSVideoContainerView()
        let viewModel = DSVideoContainerViewModel(videoData: data)
        viewModel.eventHandler = eventHandler
        view.configure(viewModel: viewModel)
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        let insets = paddingType.defaultPadding()
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

private enum Constants {
    static let cornerRadius: CGFloat = 16
}
