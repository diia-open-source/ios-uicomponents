
import UIKit
import DiiaCommonTypes

public struct DSListItemMlcBuilder: DSViewBuilderProtocol {
    public static let modelKey = "listItemMlc"
    
    //TODO: Test builder after paginationView will be finished
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let item: DSListGroupItem = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        var listItemState: DSItemListViewState = .enabled
        if let state = item.state {
            listItemState = state
        }
        let parameter = item.action
        
        let viewModel = DSListItemViewModel(
            leftLogoLink: item.leftLogoLink,
            leftBase64Icon: .createWithBase64String(item.logoLeft),
            leftSmallIcon: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: item.iconLeft?.code),
            title: item.label,
            details: item.description,
            rightIcon: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: item.iconRight?.code),
            isEnabled: listItemState == .enabled,
            chipStatusAtm: item.chipStatusAtm,
            amountAtm: item.amountAtm)
                
        viewModel.onClick = {
            guard let parameter = parameter else { return }
            eventHandler(.action(parameter))
        }
        
        let view = DSListItemView()
        view.configure(viewModel: viewModel)
        return view
    }
}
