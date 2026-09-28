import UIKit
import DiiaCommonTypes

public struct DSPaginationMessageMlcModel: Codable {
    public let componentId: String
    public let title: String?
    public let description: String?
    public let iconAtm: DSIconModel?
    public let parameters: [TextParameter]?
    public let btnStrokeAdditionalAtm: DSButtonModel?
    
    public init(componentId: String, title: String?, description: String?, iconAtm: DSIconModel? = nil, parameters: [TextParameter]? = nil, btnStrokeAdditionalAtm: DSButtonModel? = nil) {
        self.componentId = componentId
        self.title = title
        self.iconAtm = iconAtm
        self.description = description
        self.parameters = parameters
        self.btnStrokeAdditionalAtm = btnStrokeAdditionalAtm
    }

    static let mock = DSPaginationMessageMlcModel(
        componentId: "componentId",
        title: "title",
        description: "description",
        iconAtm: .mock,
        btnStrokeAdditionalAtm: .mock
    )
}

final public class DSPaginationMessageMlcView: BaseCodeView {
    private let mainStack = UIStackView.create(.vertical, spacing: Constants.bigSpacing, alignment: .center)
    private let textStack =  UIStackView.create(.vertical, spacing: Constants.smallSpacing, alignment: .center)
    private let iconView = DSIconView().withSize(Constants.iconSize)
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let descriptionTextView = LinkOnlyTextView()
    private let button = ActionLoadingStateButton()
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.insets)
        textStack.addArrangedSubviews([
            titleLabel,
            descriptionTextView
        ])
        mainStack.addArrangedSubviews([
            iconView,
            textStack,
            button
        ])
        button.titleLabel?.font = FontBook.usualFont
        button.withHeight(Constants.buttonHeight)
        button.setStyle(style: .light)
        button.contentEdgeInsets = Constants.buttonEdgeInsets
        titleLabel.textAlignment = .center
        descriptionTextView.font = FontBook.usualFont
        descriptionTextView.textAlignment = .center
        descriptionTextView.delegate = self
        backgroundColor = .clear
    }
    
    public func configure(with model: DSPaginationMessageMlcModel) {
        accessibilityIdentifier = model.componentId
        iconView.isHidden = model.iconAtm == nil
        if let iconAtm = model.iconAtm {
            iconView.setIcon(iconAtm)
        }
        titleLabel.isHidden = model.title == nil
        titleLabel.text = model.title
        
        descriptionTextView.isHidden = model.description == nil
        if let text = model.description {
            if let parameters = model.parameters, !parameters.isEmpty {
                descriptionTextView.attributedText = text.attributedTextWithParameters(parameters: parameters)
            } else {
                descriptionTextView.text = text
            }
        }
        
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
        descriptionTextView.textAlignment = alignment
    }
}

extension DSPaginationMessageMlcView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return !(UIComponentsConfiguration.shared.urlOpener?.url(urlString: URL.absoluteString, linkType: nil) ?? false)
    }
}

private extension DSPaginationMessageMlcView {
    enum Constants {
        static let bigSpacing: CGFloat = 16
        static let smallSpacing: CGFloat = 8
        static let iconSize: CGSize = .init(width: 32, height: 32)
        static let insets: UIEdgeInsets = .init(top: 24, left: 24, bottom: 24, right: 24)
        static let buttonHeight: CGFloat = 36
        static let buttonEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
    }
}
