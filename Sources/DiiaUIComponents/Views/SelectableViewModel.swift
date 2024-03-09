import Foundation

public class SelectableViewModel: NSObject {
    public let title: String
    public let code: String
    @objc dynamic public var isSelected: Bool {
        didSet {
            onChange?(isSelected)
        }
    }
    
    public var onChange: ((Bool) -> Void)?
    
    public init(
        title: String,
        code: String,
        isSelected: Bool = false,
        onChange: ((Bool) -> Void)? = nil
    ) {
        self.title = title
        self.code = code
        self.isSelected = isSelected
        self.onChange = onChange
    }
}
