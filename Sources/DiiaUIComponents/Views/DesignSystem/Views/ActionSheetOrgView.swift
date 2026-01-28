
import UIKit
import DiiaCommonTypes

/// design_system_code: actionSheetOrg
public final class ActionSheetOrgView: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont,
                                                      textAlignment: .center).withHeight(Constants.titleHeight)
    private let listItemsStack = UIStackView.create()
    private lazy var mainStack = UIStackView.create(views: [titleLabel, listItemsStack])
    private let widePrimaryButton = DSPrimaryDefaultButton()

    // MARK: - Properties
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    
    // MARK: - Init
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = Constants.mainStackCornerRadius
        container.addSubview(mainStack)
        mainStack.fillSuperview(padding: .allSides(Constants.mainStackPadding))
        
        let globalStack = UIStackView.create(views: [container, widePrimaryButton],
                                             spacing: Constants.bottomIconPadding)
        addSubview(globalStack)
        globalStack.fillSuperview()
    }
    
    public func configure(model: ActionSheetOrg, eventHandler: ((ConstructorItemEvent) -> Void)?) {
        self.accessibilityIdentifier = model.componentId
        self.eventHandler = eventHandler
        
        titleLabel.isHidden = model.title == nil
        titleLabel.text = model.title
        
        for listItemCodable in model.items {
            if let listItem: DSListGroupItem = listItemCodable.parseValue(forKey: Constants.listItemMlc) {
                if !listItemsStack.arrangedSubviews.isEmpty {
                    listItemsStack.addArrangedSubview(makeSeparator())
                }
                let itemView = DSListItemView()
                itemView.configure(viewModel: .init(item: listItem,
                                                    onClick: {[weak self] in
                    if let action = listItem.action {
                        self?.eventHandler?(.action(action))
                    }
                }))
                listItemsStack.addArrangedSubview(itemView)
            }
        }
        
        widePrimaryButton.isHidden = model.btnWhiteLargeAtm == nil
        if let data = model.btnWhiteLargeAtm {
            let buttonBuilder = DSWhiteLargeButtonBuilder()
            buttonBuilder.configure(button: widePrimaryButton, for: data, eventHandler: eventHandler)
        }
    }
    
    private func makeSeparator() -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(AppConstants.Colors.separatorColor)
        separator.withHeight(Constants.separatorHeight)
        return separator
    }
}

// MARK: - Constants
private extension ActionSheetOrgView {
    enum Constants {
        static let listItemMlc = "listItemMlc"
        static let titleHeight: CGFloat = 48
        static let mainStackCornerRadius: CGFloat = 16
        static let bottomIconPadding: CGFloat = 8
        static let mainStackPadding: CGFloat = 16
        static let separatorHeight: CGFloat = 1
    }
}
