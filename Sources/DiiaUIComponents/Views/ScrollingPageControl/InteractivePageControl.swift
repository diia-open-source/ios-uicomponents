
import UIKit

final class InteractivePageControl: UIPageControl {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        backgroundColor = .black.withAlphaComponent(0.1)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        backgroundColor = .clear
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        backgroundColor = .clear
    }
}
