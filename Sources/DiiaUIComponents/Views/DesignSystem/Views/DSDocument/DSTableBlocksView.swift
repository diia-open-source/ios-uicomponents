
import UIKit

public class DSTableBlocksView: BaseCodeView {
    
    private let tableBlocks = UIStackView.create(.vertical, views: [], spacing: Constants.stackSpacing)
    
    public override func setupSubviews() {
        addSubview(tableBlocks)
        tableBlocks.fillSuperview(padding: Constants.blockPadding)
    }
    
    public func configure(model: [DSTableBlockItemModel], eventHandler: ((ConstructorItemEvent) -> Void)? = nil) {
        model.forEach({ item in
            let block = DSTableBlockOrgView()
            block.configure(for: item, eventHandler: eventHandler)
            tableBlocks.addArrangedSubview(block)
        })
    }
}

extension DSTableBlocksView {
    enum Constants {
        static let stackSpacing: CGFloat = 16
        static let blockPadding = UIEdgeInsets.init(top: 0, left: 24, bottom: 0, right: 24)
    }
}
