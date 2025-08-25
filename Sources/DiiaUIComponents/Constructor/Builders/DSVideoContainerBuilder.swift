
import UIKit
import DiiaCommonTypes

public struct DSVideoContainerBuilder: DSViewBuilderProtocol {
    public let modelKey = "articleVideoMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSVideoData = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSVideoContainerView()
        let viewModel = DSVideoContainerViewModel(videoData: data)
        viewModel.eventHandler = eventHandler
        view.configure(viewModel: viewModel)
        view.layer.cornerRadius = Constants.cornerRadius
        view.clipsToBounds = true
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

private enum Constants {
    static let cornerRadius: CGFloat = 16
}

extension DSVideoContainerBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSVideoData(
            componentId: "componentId",
            source: "source",
            playerBtnAtm: DSPlayerBtnModel(type: "type", icon: "icon"),
            fullScreenVideoOrg: DSFullScreenVideoOrg(
                componentId: "componentId",
                source: "source",
                playerBtnAtm: DSPlayerBtnModel(type: "type", icon: "icon"),
                btnPrimaryDefaultAtm: .mock,
                btnPlainAtm: .mock
            ),
            thumbnail: "thumbnail"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
