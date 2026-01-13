
import UIKit

public struct DSAttachmentsOrg: Codable {
    public let componentId: String
    public let inputCode: String?
    public let minNumber: Double?
    public let maxNumber: Double?
    public let mandatory: Bool?
    public let items: [DSAttachmentCardMlc]
    public let btnAddOptionAtm: DSBtnAddOptionAtm?
}

//ds_code: "attachmentsOrg"
final public class DSAttachmentsOrgView: BaseCodeView {
    private let mainStack = UIStackView.create(.vertical, spacing: Constants.spacing)
    private let itemsStack = UIStackView.create(.vertical, spacing: Constants.spacing)
    private let addButton = DSBtnAddOptionAtmView()
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
        mainStack.addArrangedSubviews([itemsStack,
                                       addButton])
        self.backgroundColor = .clear
    }
    
    public func configure(with model: DSAttachmentsOrg, eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
        itemsStack.safelyRemoveArrangedSubviews()
        self.accessibilityIdentifier = model.componentId
        
        addButton.isHidden = model.btnAddOptionAtm == nil
        if let btnAddOptionAtm = model.btnAddOptionAtm {
            addButton.configure(with: btnAddOptionAtm, eventHandler: eventHandler)
        }
        itemsStack.isHidden = model.items.isEmpty
        model.items.forEach { item in
            let attachMlc = DSAttachmentCardMlcView()
            attachMlc.configure(with: item, eventHandler: eventHandler)
            itemsStack.addArrangedSubview(attachMlc)
        }
    }
}

private extension DSAttachmentsOrgView {
    enum Constants {
        static let spacing: CGFloat = 16
    }
}
