
import UIKit
import DiiaCommonTypes

public struct DSRadioBtnGroupOrgV2Builder: DSViewBuilderProtocol {
    public let modelKey = "radioBtnGroupOrgV2"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSRadioBtnGroupOrgV2Model = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSRadioBtnGroupOrgV2View()
        view.configure(with: data)
        view.setEventHandler(eventHandler)
        let insets = padding.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

// MARK: - Mock
extension DSRadioBtnGroupOrgV2Builder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSRadioBtnGroupOrgV2Model(
            componentId: "componentId",
            inputCode: "inputCode(optional)",
            mandatory: true,
            title: "title(optional)",
            items: [
                DSRadioGroupItemV2(
                    radioBtnMlcV2:
                        DSRadioBtnMlcV2Model(
                            componentId: "componentId",
                            id: "id(optional)",
                            iconLeft: .mock,
                            iconRight: .mock,
                            iconBigRight: .mock,
                            label: "label",
                            description: "description(optional)",
                            status: "status(optional)",
                            isSelected: true,
                            isEnabled: true,
                            dataJson: .string("")
                        )
                ),
                DSRadioGroupItemV2(
                    radioBtnMlcV2:
                        DSRadioBtnMlcV2Model(
                            componentId: "componentId",
                            id: "id(optional)",
                            iconLeft: .mock,
                            iconRight: .mock,
                            iconBigRight: .mock,
                            label: "label2",
                            description: "description(optional)",
                            status: "status(optional)",
                            isSelected: false,
                            isEnabled: true,
                            dataJson: .string("")
                        )
                )
            ],
            btnPlainIconAtm: .mock
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
