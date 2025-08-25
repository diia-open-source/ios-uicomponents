
import Foundation

public struct DSSmallIconAtmWithStatesModel: Codable {
    public let currentState: String
    public let states: [DSSmallIconAtmState]

    public init(currentState: String, states: [DSSmallIconAtmState]) {
        self.currentState = currentState
        self.states = states
    }
}

public struct DSSmallIconAtmState: Codable {
    public let name: String
    public let icon: DSIconModel

    public init(name: String, icon: DSIconModel) {
        self.name = name
        self.icon = icon
    }
}
