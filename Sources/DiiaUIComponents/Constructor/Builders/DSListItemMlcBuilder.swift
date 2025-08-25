
import UIKit
import DiiaCommonTypes

public struct DSListItemMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "listItemMlc"
    
    //TODO: Test builder after paginationView will be finished
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let item: DSListGroupItem = object.parseValue(forKey: self.modelKey) else { return nil }
        
        var listItemState: DSItemListViewState = .enabled
        if let state = item.state {
            listItemState = state
        }
        let parameter = item.action
        
        let viewModel = DSListItemViewModel(
            leftBigIcon: UIComponentsConfiguration.shared.imageProvider?.imageForCode(imageCode: item.bigIconLeft?.code),
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
        view.setupUI(stackPadding: padding.insets(for: object, modelKey: modelKey, defaultInsets: Constants.defaultStackPadding))
        return view
    }
}

private extension DSListItemMlcBuilder {
    enum Constants {
        static let defaultStackPadding: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
    }
}

// MARK: - Mock
extension DSListItemMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSListGroupItem(
            id: "id",
            logoLeft: "logoLeft",
            iconLeft: .mock,
            bigIconLeft: .mock,
            leftLogoLink: "https://mockImageLink.com",
            iconRight: .mock,
            label: "label",
            state: .enabled,
            description: "description",
            amountAtm: DSAmountAtmModel(componentId: "componentId", value: "value", colour: .green),
            chipStatusAtm: .mock,
            action: .mock,
            dataJson: "dataJson",
            accessibilityDescription: "accessibilityDescription"
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
