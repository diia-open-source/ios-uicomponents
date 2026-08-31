
import UIKit

public final class DSRowItemsWrapView: BaseCodeView {
    private let rowsStack = UIStackView.create(.vertical, spacing: Constants.lineSpacing)
    private var items: [(view: UIView, width: CGFloat)] = []
    private var lastLayoutWidth: CGFloat = 0
    
    private var lineSpacing: CGFloat = Constants.lineSpacing
    private var interitemSpacing: CGFloat = Constants.interitemSpacing
    
    public override func setupSubviews() {
        addSubview(rowsStack)
        rowsStack.fillSuperview()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width > 0, bounds.width != lastLayoutWidth else { return }
        lastLayoutWidth = bounds.width
        layoutItems(maxWidth: bounds.width)
    }
    
    public func configure(items: [(view: UIView, width: CGFloat)],
                          lineSpacing: CGFloat = Constants.lineSpacing,
                          interitemSpacing: CGFloat = Constants.interitemSpacing) {
        self.items = items
        self.lineSpacing = lineSpacing
        self.interitemSpacing = interitemSpacing
        rowsStack.spacing = lineSpacing
        isHidden = items.isEmpty
        lastLayoutWidth = 0
        if bounds.width > 0 {
            layoutItems(maxWidth: bounds.width)
        }
    }
    private func layoutItems(maxWidth: CGFloat) {
        rowsStack.safelyRemoveArrangedSubviews()
        
        guard !items.isEmpty, maxWidth > 0 else { return }
        
        var currentRow = makeRow()
        var currentRowWidth: CGFloat = 0
        rowsStack.addArrangedSubview(currentRow)
        
        for (index, item) in items.enumerated() {
            if currentRowWidth > 0, currentRowWidth + interitemSpacing + item.width > maxWidth {
                addSpacer(to: currentRow)
                currentRow = makeRow()
                rowsStack.addArrangedSubview(currentRow)
                currentRowWidth = 0
            }
            
            item.view.widthAnchor.constraint(equalToConstant: item.width).isActive = true
            item.view.setContentHuggingPriority(.required, for: .horizontal)
            item.view.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            currentRow.addArrangedSubview(item.view)
            currentRowWidth += (currentRowWidth > 0 ? interitemSpacing : 0) + item.width
            
            if index == items.count - 1 {
                addSpacer(to: currentRow)
            }
        }
    }
    
    private func addSpacer(to row: UIStackView) {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        row.addArrangedSubview(spacer)
    }
    
    private func makeRow() -> UIStackView {
        UIStackView.create(.horizontal, spacing: interitemSpacing, alignment: .center)
    }
}

public extension DSRowItemsWrapView {
    enum Constants {
        public static let lineSpacing: CGFloat = 8
        public static let interitemSpacing: CGFloat = 8
    }
}
