
import UIKit
import DiiaCommonTypes

public struct DSPhotoUploadMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "photoUploadMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSPhotoUploadMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSPhotoUploadMlcView()
        let viewModel = DSPhotoUploadMlcViewModel(
            componentId: data.componentId,
            inputCode: data.inputCode,
            title: data.title,
            mandatory: data.mandatory,
            descriptionText: data.description,
            action: data.action,
            iconCenter: data.iconCenter,
            iconRight: data.iconRight)
        view.configure(with: viewModel, eventHandler: eventHandler)
        eventHandler(.onComponentConfigured(with: .photoUpload(viewModel: viewModel)))
        let insets = padding.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

// MARK: - Mock
extension DSPhotoUploadMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSPhotoUploadMlcModel(
            componentId: "componentIdTest",
            inputCode: "photoUploadMlc",
            iconCenter: .mock,
            mandatory: true,
            title: "Додати фото",
            description: "Вигляд авто з правої сторони",
            iconRight: .mock,
            action: DSActionParameter(type: "addPhoto"))
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
