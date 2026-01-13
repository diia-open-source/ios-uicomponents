
import UIKit
import DiiaCommonTypes

/// DS_Code: fileUploadGroupOrg
public struct DSFileUploadGroupBuilder: DSViewBuilderProtocol {
    public let modelKey = "fileUploadGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSFileUploadModel = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSFileUploadView()
        let vm = DSFileUploadViewModel(title: data.title, descriptionText: data.description, maxCount: data.maxCount ?? 5)
        vm.action = .init(
            title: data.btnPlainIconAtm.label,
            iconName: UIComponentsConfiguration.shared.imageProvider.imageNameForCode(imageCode: data.btnPlainIconAtm.icon),
            callback: { [weak vm] in
                guard let vm = vm else { return }
                eventHandler(.fileUploaderAction(viewModel: vm))
            })
        vm.onChange = {
            eventHandler(.inputChanged(.init(inputCode: self.modelKey, inputData: nil)))
        }
        view.configure(with: vm)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSFileUploadGroupBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSFileUploadModel(
            title: "title",
            description: "description",
            maxCount: 3,
            btnPlainIconAtm: .mock,
            aspectRatio: .square
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
