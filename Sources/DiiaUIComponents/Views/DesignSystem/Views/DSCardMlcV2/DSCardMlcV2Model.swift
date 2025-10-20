
import Foundation

public class DSCardMlcV2ViewModel {
    public let componentId: String?
    public let chipStatusAtm: DSCardStatusChipModel?
    public let label: String
    public let rightLabel: String?
    public let descriptions: [String]?
    public let rows: [String]?
    public let chips: [DSCardStatusChipMlc]?
    public let iconUrlAtm: DSIconUrlAtmModel?
    public let smallIconAtm: DSIconModel?
    public let smallIconAtmState: Observable<String> = .init(value: .empty)
    public let smallIconAtmStates: [DSSmallIconAtmState]
    public let attentionIconMessageMlc: DSAttentionIconMessageMlc?
    public let action: DSActionParameter?

    public var onTap: ((DSActionParameter?) -> Void)?

    public var currentStateIconModel: DSIconModel? {
        return smallIconAtmStates.first(where: { $0.name == smallIconAtmState.value })?.icon
    }

    public init(componentId: String?,
                chipStatusAtm: DSCardStatusChipModel?,
                label: String,
                rightLabel: String?,
                descriptions: [String]?,
                rows: [String]?,
                chips: [DSCardStatusChipMlc]?,
                iconUrlAtm: DSIconUrlAtmModel?,
                smallIconAtm: DSIconModel?,
                smallIconAtmWithStates: DSSmallIconAtmWithStatesModel?,
                attentionIconMessageMlc: DSAttentionIconMessageMlc?,
                action: DSActionParameter?) {
        self.componentId = componentId
        self.chipStatusAtm = chipStatusAtm
        self.label = label
        self.rightLabel = rightLabel
        self.descriptions = descriptions
        self.rows = rows
        self.chips = chips
        self.iconUrlAtm = iconUrlAtm
        self.smallIconAtm = smallIconAtm
        self.attentionIconMessageMlc = attentionIconMessageMlc
        self.action = action

        if let smallIconAtmWithStates {
            self.smallIconAtmState.value = smallIconAtmWithStates.currentState
            self.smallIconAtmStates = smallIconAtmWithStates.states
        } else {
            self.smallIconAtmStates = []
        }
}

    public init(model: DSCardMlcV2Model) {
        self.componentId = model.componentId
        self.chipStatusAtm = model.chipStatusAtm
        self.label = model.label
        self.rightLabel = model.rightLabel
        self.descriptions = model.descriptions
        self.rows = model.rows
        self.chips = model.chips
        self.iconUrlAtm = model.iconUrlAtm
        self.smallIconAtm = model.smallIconAtm
        self.attentionIconMessageMlc = model.attentionIconMessageMlc
        self.action = model.action

        if let smallIconAtmWithStates = model.smallIconAtmWithStates {
            self.smallIconAtmState.value = smallIconAtmWithStates.currentState
            self.smallIconAtmStates = smallIconAtmWithStates.states
        } else {
            self.smallIconAtmStates = []
        }
    }
}

public struct DSCardMlcV2Model: Codable {
    public let componentId: String?
    public let chipStatusAtm: DSCardStatusChipModel?
    public let label: String
    public let rightLabel: String?
    public let descriptions: [String]?
    public let rows: [String]?
    public let chips: [DSCardStatusChipMlc]?
    public let iconUrlAtm: DSIconUrlAtmModel?
    public let smallIconAtm: DSIconModel?
    public let smallIconAtmWithStates: DSSmallIconAtmWithStatesModel?
    public let attentionIconMessageMlc: DSAttentionIconMessageMlc?
    public let action: DSActionParameter?
   
    public init(componentId: String?,
                chipStatusAtm: DSCardStatusChipModel?,
                label: String,
                rightLabel: String?,
                descriptions: [String]?,
                rows: [String]?,
                chips: [DSCardStatusChipMlc]?,
                iconUrlAtm: DSIconUrlAtmModel?,
                smallIconAtm: DSIconModel?,
                smallIconAtmWithStates: DSSmallIconAtmWithStatesModel?,
                attentionIconMessageMlc: DSAttentionIconMessageMlc?,
                action: DSActionParameter?) {
        self.componentId = componentId
        self.chipStatusAtm = chipStatusAtm
        self.label = label
        self.rightLabel = rightLabel
        self.descriptions = descriptions
        self.rows = rows
        self.chips = chips
        self.iconUrlAtm = iconUrlAtm
        self.smallIconAtm = smallIconAtm
        self.smallIconAtmWithStates = smallIconAtmWithStates
        self.attentionIconMessageMlc = attentionIconMessageMlc
        self.action = action
    }
}

public struct DSCardStatusChipMlc: Codable {
    public let chipStatusAtm: DSCardStatusChipModel
    
    public init(chipStatusAtm: DSCardStatusChipModel) {
        self.chipStatusAtm = chipStatusAtm
    }
}
