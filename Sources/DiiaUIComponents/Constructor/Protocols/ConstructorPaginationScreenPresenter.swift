
import Foundation
import DiiaMVPModule

public protocol ConstructorPaginationScreenPresenter: BasePresenter {
    func openContextMenu()
    func handleEvent(event: ConstructorItemEvent)
    func didScrollToEnd()
    func screenCode() -> String
    func resourceId() -> String?
    func onViewAppear()
}

public extension ConstructorPaginationScreenPresenter {
    func screenCode() -> String { return .empty }
    func resourceId() -> String? { return nil }
    func onViewAppear() { }
}
