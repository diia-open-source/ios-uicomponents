
public struct BankingCardMlc: Codable {
    public let componentId: String?
    public let id: String?
    public let title: String
    public let image: String? // String URL
    public let gradient: String? // Gradient code
    public let paymentSystemLogo: String?
    public let cardNumMask: String?
    public let expirationDate: String?
    public let logos: [MediumIconAtm]
    public let description: String?
    public let action: DSActionParameter?
}

public struct MediumIconAtm: Codable {
    public let mediumIconAtm: DSIconModel
}

public enum BankingCardType {
    case image, gradient, empty
}

import DiiaCommonTypes

public class BankingCardViewModel {
    public let title: String
    public let image: String?
    public let gradient: String?
    public let paymentSystemLogo: String?
    public let cardNumMask: String?
    public let expirationDate: String?
    public let logos: [DSIconModel]
    public let description: String?
    public let type: BankingCardType
    public let action: Callback
    
    public init(model: BankingCardMlc,
                action: @escaping Callback) {
        self.title = model.title
        self.image = model.image
        self.gradient = model.gradient
        self.paymentSystemLogo = model.paymentSystemLogo
        self.cardNumMask = model.cardNumMask
        self.expirationDate = model.expirationDate
        self.logos = model.logos.map({ $0.mediumIconAtm })
        self.description = model.description
        self.action = action
        self.type = model.description != nil ? .empty : model.image != nil ? .image : .gradient
    }
}
