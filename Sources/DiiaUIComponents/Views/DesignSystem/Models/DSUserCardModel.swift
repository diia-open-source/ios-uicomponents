
import UIKit

public struct DSUserCardModel: Codable {
    public let componentId: String?
    public let userPictureAtm: DSUserPictureModel
    public let label: String
    public let description: String?
}

public class DSUserPictureModel: Codable {
    public let componentId: String?
    public var useDocPhoto: Bool?
    public let defaultImageCode: DSUserPictureCode?
    public var userPhoto: String?
    public let action: DSActionParameter?
    
    init(componentId: String?,
         useDocPhoto: Bool?,
         defaultImageCode: DSUserPictureCode?,
         userPhoto: String?,
         action: DSActionParameter?) {
        self.componentId = componentId
        self.useDocPhoto = useDocPhoto
        self.defaultImageCode = defaultImageCode
        self.userPhoto = userPhoto
        self.action = action
    }
}

public enum DSUserPictureCode: String, Codable {
    case userFemale
    case userMale
}
