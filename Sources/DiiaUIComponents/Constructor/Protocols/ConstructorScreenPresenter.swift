
import Foundation
import DiiaMVPModule

public protocol ConstructorScreenPresenter: BasePresenter {
    func openContextMenu()
    func handleEvent(event: ConstructorItemEvent)
    func screenCode() -> String
    func resourceId() -> String?
    func onViewAppear()
    func onViewDidAppear()
    func canNavigateBack() -> Bool
}

public extension ConstructorScreenPresenter {
    func openContextMenu() { }
    func screenCode() -> String { return .empty }
    func resourceId() -> String? { return nil }
    func onViewAppear() { }
    func onViewDidAppear() { }
    func canNavigateBack() -> Bool { return true }
}
