
import UIKit
import DiiaCommonTypes

public struct DSListWidgetItemBuilder: DSViewBuilderProtocol {
    public static let modelKey = "listWidgetItemMlc"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSListWidgetItemModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let view = DSListWidgetItemView()
        let viewModel = DSListWidgetItemViewModel(model: data)
        viewModel.onClick = {
            eventHandler(.inputChanged(.init(inputCode: Self.modelKey, inputData: data.dataJson ?? .string(data.id ?? data.componentId ?? .empty))))
        }
        view.configure(with: viewModel)
        
        let paddingBox = BoxView(subview: view).withConstraints(insets: Constants.padding)
        return paddingBox
    }
}

// MARK: - Constants
extension DSListWidgetItemBuilder {
    private enum Constants {
        static let padding = UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 24)
    }
}
