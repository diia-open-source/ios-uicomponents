import Foundation
import UIKit
import DiiaMVPModule

public class DSTableBlockPlaneOrgView: BaseCodeView {
    
    private let mainStack = UIStackView.create(.vertical, views: [], spacing: Constants.stackSpacing)
    private let headingLabel = UILabel()
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
        mainStack.fillSuperview()
    }
    
    public func configure(for model: DSTableBlockItemModel) {
        mainStack.safelyRemoveArrangedSubviews()
        headingLabel.isHidden = model.tableMainHeadingMlc == nil && model.tableSecondaryHeadingMlc == nil
        let heading = model.tableMainHeadingMlc ?? model.tableSecondaryHeadingMlc ?? nil
        let isMain = model.tableMainHeadingMlc != nil
        if heading != nil {
            let font = isMain ? FontBook.smallHeadingFont : FontBook.bigText
            headingLabel.attributedText = heading?.label.attributed(
                font: font,
                lineHeightMultiple: Constants.lineHeightMultiple)
            headingLabel.numberOfLines = 0
            mainStack.addArrangedSubview(BoxView(subview: headingLabel).withConstraints(insets: Constants.stackSubviewInsets))
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
                        mainStack.addArrangedSubview(verticalTableItem(model: tableItemMlcVertical))
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
                if let emojiPanel = item.smallEmojiPanelMlc {
                    let smallEmojiView = emojiPanelView(model: emojiPanel,
                                                        color: .white)
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

    private func primaryTableItem(model: DSTableItemPrimaryMlc) -> UIView {
        let primaryTableItem = DSTablePrimaryItemView()
        primaryTableItem.configure(for: model)
        return BoxView(subview: primaryTableItem).withConstraints(insets: Constants.stackSubviewInsets)
    }
    
    private func verticalTableItem(model: DSTableItemVerticalMlc) -> UIView {
        let verticalTableItem = DSTableItemVerticalView()
        verticalTableItem.configure(model: model)
        return BoxView(subview: verticalTableItem).withConstraints(insets: Constants.stackSubviewInsets)
    }
    
    private func horizontalTableItem(model: DSTableItemHorizontalMlc) -> BoxView<DSTableItemHorizontalView> {
        let horizontalTableItem = DSTableItemHorizontalView()
        horizontalTableItem.configure(item: model)
        return BoxView(subview: horizontalTableItem).withConstraints(insets: Constants.stackSubviewInsets)
    }
}

extension DSTableBlockPlaneOrgView {
    enum Constants {
        static var stackSpacing: CGFloat {
            switch UIScreen.main.bounds.width {
            case 320:
                return 8
            default:
                return 16
            }
        }
        static let stackSubviewInsets: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        static let lineHeightMultiple: CGFloat = 1.25
        static let photoSize: CGFloat = 100
        static let titleProportion: CGFloat = 0.4
    }
}
