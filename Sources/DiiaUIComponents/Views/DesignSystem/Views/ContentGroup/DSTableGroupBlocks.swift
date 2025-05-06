
import UIKit
import DiiaCommonTypes

public struct DSTableGroupBlocksModel: Codable {
    public let tableBlockMlcl: DSTableItemsBlockModel
    
    public init(tableBlockMlcl: DSTableItemsBlockModel) {
        self.tableBlockMlcl = tableBlockMlcl
    }
}

public struct DSTableItemsBlockModel: Codable {
    public let tableHeadingMain: DSTableHeadingMainModel?
    public let items: [DSTableItemModel]
    
    public init(tableHeadingMain: DSTableHeadingMainModel?, items: [DSTableItemModel]) {
        self.tableHeadingMain = tableHeadingMain
        self.items = items
    }
}

public struct DSTableHeadingMainModel: Codable {
    public let label: String
    
    public init(label: String) {
        self.label = label
    }
}

public struct DSTableItemModel: Codable {
    public let tableItemMlcPrimary: LabelValueModel?
    public let tableItemMlcHorizontal: LabelValueModel?
    public let tableItemMlcVertical: LabelValueModel?
    
    public init(tableItemMlcPrimary: LabelValueModel?, tableItemMlcHorizontal: LabelValueModel?, tableItemMlcVertical: LabelValueModel?) {
        self.tableItemMlcPrimary = tableItemMlcPrimary
        self.tableItemMlcHorizontal = tableItemMlcHorizontal
        self.tableItemMlcVertical = tableItemMlcVertical
    }
}

public class DSTableGroupBlocks: BaseCodeView {
    private let groupBlocksStack = UIStackView.create(views: [], spacing: Constants.stackSpacing)
    
    override public func setupSubviews() {
        super.setupSubviews()
        backgroundColor = .clear
        groupBlocksStack.backgroundColor = .clear
        addSubview(groupBlocksStack)
        groupBlocksStack.fillSuperview()
    }
    
    public func configure(blocks: [DSTableBlockItemModel], eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        groupBlocksStack.safelyRemoveArrangedSubviews()
        blocks.forEach { block in
            let tableItemBlock = DSTableBlockOrgView()
            tableItemBlock.configure(for: block, eventHandler: eventHandler)
            groupBlocksStack.addArrangedSubview(tableItemBlock)
        }
    }
}

extension DSTableGroupBlocks {
    private enum Constants {
        static let stackSpacing: CGFloat = 16
    }
}
