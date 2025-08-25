
import Foundation
import DiiaCommonTypes

/// design_system_code: stubMessageMlc

public struct DSStubMessageMlc: Codable {
    public let icon: String?
    public let title: String
    public let description: String?
    public let componentId: String?
    public let parameters: [TextParameter]?
    public let btnStrokeAdditionalAtm: DSButtonModel?
    
    public init(icon: String?, title: String, description: String?, componentId: String?, parameters: [TextParameter]?, btnStrokeAdditionalAtm: DSButtonModel?) {
        self.icon = icon
        self.title = title
        self.description = description
        self.componentId = componentId
        self.parameters = parameters
        self.btnStrokeAdditionalAtm = btnStrokeAdditionalAtm
    }
    
    static let mock = DSStubMessageMlc(
        icon: "👍(optional)",
        title: "title",
        description: "description(optional)",
        componentId: "componentId(optional)",
        parameters: [
            TextParameter(
                type: .link,
                data: TextParameterData(name: "name", alt: "alt", resource: "resource")
            )
        ],
        btnStrokeAdditionalAtm: .mock
    )
}
