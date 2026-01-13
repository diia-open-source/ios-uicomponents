
import UIKit
import DiiaCommonTypes

public struct DSGroupFilesAddModel: Codable {
    public let componentId: String?
    public let items: [DSListItemModel]
    public let btnPlainIconAtm: DSBtnPlainIconModel
}

public struct DSListItemModel: Codable {
    public let listItemMlc: DSListItemMlcModel
}

public struct DSListItemMlcModel: Codable {
    public let componentId: String?
    public let id: String?
    public let label: String
    public let description: String?
    public let iconRight: DSIconModel?
    public let action: DSActionParameter?
    public let type: String?
}

public final class DSGroupFilesAddViewModel {
    public let componentId: String?
    public let items: [DSListItemViewModel]
    public let buttonAction: Action
    
    public init(componentId: String?, items: [DSListItemViewModel], buttonAction: Action) {
        self.componentId = componentId
        self.items = items
        self.buttonAction = buttonAction
    }
}

public final class DSGroupFilesAddView: BaseCodeView {
    private let mainStack =  UIStackView.create()
    private let buttonStack = UIStackView.create()
    private let filesStack = UIStackView.create()
    private let addButton = ActionButton()
    
    public override func setupSubviews() {
        addSubview(mainStack)
        mainStack.fillSuperview()
        self.backgroundColor = .white
        self.layer.cornerRadius = Constants.cornerRadius
        
        buttonStack.addArrangedSubviews([
            addButton
        ])
        
        mainStack.addArrangedSubviews([
            filesStack,
            buttonStack
        ])
        
        addButton.type = .full
        addButton.setupUI(font: FontBook.usualFont, bordered: false, textColor: .black, secondaryColor: .clear, imageRenderingMode: .alwaysOriginal, contentHorizontalAlignment: .center)
        addButton.withHeight(Constants.buttonHeight)
        addButton.titleEdgeInsets = Constants.buttonTitleEdgeInsets
    }
    
    public func configure(with viewModel: DSGroupFilesAddViewModel) {
        filesStack.safelyRemoveArrangedSubviews()
        filesStack.isHidden = viewModel.items.isEmpty
        
        viewModel.items.forEach { item in
            let view = DSListItemView()
            view.configure(viewModel: item)
            filesStack.addArrangedSubviews([
                view,
                addSeparator()
            ])
        }
        addButton.action = viewModel.buttonAction
    }
    
    private func addSeparator() -> UIView {
        let separatorView = UIView().withHeight(2)
        separatorView.backgroundColor = Constants.separatorColor
        return separatorView
    }
}

private extension DSGroupFilesAddView {
    enum Constants {
        static let buttonTitleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 0)
        static let cornerRadius: CGFloat = 8
        static let separatorColor = UIColor("#E2ECF4")
        static let buttonHeight: CGFloat = 56
    }
}
