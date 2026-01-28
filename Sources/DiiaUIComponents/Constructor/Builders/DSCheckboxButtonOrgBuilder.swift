
import UIKit
import DiiaCommonTypes

public struct DSCheckboxButtonOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "checkboxBtnOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSCheckboxBtnOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = makeView(model: model, eventHandler: eventHandler)
        let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
    
    func makeView(model: DSCheckboxBtnOrg, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> DSCheckboxButtonView {
        let view = DSCheckboxButtonView()
        var buttomVM: DSLoadingButtonViewModel?
        if let buttonModel = model.btnPrimaryDefaultAtm ?? model.btnPrimaryWideAtm, let action = buttonModel.action {
            let btnVM = DSLoadingButtonViewModel(
                title: buttonModel.label,
                state: .disabled,
                componentId: buttonModel.componentId
            )
            btnVM.callback = { [weak btnVM] in
                guard let btnVM = btnVM else { return }
                eventHandler(.buttonAction(parameters: action, viewModel: btnVM))
            }
            buttomVM = btnVM
        }
        var strokeButtonVM: DSLoadingButtonViewModel?
        if let buttonModel = model.btnStrokeWideAtm, let action = buttonModel.action {
            let vm = DSLoadingButtonViewModel(
                title: buttonModel.label,
                state: .enabled,
                componentId: buttonModel.componentId
            )
            vm.callback = { [weak vm] in
                guard let btnVM = vm else { return }
                eventHandler(.buttonAction(parameters: action, viewModel: btnVM))
            }
            strokeButtonVM = vm
        }
        
        var plainButtomVM: DSLoadingButtonViewModel?
        if let buttonModel = model.btnPlainAtm, let action = buttonModel.action {
            let plainBtnVM = DSLoadingButtonViewModel(
                title: buttonModel.label,
                state: .enabled,
                componentId: buttonModel.componentId
            )
            plainBtnVM.callback = { [weak plainBtnVM] in
                guard let btnVM = plainBtnVM else { return }
                eventHandler(.buttonAction(parameters: action, viewModel: btnVM))
            }
            plainButtomVM = plainBtnVM
        }
        let viewModel = DSCheckboxButtonViewModel(
            checkboxVMs: model.items.map { item in
                CheckmarkViewModel(
                    text: item.checkboxSquareMlc.label,
                    isChecked: item.checkboxSquareMlc.isSelected ?? false,
                    parameters: item.checkboxSquareMlc.parameters)
            },
            buttonVM: buttomVM,
            strokeButtonVM: strokeButtonVM,
            plainButtonVM: plainButtomVM)
        view.configure(with: viewModel)
        return view
    }
}

extension DSCheckboxButtonOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCheckboxBtnOrg(
            items: [
                DSCheckboxBtnItem(
                    checkboxSquareMlc: DSCheckboxSquareMlc(
                        id: "checkbox_1",
                        label: "First checkbox option",
                        isSelected: true,
                        isEnabled: true,
                        componentId: "componentId",
                        blocker: false,
                        options: [
                            DSCheckboxOption(id: "option_1", isSelected: true)
                        ]
                    )
                ),
                DSCheckboxBtnItem(
                    checkboxSquareMlc: DSCheckboxSquareMlc(
                        id: "checkbox_2",
                        label: "Second checkbox option",
                        isSelected: false,
                        isEnabled: true,
                        componentId: "componentId",
                        blocker: false,
                        options: [
                            DSCheckboxOption(id: "option_2", isSelected: false)
                        ]
                    )
                )
            ],
            btnPrimaryDefaultAtm: DSButtonModel.mock,
            btnPrimaryWideAtm: DSButtonModel.mock,
            btnStrokeWideAtm: DSButtonModel.mock,
            btnPlainAtm: DSButtonModel.mock,
            componentId: "componentId"
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
