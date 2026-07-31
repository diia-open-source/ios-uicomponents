
import UIKit
import DiiaCommonTypes

public enum DSPhotoUploadState {
    case normal
    case loading
    case preview
    case error(String?)
}

public final class DSPhotoUploadMlcViewModel: NSObject {
    public let componentId: String?
    public let inputCode: String?
    public let title: String?
    public let descriptionText: String?
    public let mandatory: Bool?
    public let iconCenter: DSIconModel?
    public let iconRight: DSIconModel?
    public let action: DSActionParameter?
    public let state: Observable<DSPhotoUploadState> = .init(value: .normal)
    public let image: Observable<UIImage?> = .init(value: nil)
    public var uploadedId: String?
    public var onTap: Callback?
    public var onUploadSuccess: Callback?
    public var onDelete: Callback?
    
    // MARK: - Init
    public init(
        componentId: String? = nil,
        inputCode: String? = nil,
        title: String? = nil,
        mandatory: Bool? = nil,
        descriptionText: String? = nil,
        action: DSActionParameter?,
        iconCenter: DSIconModel? = nil,
        iconRight: DSIconModel? = nil)
    {
        self.componentId = componentId
        self.inputCode = inputCode
        self.title = title
        self.mandatory = mandatory
        self.descriptionText = descriptionText
        self.action = action
        self.iconCenter = iconCenter
        self.iconRight = iconRight
        super.init()
    }
    
    // MARK: - Public
    public func reset() {
        uploadedId = nil
        image.value = nil
        state.value = .normal
    }
}
