
import UIKit
import DiiaCommonTypes

/// design_system_code: inputPhoneCodeOrg
public struct DSInputPhoneCodeBuilder: DSViewBuilderProtocol {
    public let modelKey = "inputPhoneCodeOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding paddingType: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let data: DSInputPhoneCodeModel = object.parseValue(forKey: self.modelKey) else { return nil }

        let inputView = DSInputPhoneCodeView()
        inputView.configure(with: .init(
            data: data,
            eventHandler: eventHandler))

        let paddingBox = BoxView(subview: inputView).withConstraints(insets: paddingType.defaultPadding(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSInputPhoneCodeBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSInputPhoneCodeModel(
            componentId: "componentId",
            label: "label",
            hint: "hint",
            mandatory: true,
            inputCode: "phone",
            inputPhoneMlc: DSInputPhoneModel(
                componentId: "componentId",
                inputCode: "inputCode",
                label: "Номер телефону",
                placeholder: "Номер телефону",
                hint: "Введіть номер телефону у правильному форматі",
                mask: "## ### ## ##",
                value: "99 555 55 55",
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
                label: "+380",
                description: "UA",
                value: "380",
                icon: "🇺🇦",
                validation: [.init(regexp: "([0-9]{12})", flags: [], errorMessage: "Невірний номер")],
                isDisable: false
            )],
            isDisable: false
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
