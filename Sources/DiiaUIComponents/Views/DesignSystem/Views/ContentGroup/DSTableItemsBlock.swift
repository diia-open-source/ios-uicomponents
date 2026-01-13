
import UIKit

// TODO: Do we need this? Is this same as DSTableBlocksView?
public final class DSTableItemsBlock: BaseCodeView {
    
    private let tableHeadingLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    private let blockStack = UIStackView.create(spacing: Constants.stackSpacing)
    private let whiteView = UIView()
    
    // MARK: Life cycle
    override public func setupSubviews() {
        super.setupSubviews()
        whiteView.backgroundColor = .white
        blockStack.backgroundColor = .clear
        whiteView.layer.cornerRadius = Constants.cornerRadius
        addSubview(whiteView)
        whiteView.addSubview(blockStack)
        whiteView.fillSuperview()
        blockStack.fillSuperview(padding: Constants.padding)
        layoutIfNeeded()
    }
    
    // MARK: Setup
    public func configure(headingTitle: String?, items: [DSTableItemModel]) {
        blockStack.isHidden = items.isEmpty
        blockStack.safelyRemoveArrangedSubviews()
        
        tableHeadingLabel.isHidden = headingTitle == nil
        if let headingTitle = headingTitle {
            tableHeadingLabel.text = headingTitle
            blockStack.addArrangedSubview(tableHeadingLabel)
        }
        
        items.forEach { item in
            if let tableItemMlcPrimary = item.tableItemMlcPrimary {
                blockStack.addArrangedSubview(primaryTableItem(title: tableItemMlcPrimary.label, value: tableItemMlcPrimary.value))
            }
            if let tableItemMlcHorizontal = item.tableItemMlcHorizontal {
                blockStack.addArrangedSubview(horizontalLabelValueView(title: tableItemMlcHorizontal.label, value: tableItemMlcHorizontal.value))
            }
            if let tableItemMlcVertical = item.tableItemMlcVertical {
                blockStack.addArrangedSubview(verticalLabelValueView(title: tableItemMlcVertical.label, value: tableItemMlcVertical.value))
            }
        }
    }
    
    // MARK: - Private methods
    
    private func primaryTableItem(title: String, value: String) -> UIView {
        let primaryView = DSTableItemPrimaryView()
        primaryView.setupUI(valueFont: FontBook.mediumHeadingFont)
        primaryView.configure(for: title, value: value, withIcon: true)
        return primaryView
    }
    
    private func horizontalLabelValueView(title: String, value: String) -> UIView {
        let pairView = PairView()
        pairView.setupUI(titleProportion: Constants.titleProportion)
        pairView.configure(title: title, details: value)
        return pairView
    }
    
    private func verticalLabelValueView(title: String, value: String) -> UIView {
        let pairVerticalView = PairVerticalView()
        pairVerticalView.setupUI(titleColor: .black)
        pairVerticalView.configure(with: title, value: value)
        
       return pairVerticalView
    }
}

extension DSTableItemsBlock {
    private enum Constants {
        static let padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let stackSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let titleProportion: CGFloat = 0.6
    }
}
