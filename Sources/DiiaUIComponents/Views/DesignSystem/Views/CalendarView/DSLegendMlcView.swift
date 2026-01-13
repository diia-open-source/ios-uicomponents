
import UIKit

/// design_system_code: legendGroupMlc
public final class DSLegendMlcView: BaseCodeView {
    private let legendLabel = UILabel().withParameters(
        font: FontBook.usualFont,
        textAlignment: .center,
        lineBreakMode: .byTruncatingTail)
    private let legendMark = UIView().withSize(Constants.iconSize)

    override public func setupSubviews() {
        legendMark.backgroundColor = .black
        legendMark.layer.cornerRadius = Constants.iconSize.width/2
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(legendMark)
        container.addSubview(legendLabel)
        
        legendMark.anchor(leading: container.leadingAnchor)
        legendLabel.anchor(top: container.topAnchor,
                           leading: legendMark.trailingAnchor,
                           bottom: container.bottomAnchor,
                           trailing: container.trailingAnchor,
                           padding: Constants.labelPadding)
        
        legendLabel.centerYAnchor.constraint(equalTo: legendMark.centerYAnchor).isActive = true
        addSubview(container)
        container.anchor(top: topAnchor, bottom: bottomAnchor)
        container.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    public func configure(with viewModel: DSTitleMlcViewModel) {
        accessibilityIdentifier = viewModel.componentId
        viewModel.label.observe(observer: self) { [weak self] title in
            self?.legendLabel.text = title
        }
    }
}

private extension DSLegendMlcView {
    enum Constants {
        static let labelPadding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        static let iconSize = CGSize(width: 8, height: 8)
    }
}
