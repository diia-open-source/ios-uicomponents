
import UIKit
import DiiaCommonTypes

public class DSRadioBtnWithAltOrgBuilder: DSViewBuilderProtocol {
    
    public let modelKey = "radioBtnWithAltOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSRadioBtnWithAltOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSRadioBtnWithAltView()
        view.accessibilityIdentifier = data.componentId
        let viewModel = DSRadioBtnWithAltViewModel(eventHandler: eventHandler,
                                                   items: data.items)
        view.configure(with: viewModel)
        
        let insets = paddingType.defaultPadding(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSRadioBtnWithAltOrgBuilder {
    enum Constants {
        static let altGroupSpacing: CGFloat = 16
    }
}

// MARK: - Mock
extension DSRadioBtnWithAltOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSRadioBtnWithAltOrg(
            componentId: "componentId",
            items: [
                DSRadioBtnGroupItem(
                    radioBtnGroupOrg: DSRadioBtnGroupOrg(
                        id: "id(optional)",
                        blocker: true,
                        title: "title(optional)",
                        condition: "condition(optional)",
                        items: [
                            DSRadioGroupItem(
                                condition: "condition(optional)",
                                radioBtnMlc: DSRadioButtonMlc(
                                    id: "id(optional)",
                                    label: "label",
                                    status: "status(optional)",
                                    type: .selected,
                                    additionalInfo: DSRadioButtonAdditionalInfo(
                                        label: "label",
                                        placeholder: "placeholder",
                                        value: "value(optional)",
                                        validation: InputValidationModel(
                                            regexp: "^([a-zA-Z0-9_%+-]{1,}\\.){0,}[a-zA-Z0-9_%+-]{1,}@([a-zA-Z0-9_%+-]{1,}\\.){1,}(?!ru|su)[A-Za-z]{2,64}$",
                                            flags: ["i"],
                                            errorMessage: "Error message"
                                        )
                                    ),
                                    componentId: "componentId(optional)",
                                    logoLeft: "logoLeft(optional)",
                                    logoRight: "logoRight(optional)",
                                    largeLogoRight: "largeLogoRight(optional)",
                                    description: "description(optional)",
                                    isSelected: true,
                                    isEnabled: true,
                                    dataJson: .string("")
                                )
                            )
                        ],
                        componentId: "componentId(optional)",
                        inputCode: "email",
                        mandatory: true,
                        btnPlainIconAtm: .mock
                    )
                ),
                DSRadioBtnGroupItem(
                    radioBtnGroupOrg: DSRadioBtnGroupOrg(
                        id: "id(optional)",
                        blocker: true,
                        title: "title(optional)",
                        condition: "condition(optional)",
                        items: [
                            DSRadioGroupItem(
                                condition: "condition(optional)",
                                radioBtnMlc: DSRadioButtonMlc(
                                    id: "id(optional)",
                                    label: "label",
                                    status: "status(optional)",
                                    type: .rest,
                                    additionalInfo: DSRadioButtonAdditionalInfo(
                                        label: "label",
                                        placeholder: "placeholder",
                                        value: "value(optional)",
                                        validation: InputValidationModel(
                                            regexp: "^([a-zA-Z0-9_%+-]{1,}\\.){0,}[a-zA-Z0-9_%+-]{1,}@([a-zA-Z0-9_%+-]{1,}\\.){1,}(?!ru|su)[A-Za-z]{2,64}$",
                                            flags: ["i"],
                                            errorMessage: "Error message"
                                        )
                                    ),
                                    componentId: "componentId(optional)",
                                    logoLeft: "logoLeft(optional)",
                                    logoRight: "logoRight(optional)",
                                    largeLogoRight: "largeLogoRight(optional)",
                                    description: "description(optional)",
                                    isSelected: false,
                                    isEnabled: true,
                                    dataJson: .string("")
                                )
                            )
                        ],
                        componentId: "componentId(optional)",
                        inputCode: "email",
                        mandatory: true,
                        btnPlainIconAtm: .mock
                    )
                )
            ]
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
