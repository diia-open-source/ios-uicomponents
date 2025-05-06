
import UIKit
import DiiaCommonTypes

public struct DSSmallCheckIconOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "smallCheckIconOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSmallCheckIconOrgModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSSmallCheckIconOrgView()
        let viewModel = DSSmallCheckIconOrgViewModel(
            componentId: data.componentId,
            id: data.id,
            title: data.title,
            inputCode: data.inputCode,
            items: data.items.map { item in
                let isSelected = (item.smallCheckIconMlc.state == .selected) ? true : false
                return DSSmallCheckIconMlcViewModel(
                    componentId: data.componentId,
                    id: data.id,
                    iconType: item.smallCheckIconMlc.icon,
                    code: item.smallCheckIconMlc.code,
                    isSelected: .init(value: isSelected))
            })
        viewModel.onClick = { [weak viewModel] in
            guard let viewModel = viewModel  else { return }
            eventHandler(.inputChanged(.init(inputCode: data.inputCode ?? Self.modelKey, inputData: .string(viewModel.selectedCode() ?? .empty))))
        }
       
        view.configure(with: viewModel)
        eventHandler(.onComponentConfigured(with: .smallCheckIcon(viewModel: viewModel)))
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
        return paddingBox
    }
}
