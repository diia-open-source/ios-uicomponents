
import Foundation
import DiiaCommonTypes

public struct DSSwitchItemMlcModel: Codable {
    public let componentId: String?
    public let title: String
    public let description: String?
    public let inputCode: String
    public let isSelected: Bool?
    public let iconLeft: String?

    public init(
        componentId: String? = nil,
        title: String,
        description: String? = nil,
        inputCode: String,
        isSelected: Bool? = nil,
        iconLeft: String? = nil
    ) {
        self.componentId = componentId
        self.title = title
        self.description = description
        self.inputCode = inputCode
        self.isSelected = isSelected
        self.iconLeft = iconLeft
    }

    static let mock = DSSwitchItemMlcModel(
        componentId: "componentId(optional)",
        title: "Title",
        description: "description(optional)",
        inputCode: "inputCode",
        isSelected: false,
        iconLeft: "icon(optional)"
    )
}

public final class DSSwitchItemMlcViewModel {
    public let model: DSSwitchItemMlcModel
    public var isSelected: Observable<Bool>
    public var onClick: Callback?

    public init(model: DSSwitchItemMlcModel) {
        self.model = model
        self.isSelected = .init(value: model.isSelected ?? false)
    }
}
