
import UIKit
import DiiaCommonTypes

/// design_system_code: scanModalCardOrg
public final class ScanModalCardView: BaseCodeView {
    private let chipStatusAtmView = DSChipStatusAtmView()
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText)
    private let descriptionLabel = UILabel().withParameters(font: FontBook.bigText)
    private let tableItemsStack = UIStackView.create()
    private let attentionIconMessageView = DSAttentionIconMessageView()
    private let listItemsStack = UIStackView.create()
    private let listItemView = DSListItemView()
    private let bottomIcon = DSIconView().withSize(Constants.mediumIconSize)
    private var eventHandler: ((ConstructorItemEvent) -> Void)?
    // MARK: - Subviews
    
    // MARK: - Init
    public override func setupSubviews() {
        let mainStack = UIStackView.create(
            views: [chipStatusAtmView, titleLabel, descriptionLabel, tableItemsStack, attentionIconMessageView, listItemsStack],
            spacing: Constants.stackSpacing)
        
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = Constants.mainStackCornerRadius
        container.addSubview(mainStack)
        mainStack.fillSuperview(padding: Constants.mainStackPadding)
        
        addSubview(container)
        container.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor
        )
        
        addSubview(bottomIcon)
        bottomIcon.anchor(
            top: container.bottomAnchor,
            bottom: bottomAnchor,
            padding: Constants.bottomIconPadding
        )
        bottomIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    public func configure(model: ScanModalCardOrg, eventHandler: ((ConstructorItemEvent) -> Void)?) {
        accessibilityIdentifier = model.componentId
        self.eventHandler = eventHandler
        chipStatusAtmView.isHidden = model.chipStatusAtm == nil
        if let chipStatusAtm = model.chipStatusAtm {
            chipStatusAtmView.configure(for: chipStatusAtm)
        }
        titleLabel.text = model.title
        descriptionLabel.isHidden = model.description == nil
        descriptionLabel.text = model.description
        attentionIconMessageView.isHidden = model.attentionIconMessageMlc == nil
        if let attentionIconMsgMlc = model.attentionIconMessageMlc {
            attentionIconMessageView.configure(with: attentionIconMsgMlc)
        }
        listItemView.isHidden = model.items == nil
        for listItem in model.items ?? [] {
            if listItemsStack.arrangedSubviews.isEmpty {
                listItemsStack.addArrangedSubview(makeSeparator())
            }
            let itemView = DSListItemView()
            itemView.configure(viewModel: .init(item: listItem.listItemMlc,
                                 onClick: {[weak self] in
                                     if let action = listItem.listItemMlc.action {
                                         self?.eventHandler?(.action(action))
                                     }
                                 })
            )
            listItemsStack.addArrangedSubview(itemView)
        }
        bottomIcon.isHidden = model.mediumIconAtm == nil
        if let mediumIconAtm = model.mediumIconAtm {
            bottomIcon.setIcon(mediumIconAtm)
            bottomIcon.onClick = { [weak self] action in
                guard let action else { return }
                self?.eventHandler?(.action(action))
            }
        }
    
        tableItemsStack.isHidden = model.tableItems == nil || model.tableItems?.isEmpty == true
        for tableItem in model.tableItems ?? [] {
            let horizontalMlcbuilder = DSTableItemHorizontalMlcBuilder()
            let verticalMlcBuilder = DSTableItemVerticalMlcBuilder()
            if !tableItemsStack.arrangedSubviews.isEmpty {
                tableItemsStack.addArrangedSubview(makeSeparator())
            }
            if let tableItemHorizontalMlc = tableItem.tableItemHorizontalMlc {
                let tableHorizontalView = BoxView(
                    subview: horizontalMlcbuilder.makeView(model: tableItemHorizontalMlc))
                    .withConstraints(insets: Constants.padding)
                tableItemsStack.addArrangedSubview(tableHorizontalView)
            }
            if let tableItemVerticalMlc = tableItem.tableItemVerticalMlc {
                let tableVerticalView = BoxView(
                    subview: verticalMlcBuilder.makeVerticalView(model: tableItemVerticalMlc, eventHandler: eventHandler))
                    .withConstraints(insets: Constants.padding)
                tableItemsStack.addArrangedSubview(tableVerticalView)
            }
        }
    }
    
    private func makeSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(AppConstants.Colors.separatorColor)
        separator.withHeight(Constants.separatorHeight)
        return separator
    }
}

private extension ScanModalCardView {
    enum Constants {
        static let mediumIconSize = CGSize(width: 48, height: 48)
        static let stackSpacing: CGFloat = 16
        static let mainStackCornerRadius: CGFloat = 16
        static let contentStackSpacing: CGFloat = 8
        static let mainStackPadding = UIEdgeInsets(horizontal: 24, vertical: 24)
        static let bottomIconPadding = UIEdgeInsets(top: 24)
        static let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let separatorHeight: CGFloat = 1
    }
}
