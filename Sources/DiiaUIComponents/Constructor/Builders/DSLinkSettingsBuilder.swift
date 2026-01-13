
import UIKit
import DiiaCommonTypes

public struct DSLinkSettingsBuilder: DSViewBuilderProtocol {
    public let modelKey = "linkSettingsOrg"
    
    public func makeView(
        from object: AnyCodable,
        withPadding paddingType: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
            guard let data: DSLinkSettingsOrg = object.parseValue(forKey: self.modelKey) else { return nil }
            
            let view = DSLinkSettingsView()
            view.configure(with: data, eventHandler: eventHandler)
            let paddingBox = BoxView(subview: view).withConstraints(insets: paddingType.defaultPaddingV2(object: object, modelKey: modelKey))
            return paddingBox
        }
}

extension DSLinkSettingsBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let  model = DSLinkSettingsOrg(
            componentId: "companentID",
            label: "Перейшли за посиланням 1 з 20",
            linkSharingMlc: DSLinkSharingMlcModel(
                componentId: "companentID" ,
                label: "diia.gov.ua/verylongdiplink",
                iconRight: .mock),
            description: "Посилання дійсне до 12.12.25 14:00",
            btnPrimaryPlainIconAtm: DSBtnPrimaryPlainIconAtm(
                componentId: "companentID",
                label: "Надіслати посилання",
                state: .enabled,
                icon: DSIconModel(code: "feedInActive"),
                action: nil),
            btnIconPlainGroupMlc: DSBtnIconPlainGroupMlc(
                items: [DSBtnPlainIconAtm(
                    btnPlainIconAtm: DSBtnPlainIconModel(
                        label: "Деактивувати посилання",
                        icon: "flashOn",
                        action: nil,
                        componentId: "companentID"))],
                componentId: "companentID"))
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
    
}
