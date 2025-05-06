
import UIKit
import DiiaCommonTypes

public struct DSListViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "listItemGroupOrg"
    public init() {}
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let group: DSListGroup = object.parseValue(forKey: Self.modelKey) else { return nil }
        return makeView(from: group, withPadding: paddingType, eventHandler: eventHandler)
    }
    
    public func makeView(from listGroup: DSListGroup,
                         withPadding paddingType: DSViewPaddingType,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView {
        let view = DSWhiteColoredListView()
        
        let groupViewModel = DSListViewModel(title: listGroup.title,
                                             buttonModel: listGroup.btnPlainIconAtm,
                                             eventHandler: eventHandler)
        groupViewModel.items = listGroup.items.map { item in
            var listItemState: DSItemListViewState = .enabled
            if let state = item.state {
                listItemState = state
            }
            let viewModel = DSListItemViewModel(
                id: item.id,
                leftBigIcon: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: item.bigIconLeft?.code),
                leftLogoLink: item.leftLogoLink,
                leftBase64Icon: .createWithBase64String(item.logoLeft),
                leftSmallIcon: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: item.iconLeft?.code),
                title: item.label,
                details: item.description,
                rightIcon: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: item.iconRight?.code),
                isEnabled: listItemState == .enabled,
                componentId: item.id,
                chipStatusAtm: item.chipStatusAtm,
                amountAtm: item.amountAtm)
            viewModel.onClick = { [weak viewModel, weak groupViewModel] in
                guard let viewModel = viewModel, let groupViewModel = groupViewModel, let parameter = item.action else { return }
                eventHandler(.listAction(action: parameter, listItem: viewModel, group: groupViewModel))
            }
            return viewModel
        }
        view.configure(viewModel: groupViewModel)
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
        return paddingBox
    }
}

private enum Constants {
    static let cornerRadius: CGFloat = 16
    static let paddings = UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 24)
}
