
import Foundation

open class SelectableViewModel: NSObject {
    public let title: String
    public let code: String
    public let accessibilityDescription: String?

    @objc dynamic public var isSelected: Bool {
        didSet {
            onChange?(isSelected)
        }
    }
    
    public var onChange: ((Bool) -> Void)?
    
    public init(
        title: String,
        accessibilityDescription: String? = nil,
        code: String,
        isSelected: Bool = false,
        onChange: ((Bool) -> Void)? = nil
    ) {
        self.title = title
        self.code = code
        self.accessibilityDescription = accessibilityDescription
        self.isSelected = isSelected
        self.onChange = onChange
    }
}
