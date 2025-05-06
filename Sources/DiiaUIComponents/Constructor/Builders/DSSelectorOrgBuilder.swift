
import UIKit
import DiiaCommonTypes

/// DS_Code: selectorOrg
public struct DSSelectorOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "selectorOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSSelectorModel = object.parseValue(forKey: Self.modelKey) else { return nil }
        
        let value = data.value ?? data.selectorListWidgetOrg.items
            .compactMap { $0.searchModel() }
            .first(where: { $0.code == data.valueId })?.title
        let state: DropContentState = (data.valueId != nil) ? .selected(text: value ?? "") : .enabled
        
        let viewModel = DSSelectorViewModel(
            code: data.inputCode ?? data.id ?? Self.modelKey,
            state: state,
            title: data.label,
            placeholder: data.placeholder,
            hint: data.hint,
            searchList: data.selectorListWidgetOrg.items,
            searchComponentId: data.selectorListWidgetOrg.componentId,
            selectedCode: data.valueId,
            componentId: data.componentId)
        viewModel.onClick = { [weak viewModel] in
            guard let viewModel = viewModel else { return }
            eventHandler(.dropContentAction(viewModel: viewModel))
        }
        let view = DSSelectorView()
        view.configure(with: viewModel)
        
        if data.isEnabled == false {
            viewModel.state.value = .disabled
        }
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding())
        return paddingBox
    }
}
