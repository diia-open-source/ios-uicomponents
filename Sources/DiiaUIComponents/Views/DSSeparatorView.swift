
import UIKit

public final class DSSeparatorView: BaseCodeView {

    public override func setupSubviews() {
        self.withHeight(Constants.height)
        self.backgroundColor = Constants.color
    }
}

private extension DSSeparatorView {
    enum Constants {
        static let height: CGFloat = 2
        static let color = UIColor("#E2ECF4")
    }
}
