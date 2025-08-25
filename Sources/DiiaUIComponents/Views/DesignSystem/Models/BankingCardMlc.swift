
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
    
    public init(componentId: String?,
         id: String? = nil,
         title: String,
         image: String? = nil,
         gradient: String? = nil,
         paymentSystemLogo: String? = nil,
         cardNumMask: String? = nil,
         expirationDate: String? = nil,
         logos: [MediumIconAtm],
         description: String? = nil,
         action: DSActionParameter? = nil) {
        self.componentId = componentId
        self.id = id
        self.title = title
        self.image = image
        self.gradient = gradient
        self.paymentSystemLogo = paymentSystemLogo
        self.cardNumMask = cardNumMask
        self.expirationDate = expirationDate
        self.logos = logos
        self.description = description
        self.action = action
    }
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
