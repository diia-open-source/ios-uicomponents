
import UIKit
import DiiaCommonTypes

public struct DSAttachmentCardBuilder: DSViewBuilderProtocol {
    public let modelKey = "attachmentsOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSAttachmentsOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        
        let view = DSAttachmentsOrgView()
        view.configure(with: data, eventHandler: eventHandler)
        let paddingBox = BoxView(subview: view).withConstraints(insets: padding.defaultPaddingV2(object: object, modelKey: modelKey))
        return paddingBox
    }
}

extension DSAttachmentCardBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSAttachmentsOrg(
            componentId: "attach",
            inputCode: "attachmentOrg",
            minNumber: nil,
            maxNumber: nil,
            mandatory: false,
            items: [
                .init(attachmentCardMlc: DSAttachmentCard(componentId: "attachMlc",
                                                          id: "1",
                                                          chipStatusAtm: DSCardStatusChipModel(code: "attach",
                                                                                               name: "Test",
                                                                                               type: .pending,
                                                                                               componentId: "chip"),
                                                          iconRight: .mock,
                                                          label: "Test Test Test",
                                                          description: "Description Test",
                                                          key: DSAttachmentCardKey(id: "1",
                                                                                   label: "Key",
                                                                                   description: "Key description",
                                                                                   iconRight: .mock),
                                                          btnIconPlainGroupMlc: DSBtnIconPlainGroupMlc(
                                                            items: [DSBtnPlainIconAtm(btnPlainIconAtm:
                                                                                        DSBtnPlainIconModel(label: "Add attachment",
                                                                                                            icon: "",
                                                                                                            action: nil,
                                                                                                            componentId: "btnPlain"))],
                                                            componentId: "btnPlain")))
            ],
            btnAddOptionAtm: DSBtnAddOptionAtm(
                componentId: "addOption",
                label: "Add Document",
                description: "Upload Document",
                iconLeft: .mock,
                state: .enabled,
                action: nil))
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}
