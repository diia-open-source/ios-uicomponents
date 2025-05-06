
import Foundation

public struct DSInputNumberLargeModel: Codable {
    public let componentId: String?
    public let mandatory: Bool?
    public let items: [DSInputNumberLargeItem]
    
    public init(componentId: String? = nil, items: [DSInputNumberLargeItem], mandatory: Bool? = nil) {
        self.componentId = componentId
        self.mandatory = mandatory
        self.items = items
    }
}

public struct DSInputNumberLargeItem: Codable {
    public let inputNumberLargeAtm: DSInputNumberLargeItemData
    
    public init(inputNumberLargeAtm: DSInputNumberLargeItemData) {
        self.inputNumberLargeAtm = inputNumberLargeAtm
    }
}

public struct DSInputNumberLargeItemData: Codable {
    public let componentId: String?
    public let placeholder: String
    public let value: String?
    public let state: String?
    
    public init(
        componentId: String? = nil,
        placeholder: String,
        value: String? = nil,
        state: String? = nil
    ) {
        self.componentId = componentId
        self.placeholder = placeholder
        self.value = value
        self.state = state
    }
}
