
import UIKit
import DiiaCommonTypes

public class DSCheckboxBtnWhiteOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "checkboxBtnWhiteOrg"
    private let checkboxBuilder = DSCheckboxButtonOrgBuilder()
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let model: DSCheckboxBtnOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = checkboxBuilder.makeView(model: model, eventHandler: eventHandler)
        view.layer.borderColor = nil
        view.layer.borderWidth = .zero
        view.layer.cornerRadius = Constants.cornerRadius
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPadding(object: object, modelKey: modelKey))
        paddingBox.subview.backgroundColor = .white
        return paddingBox
    }
}

extension DSCheckboxBtnWhiteOrgBuilder: DSViewMockableBuilderProtocol {
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
                            DSCheckboxOption(id: "option_1", isSelected: true),
                            DSCheckboxOption(id: "option_2", isSelected: false)
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
                            DSCheckboxOption(id: "option_3", isSelected: false)
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

private extension DSCheckboxBtnWhiteOrgBuilder {
    enum Constants {
        static let cornerRadius: CGFloat = 16
    }
}
