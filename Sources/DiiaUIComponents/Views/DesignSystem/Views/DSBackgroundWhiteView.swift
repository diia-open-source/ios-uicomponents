
import DiiaCommonTypes
import UIKit

public class DSBackgroundWhiteViewModel {
    public let title: String?
    public let items: [AnyCodable]
    public let componentId: String?
    public let eventHandler: (ConstructorItemEvent) -> Void
    
    public init(title: String?,
                subviews: [AnyCodable],
                componentId: String?,
                eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.title = title
        self.items = subviews
        self.componentId = componentId
        self.eventHandler = eventHandler
    }
}

/// design_system_code: questionFormsOrg
public class DSBackgroundWhiteView: BaseCodeView {
    
    private let inputFieldsStack = UIStackView.create(spacing: Constants.stackSpacing)
    
    private var viewFabric = DSViewFabric.instance
    
    public override func setupSubviews() {
        super.setupSubviews()
        
        layer.cornerRadius = Constants.cornerRadius
        backgroundColor = .white
        
        addSubview(inputFieldsStack)
        inputFieldsStack.fillSuperview(padding: .allSides(Constants.contentPadding))
    }
    
    public func configure(for model: DSBackgroundWhiteViewModel) {
        accessibilityIdentifier = model.componentId
        inputFieldsStack.safelyRemoveArrangedSubviews()
        
        if let title = model.title {
            let titleLabel = UILabel().withParameters(font: FontBook.usualFont)
            titleLabel.text = title
            inputFieldsStack.addArrangedSubview(titleLabel)
        }
        for subview in model.items {
            if let subview = viewFabric.makeView(from: subview,
                                                 withPadding: .fixed(paddings: .zero),
                                                 eventHandler: model.eventHandler) {
                self.inputFieldsStack.addArrangedSubview(subview)
            }
        }
    }
    
    public func setFabric(_ fabric: DSViewFabric) {
        self.viewFabric = fabric
    }
}

extension DSBackgroundWhiteView {
    enum Constants {
        static let contentPadding: CGFloat = 16
        static let stackSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let loadingHeight: CGFloat = 56
    }
}
