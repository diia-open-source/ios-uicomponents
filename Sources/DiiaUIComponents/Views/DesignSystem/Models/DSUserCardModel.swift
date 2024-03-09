import Foundation

public struct DSUserCardModel: Codable {
    public let componentId: String?
    public let userPictureAtm: DSUserPictureModel
    public let label: String
    public let description: String?
}

public struct DSUserPictureModel: Codable {
    public let componentId: String?
    public let useDocPhoto: Bool?
    public let defaultImageCode: DSUserPictureCode?
    public let action: DSActionParameter?
}

public enum DSUserPictureCode: String, Codable {
    case userFemale
    case userMale
}
