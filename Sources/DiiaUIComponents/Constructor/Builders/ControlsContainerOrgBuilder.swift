
import UIKit
import DiiaCommonTypes

/// design_system_code: controlsContainerOrg
public struct ControlsContainerOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "controlsContainerOrg"

    public func makeView(
        from object: AnyCodable,
        withPadding padding: DSViewPaddingType,
        viewFabric: DSViewFabric?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
            guard let model: ControlsContainerOrgModel = object.parseValue(forKey: self.modelKey) else { return nil }

            let view = ControlsContainerOrgView()

            if let viewFabric {
                view.setupFabric(viewFabric)
            }
            let vm = ControlsContainerOrgViewModel(model: model, eventHandler: eventHandler)
            view.configure(vm)

            let insets = padding.defaultPadding(object: object, modelKey: modelKey)
            let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
            return paddingBox
    }
}

extension ControlsContainerOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = ControlsContainerOrgModel(
            componentId: "componentId",
            inputCode: "inputCode",
            mandatory: true,
            minMandatorySelectedItems: 2,
            maxMandatorySelectedItems: 2,
            controlType: .multipleChoice,
            items: [
                ControlsItemOrgModel(
                    componentId: "componentId",
                    paddingMode: .init(top: .none, side: .none),
                    selectorItem: AnyCodable.dictionary(["checkBoxSquareAtm": AnyCodable.dictionary([:])]),
                    size: .medium,
                    alignment: .center,
                    item: DSTextLabelBuilder().makeMockModel(),
                    code: "1",
                    isSelected: false,
                    isEnabled: true,
                    innerSideSpacer: .none),
                ControlsItemOrgModel(
                    componentId: "componentId2",
                    paddingMode: .init(top: .none, side: .none),
                    selectorItem: AnyCodable.dictionary(["checkBoxSquareAtm": AnyCodable.dictionary([:])]),
                    size: .small,
                    alignment: .top,
                    item: DSTitleLabelBuilder().makeMockModel(),
                    code: "2",
                    isSelected: true,
                    isEnabled: false,
                    innerSideSpacer: .small),
                ControlsItemOrgModel(
                    componentId: "componentId3",
                    paddingMode: .init(top: .none, side: .none),
                    selectorItem: AnyCodable.dictionary(["radioButtonAtm": AnyCodable.dictionary([:])]),
                    size: .medium,
                    alignment: .top,
                    item: DSTitleLabelBuilder().makeMockModel(),
                    code: "3",
                    isSelected: false,
                    isEnabled: true,
                    innerSideSpacer: .small),
            ],
            btnPrimaryAdditionalAtm: DSButtonModel.mock
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
