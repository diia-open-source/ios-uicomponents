
import UIKit

public final class DSTitleMlcViewModel {
    public let componentId: String
    public let label: Observable<String>
    
    init(componentId: String, label: String) {
        self.componentId = componentId
        self.label = .init(value: label)
    }
}

/// design_system_code: subTitleCentralizedMlc
public final class DSSubTitleCentralizedMlcView: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText, textAlignment: .center, lineBreakMode: .byTruncatingTail)

    override public func setupSubviews() {
        addSubview(titleLabel)
        titleLabel.fillSuperview()
    }

    public func configure(with viewModel: DSTitleMlcViewModel) {
        accessibilityIdentifier = viewModel.componentId
        viewModel.label.observe(observer: self) { [weak self] title in
            self?.titleLabel.text = title
        }
    }
}
