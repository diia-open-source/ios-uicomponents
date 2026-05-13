
import Foundation
import DiiaCommonTypes

public struct DSCheckboxMlcModel: Codable {
    public let id: String
    public let componentId: String?
    public let inputCode: String?
    public let label: String
    public let description: String?
    public let descriptions: [String]?
    public let isSelected: Bool?
    public let isEnabled: Bool?

    public init(
        id: String,
        label: String,
        componentId: String? = nil,
        inputCode: String? = nil,
        description: String? = nil,
        descriptions: [String]? = nil,
        isSelected: Bool? = nil,
        isEnabled: Bool? = nil
    ) {
        self.id = id
        self.componentId = componentId
        self.inputCode = inputCode
        self.label = label
        self.description = description
        self.descriptions = descriptions
        self.isSelected = isSelected
        self.isEnabled = isEnabled
    }
    
    static let mock = DSCheckboxMlcModel(
        id: "id",
        label: "label",
        componentId: "componentId(optional)",
        inputCode: "inputCode(optional)",
        description: "description(optional)",
        descriptions: ["description 1(optional)", "description 2(optional)"],
        isSelected: nil,
        isEnabled: true
    )
}

public final class DSCheckboxMlcViewModel: NSObject {
    public let model: DSCheckboxMlcModel
    public var isSelected: Observable<Bool>
    public let isEnabled: Observable<Bool>
    public var onClick: Callback?

    public init(model: DSCheckboxMlcModel) {
        self.model = model
        self.isSelected = .init(value: model.isSelected ?? false)
        self.isEnabled = .init(value: model.isEnabled ?? true)
    }
}
