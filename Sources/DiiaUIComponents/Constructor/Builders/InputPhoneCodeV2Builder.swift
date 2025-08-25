
import UIKit
import DiiaCommonTypes

/// design_system_code: inputPhoneCodeOrgV2
public struct InputPhoneCodeV2Builder: DSViewBuilderProtocol {
    
    public let modelKey = "inputPhoneCodeOrgV2"
    
    public func makeView(
        from object: AnyCodable,
        withPadding paddingType: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSInputPhoneCodeModelV2 = object.parseValue(forKey: self.modelKey) else { return nil }

        let inputView = InputPhoneCodeViewV2()
        let viewModel = DSInputPhoneCodeViewModel(
            dataV2: data,
            eventHandler: eventHandler)
        inputView.configure(with: viewModel)
        
        if data.isDisable == true {
            viewModel.fieldState.value = .disabled
        }

        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: inputView).withConstraints(insets: insets)
        return paddingBox
    }
}

extension InputPhoneCodeV2Builder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputPhoneCodeModelV2(
            componentId: "componentId",
            label: "label",
            hint: "hint",
            mandatory: true,
            inputCode: "phone",
            inputPhoneMlcV2: DSInputPhoneModel(
                componentId: "componentId",
                inputCode: "inputCode",
                label: "Номер телефону",
                placeholder: "Номер телефону",
                hint: "Введіть номер телефону у правильному форматі",
                mask: "## ### ## ##",
                value: "555 55 55",
                mandatory: true,
                validation: []
            ),
            codeValueId: "id_ua",
            codeValueIsEditable: true,
            codes: [
                DSPhoneCodeModel(
                id: "id_ua",
                maskCode: "## ### ## ##",
                placeholder: "placeholder",
                label: "380",
                description: "UA",
                value: "+380",
                icon: "🇺🇦",
                validation: [.init(regexp: "([0-9]{9})", flags: [], errorMessage: "Невірний номер")],
                isDisable: false
            )],
            isDisable: false
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
