
import UIKit
import DiiaCommonTypes

public final class DSTextMlcViewModel {
    public let componentId: String
    public let text: Observable<String>
    
    public init(componentId: String, text: String) {
        self.componentId = componentId
        self.text = .init(value: text)
    }
}

/// design_system_code: subTitleCentralizedMlc
public final class DSSubTitleCentralizedMlcView: BaseCodeView {
    private let titleLabel = UILabel().withParameters(font: FontBook.bigText, textAlignment: .center, lineBreakMode: .byTruncatingTail)

    override public func setupSubviews() {
        addSubview(titleLabel)
        titleLabel.fillSuperview()
    }

    public func configure(with viewModel: DSTextMlcViewModel) {
        accessibilityIdentifier = viewModel.componentId
        viewModel.text.observe(observer: self) { [weak self] text in
            self?.titleLabel.text = text
        }
    }
}
