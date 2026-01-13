import UIKit

public struct DSPaginationMessageMlcModel: Codable {
    public let componentId: String
    public let title: String?
    public let description: String?
    public let btnStrokeAdditionalAtm: DSButtonModel?
    
    public init(componentId: String, title: String?, description: String?, btnStrokeAdditionalAtm: DSButtonModel?) {
        self.componentId = componentId
        self.title = title
        self.description = description
        self.btnStrokeAdditionalAtm = btnStrokeAdditionalAtm
    }

    static let mock = DSPaginationMessageMlcModel(
        componentId: "componentId",
        title: "title",
        description: "description",
        btnStrokeAdditionalAtm: .mock
    )
}

final public class DSPaginationMessageMlcView: BaseCodeView {
    private let mainStack = UIStackView.create(.vertical, spacing: Constants.bigSpacing, alignment: .center)
    private let textStack =  UIStackView.create(.vertical, spacing: Constants.smallSpacing, alignment: .center)
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont)
    private let button = ActionLoadingStateButton()
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.insets)
        textStack.addArrangedSubviews([
            titleLabel,
            descriptionLabel
        ])
        mainStack.addArrangedSubviews([
            textStack,
            button
        ])
        button.titleLabel?.font = FontBook.usualFont
        button.withHeight(Constants.buttonHeight)
        button.setStyle(style: .light)
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        titleLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        backgroundColor = .clear
    }
    
    public func configure(with model: DSPaginationMessageMlcModel) {
        accessibilityIdentifier = model.componentId
        titleLabel.isHidden = model.title == nil
        titleLabel.text = model.title
        
        descriptionLabel.isHidden = model.description == nil
        descriptionLabel.text = model.description
        
        button.isHidden = model.btnStrokeAdditionalAtm == nil
        if let button = model.btnStrokeAdditionalAtm {
            self.button.setLoadingState(.enabled, withTitle: model.btnStrokeAdditionalAtm?.label ?? .empty)
            self.button.onClick = { [weak self] in
                guard let action = button.action else { return }
                self?.eventHandler?(.action(action))
            }
        }
    }
    
    public func setEventHandler(_ eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }

    public func setDescriptionAlignment(_ alignment: NSTextAlignment) {
        descriptionLabel.textAlignment = alignment
    }
}

private extension DSPaginationMessageMlcView {
    enum Constants {
        static let bigSpacing: CGFloat = 16
        static let smallSpacing: CGFloat = 8
        static let insets: UIEdgeInsets = .init(top: 24, left: 24, bottom: 24, right: 24)
        static let buttonHeight: CGFloat = 36
        static let buttonEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
    }
}
