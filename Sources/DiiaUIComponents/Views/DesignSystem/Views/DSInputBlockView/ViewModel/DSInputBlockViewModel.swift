
import UIKit
import DiiaCommonTypes

public class DSInputBlockViewModel {
    public let componentId: String?
    public let tableMainHeadingViewModel: DSTableMainHeadingViewModel?
    public let tableSecondaryHeadingViewModel: DSTableMainHeadingViewModel?
    public let attentionIconMessageModel: DSAttentionIconMessageMlc?
    public let items: [AnyCodable]
    public let urlOpener: URLOpenerProtocol?
    public let eventHandler: (ConstructorItemEvent) -> Void
    
    public init(
        componentId: String?,
        tableMainHeadingViewModel: DSTableMainHeadingViewModel?,
        tableSecondaryHeadingViewModel: DSTableMainHeadingViewModel?,
        attentionIconMessageModel: DSAttentionIconMessageMlc?,
        items: [AnyCodable],
        urlOpener: URLOpenerProtocol?,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) {
        self.componentId = componentId
        self.tableMainHeadingViewModel = tableMainHeadingViewModel
        self.tableSecondaryHeadingViewModel = tableSecondaryHeadingViewModel
        self.attentionIconMessageModel = attentionIconMessageModel
        self.items = items
        self.urlOpener = urlOpener
        self.eventHandler = eventHandler
    }
}
