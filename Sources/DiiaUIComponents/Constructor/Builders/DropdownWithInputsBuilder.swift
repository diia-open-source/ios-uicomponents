
import UIKit
import DiiaCommonTypes

/// design_system_code: dropdownWithInputsOrg
public struct DropdownWithInputsBuilder: DSViewBuilderProtocol {
    public let modelKey = "dropdownWithInputsOrg"

    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
            guard let model: DropdownWithInputsOrg = object.parseValue(forKey: self.modelKey) else { return nil }

            let view = DropdownWithInputsView()
            let listViewModel = DropdownListViewModel(
                componentId: model.dropdownInputGroupOrg.dropdownListMlc.componentId,
                inputCode: model.dropdownInputGroupOrg.dropdownListMlc.inputCode,
                items: model.dropdownInputGroupOrg.dropdownListMlc.items ?? [],
                initialSelection: model.dropdownInputGroupOrg.dropdownListMlc.value
            )
            let dropInputModel = InputDocumentViewModel(
                componentId: model.dropdownInputGroupOrg.inputDocumentMlc.componentId,
                inputCode: model.dropdownInputGroupOrg.inputDocumentMlc.inputCode,
                placeholder: model.dropdownInputGroupOrg.inputDocumentMlc.placeholder,
                defaultText: model.dropdownInputGroupOrg.inputDocumentMlc.value,
                keyboardType: model.dropdownInputGroupOrg.inputDocumentMlc.keyboardType,
                rightAction: model.dropdownInputGroupOrg.inputDocumentMlc.clearAction,
                maxLength: model.dropdownInputGroupOrg.inputDocumentMlc.maxLength
            )
            let inputModel = InputDocumentViewModel(
                componentId: model.inputDocumentMlc.componentId,
                inputCode: model.inputDocumentMlc.inputCode,
                placeholder: model.inputDocumentMlc.placeholder,
                defaultText: model.inputDocumentMlc.value,
                keyboardType: model.inputDocumentMlc.keyboardType,
                rightAction: model.inputDocumentMlc.clearAction,
                minLength: model.inputDocumentMlc.minLength,
                maxLength: model.inputDocumentMlc.maxLength)
            
            let dropdownInputViewModel = DropdownInputGroupViewModel(
                dropdownListViewModel: listViewModel,
                inputDocumentViewModel: dropInputModel)
            
            let viewModel = DropdownWithInputsViewModel(
                firstLabel: model.firstLabel,
                secondLabel: model.secondLabel,
                dropdownListViewModel: dropdownInputViewModel,
                inputDocViewModel: inputModel)
            
            view.configure(viewModel: viewModel)
            
            inputModel.onChangeText = { [weak inputModel] text in
                guard let inputModel else { return }
                eventHandler(.inputChanged(.init(inputCode: inputModel.inputCode ?? inputModel.componentId,
                                                 inputData: .string(text))))
            }
            
            dropInputModel.onChangeText = { [weak dropInputModel] text in
                guard let dropInputModel else { return }
                eventHandler(.inputChanged(.init(inputCode: dropInputModel.inputCode ?? inputModel.componentId,
                                                 inputData: .string(text))))
            }
            
            let insets = padding.defaultPadding(object: object, modelKey: modelKey)
            let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
            return paddingBox
    }
}
