
import UIKit
import DiiaCommonTypes

public struct DSListViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "listItemGroupOrg"
    public init() {}
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let group: DSListGroup = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = makeView(from: group, eventHandler: eventHandler)
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
    
    public func makeView(from listGroup: DSListGroup,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> DSWhiteColoredListView {
        let view = DSWhiteColoredListView()
        
        let groupViewModel = DSListViewModel(title: listGroup.title,
                                             buttonModel: listGroup.btnPlainIconAtm,
                                             eventHandler: eventHandler)
        let items = listGroup.items.map { item in
            var listItemState: DSItemListViewState = .enabled
            if let state = item.state {
                listItemState = state
            }
            let imageProvider = UIComponentsConfiguration.shared.imageProvider
            let viewModel = DSListItemViewModel(
                id: item.id,
                leftBigIcon: imageProvider.imageForCode(imageCode: item.bigIconLeft?.code),
                leftLogoLink: item.leftLogoLink,
                leftBase64Icon: .createWithBase64String(item.logoLeft),
                leftSmallIcon: imageProvider.imageForCode(imageCode: item.iconLeft?.code),
                title: item.label,
                details: item.description,
                rightIcon: imageProvider.imageForCode(imageCode: item.iconRight?.code),
                isEnabled: listItemState == .enabled,
                componentId: item.id,
                accessibilityDescription: item.accessibilityDescription,
                chipStatusAtm: item.chipStatusAtm,
                amountAtm: item.amountAtm)
            if let parameter = item.action {
                viewModel.onClick = { [weak viewModel, weak groupViewModel] in
                    guard let viewModel = viewModel, let groupViewModel = groupViewModel else { return }
                    eventHandler(.listAction(action: parameter, listItem: viewModel, group: groupViewModel))
                }
            }
            return viewModel
        }
        groupViewModel.items.value = items
        view.configure(viewModel: groupViewModel, eventHandler: eventHandler)
        return view
    }
    
    public func makeView(
        from listGroup: DSListGroup,
        withPadding paddingType: DSViewPaddingType,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView {
        let view = makeView(from: listGroup, eventHandler: eventHandler)
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding())
        return paddingBox
    }
}

private enum Constants {
    static let cornerRadius: CGFloat = 16
    static let paddings = UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 24)
}

// MARK: - Mock
extension DSListViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSListGroup(
            title: "title",
            componentId: "componentId",
            items: [
                DSListGroupItem(
                    id: "id1",
                    logoLeft: "logoLeft",
                    iconLeft: .mock,
                    bigIconLeft: .mock,
                    leftLogoLink: "https://mockImageLink.com",
                    iconRight: .mock,
                    label: "label1",
                    state: .enabled,
                    description: "description1",
                    amountAtm: DSAmountAtmModel(componentId: "componentId", value: "value", colour: .green),
                    chipStatusAtm: .mock,
                    action: .mock,
                    dataJson: "dataJson",
                    accessibilityDescription: "accessibilityDescription"
                ),
                DSListGroupItem(
                    id: "id2",
                    logoLeft: "logoLeft",
                    iconLeft: .mock,
                    bigIconLeft: .mock,
                    leftLogoLink: "https://mockImageLink.com",
                    iconRight: .mock,
                    label: "label2",
                    state: .enabled,
                    description: "description2",
                    amountAtm: DSAmountAtmModel(componentId: "componentId", value: "value", colour: .green),
                    chipStatusAtm: .mock,
                    action: .mock,
                    dataJson: "dataJson",
                    accessibilityDescription: "accessibilityDescription"
                )
            ],
            btnPlainIconAtm: .mock
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
