
import UIKit

public class DSTableBlockPlaneOrgView: BaseCodeView {
    
    let mainStack = UIStackView.create(.vertical, views: [], spacing: Constants.stackSpacing)
    let headingStack = UIStackView.create(.vertical, views: [], spacing: Constants.headingSpacing)
    let headingLabel = UILabel()
    let subheadingLabel = UILabel()

    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
        mainStack.fillSuperview()
        headingStack.addArrangedSubviews([headingLabel, subheadingLabel])
        setupAccessibility()
    }
    
    public func configure(for model: DSTableBlockItemModel, eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        mainStack.safelyRemoveArrangedSubviews()
        headingLabel.isHidden = model.tableMainHeadingMlc == nil && model.tableSecondaryHeadingMlc == nil
        subheadingLabel.isHidden = model.tableMainHeadingMlc?.description == nil &&
        model.tableSecondaryHeadingMlc?.description == nil

        let heading = model.tableMainHeadingMlc ?? model.tableSecondaryHeadingMlc ?? nil
        let isMain = model.tableMainHeadingMlc != nil
        if heading != nil {
            let font = isMain ? FontBook.smallHeadingFont : FontBook.bigText
            headingLabel.attributedText = heading?.label.attributed(
                font: font,
                lineHeightMultiple: Constants.lineHeightMultiple)
            headingLabel.numberOfLines = 0
            headingLabel.accessibilityLabel = heading?.label

            subheadingLabel.attributedText = heading?.description?.attributed(
                font: FontBook.usualFont,
                color: .black540,
                lineHeightMultiple: Constants.lineHeightMultiple,
                lineBreakMode: .byWordWrapping
            )
            subheadingLabel.numberOfLines = 0
            subheadingLabel.accessibilityLabel = heading?.description

            mainStack.addArrangedSubview(BoxView(subview: headingStack).withConstraints(insets: Constants.stackSubviewInsets))
        }
        if let items = model.items {
            items.forEach { item in
                if let tableItemMlcPrimary = item.tableItemPrimaryMlc {
                    mainStack.addArrangedSubview(primaryTableItem(model: tableItemMlcPrimary))
                }
                if let tableItemMlcHorizontal = item.tableItemHorizontalMlc {
                    mainStack.addArrangedSubview(horizontalTableItem(model: tableItemMlcHorizontal))
                }
                if let tableItemMlcVertical = item.tableItemVerticalMlc {
                    if let images = tableItemMlcVertical.valueImages, images.count > 0 {
                        let photoCollection = HorizontalPhotoCollectionView()
                        photoCollection.configure(title: nil, imageUrls: images, cellSize: .init(width: Constants.photoSize, height: Constants.photoSize))
                        mainStack.addArrangedSubview(photoCollection)
                    } else if let values = tableItemMlcVertical.valueIcons, !values.isEmpty {
                        let view = DSIconValueStackView()
                        view.configure(valueIcons: values)
                        mainStack.addArrangedSubview(BoxView(subview: view).withConstraints(insets: Constants.stackSubviewInsets))
                    } else {
                        mainStack.addArrangedSubview(verticalTableItem(model: tableItemMlcVertical, eventHandler: eventHandler))
                    }
                }
                if let docTableItemHorizontal = item.docTableItemHorizontalMlc {
                    let horizontalView = horizontalTableItem(model: docTableItemHorizontal)
                    horizontalView.subview.setupUI(titleProportion: Constants.titleProportion, numberOfLines: 1)
                    mainStack.addArrangedSubview(horizontalView)
                }
                if let docTableItemHorizontal = item.docTableItemHorizontalLongerMlc {
                    let horizontalView = horizontalTableItem(model: docTableItemHorizontal)
                    horizontalView.subview.setupUI(titleProportion: Constants.titleProportion, numberOfLines: 3)
                    mainStack.addArrangedSubview(horizontalView)
                }
                if let tableItemHorizontalLargeMlc = item.tableItemHorizontalLargeMlc {
                    let horizontalView = horizontalTableItem(model: tableItemHorizontalLargeMlc)
                    horizontalView.subview.setupUI(titleFont: FontBook.bigText, valueFont: FontBook.bigText)
                    mainStack.addArrangedSubview(horizontalView)
                }
                if let emojiPanel = item.smallEmojiPanelMlc {
                    let smallEmojiView = emojiPanelView(model: emojiPanel,
                                                        color: .white)
                    mainStack.addArrangedSubview(smallEmojiView)
                }
                if let btnLinkAtm = item.btnLinkAtm {
                    let smallEmojiView = btnLinkAtmView(model: btnLinkAtm, eventHandler: eventHandler)
                    mainStack.addArrangedSubview(smallEmojiView)
                }
            }
        }
    }
    
    private func emojiPanelView(model: DSSmallEmojiPanelMlcl, color: UIColor) -> UIView {
        let view = SmallButtonPanelMlcView()
        view.configure(for: model, color: color)
        return BoxView(subview: view).withConstraints(insets: Constants.stackSubviewInsets)
    }

    private func btnLinkAtmView(model: DSButtonModel, eventHandler: ((ConstructorItemEvent) -> Void)? = nil) -> UIView {
        let view = DSLinkButton()
        view.setTitle(model.label)
        view.onClick = {
            guard let action = model.action else { return }
            eventHandler?(.action(action))
        }
        return BoxView(subview: view).withConstraints(insets: Constants.stackSubviewInsets)
    }

    private func primaryTableItem(model: DSTableItemPrimaryMlc) -> UIView {
        let primaryTableItem = DSTableItemPrimaryView()
        primaryTableItem.configure(model: model)
        primaryTableItem.setupUI(valueFont: FontBook.mediumHeadingFont)
        return BoxView(subview: primaryTableItem).withConstraints(insets: Constants.stackSubviewInsets)
    }
    
    private func verticalTableItem(model: DSTableItemVerticalMlc, eventHandler: ((ConstructorItemEvent) -> Void)?) -> UIView {
        let verticalTableItem = DSTableItemVerticalView()
        verticalTableItem.configure(model: model, eventHandler: eventHandler)
        return BoxView(subview: verticalTableItem).withConstraints(insets: Constants.stackSubviewInsets)
    }
    
    private func horizontalTableItem(model: DSTableItemHorizontalMlc) -> BoxView<DSTableItemHorizontalView> {
        let horizontalTableItem = DSTableItemHorizontalView()
        horizontalTableItem.configure(item: model, urlOpener: UIComponentsConfiguration.shared.urlOpener)
        return BoxView(subview: horizontalTableItem).withConstraints(insets: Constants.stackSubviewInsets)
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        headingLabel.isAccessibilityElement = true
        headingLabel.accessibilityTraits = .staticText
        
        subheadingLabel.isAccessibilityElement = true
        subheadingLabel.accessibilityTraits = .staticText
    }
}

extension DSTableBlockPlaneOrgView {
    enum Constants {
        static var stackSpacing: CGFloat {
            switch UIScreen.main.bounds.width {
            case 320:
                return 8
            default:
                return 12
            }
        }
        static let stackSubviewInsets: UIEdgeInsets = .init(top: 0, left: 16, bottom: 6, right: 16)
        static let lineHeightMultiple: CGFloat = 1.25
        static let photoSize: CGFloat = 100
        static let titleProportion: CGFloat = 0.4
        static let headingSpacing: CGFloat = 8
        static let lightBlack = UIColor.black.withAlphaComponent(0.4)
    }
}
