
import Foundation

public struct DSDocActivateCardModel: Codable {
    public let componentId: String
    public let image: String
    public let title: String
    public let description: String
    public let btnStrokeDefaultAtm: DSButtonModel
    public let btnPlainAtm: DSButtonModel?
    
    public init(
        componentId: String,
        image: String,
        title: String,
        description: String,
        btnStrokeDefaultAtm: DSButtonModel,
        btnPlainAtm: DSButtonModel? = nil
    ) {
        self.componentId = componentId
        self.image = image
        self.title = title
        self.description = description
        self.btnStrokeDefaultAtm = btnStrokeDefaultAtm
        self.btnPlainAtm = btnPlainAtm
    }
}
