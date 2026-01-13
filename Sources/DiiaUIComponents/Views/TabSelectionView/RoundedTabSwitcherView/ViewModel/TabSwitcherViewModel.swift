
import UIKit

public final class TabSwitcherModel {
    public let id: String
    public let title: String
    public var isSelected: Bool
    
    public init(id: String = UUID().uuidString, title: String, isSelected: Bool = false) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
}

open class TabSwitcherViewModel {
    public var items: [TabSwitcherModel]
    public var action: ((Int) -> Void)?

    public init(items: [TabSwitcherModel] = []) {
        self.items = items
    }

    open func itemAt(index: Int) -> TabSwitcherModel? {
        guard items.indices.contains(index) else { return nil }
        return items[index]
    }

    open func itemSelected(index: Int) {
        guard items.indices.contains(index) else { return }
        // Deselect all items before selecting a specific item
        items.forEach { $0.isSelected = false }

        items[index].isSelected.toggle()
        action?(index)
    }
}
