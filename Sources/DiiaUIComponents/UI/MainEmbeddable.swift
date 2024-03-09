import UIKit

public protocol MainEmbeddable: UIViewController {
    func onSameSelected()
    func processAction(action: String)
}
