
import UIKit

final class UITapGestureRecognizerHelper: UITapGestureRecognizer {
    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(handleTap))
    }

    @objc private func handleTap() {
        action()
    }
}
