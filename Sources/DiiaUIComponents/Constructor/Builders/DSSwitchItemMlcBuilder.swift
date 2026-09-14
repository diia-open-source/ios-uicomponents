
import UIKit
import DiiaCommonTypes

/// design_system_code: switchItemMlc
public struct DSSwitchItemMlcBuilder: DSViewBuilderProtocol {
    public let modelKey = "switchItemMlc"

    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let model: DSSwitchItemMlcModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let view = DSSwitchItemMlcView()
        let viewModel = DSSwitchItemMlcViewModel(model: model)

        viewModel.onClick = { [weak viewModel] in
            guard let viewModel else { return }
            eventHandler(.inputChanged(.init(inputCode: model.inputCode, inputData: .bool(viewModel.isSelected.value))))
        }

        view.configure(with: viewModel)

        let box = BoxView(subview: view).withConstraints(insets: padding.insets(for: object, modelKey: modelKey, defaultInsets: .zero))
        return box
    }
}

extension DSSwitchItemMlcBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        return .dictionary([
            modelKey: .fromEncodable(encodable: DSSwitchItemMlcModel.mock)
        ])
    }
}
