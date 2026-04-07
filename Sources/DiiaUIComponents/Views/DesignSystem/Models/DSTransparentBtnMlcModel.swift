
///ds_code: transparentBtnMlc
public struct DSTransparentBtnMlcModel: Codable {
    public let componentId: String
    public let label: String
    public let iconRight: DSIconModel
    public let action: DSActionParameter?
    public let state: DSButtonState?
}
