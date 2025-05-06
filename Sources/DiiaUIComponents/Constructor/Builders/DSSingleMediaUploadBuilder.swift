
import UIKit
import DiiaCommonTypes

public class DSSingleMediaUploadBuilder: DSViewBuilderProtocol {
    public static let modelKey = "singleMediaUploadGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSFileUploadModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSSingleMediaUploadGroupOrgView()
        let viewModel = DSFileUploadViewModel(title: data.title, descriptionText: data.description, maxCount: 1, aspectRatio: data.aspectRatio)

        viewModel.action = .init(
            title: data.btnPlainIconAtm.label,
            iconName: UIComponentsConfiguration.shared.imageProvider?.imageNameForCode(imageCode: data.btnPlainIconAtm.icon),
            callback: { 
                guard let action = data.btnPlainIconAtm.action else { return }
                eventHandler(.action(action))
            })
        viewModel.onChange = { [weak viewModel] in
            guard let viewModel = viewModel else { return }
            eventHandler(.fileUploaderAction(viewModel: viewModel))
        }
        view.configure(with: viewModel)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
        return paddingBox
    }
}
