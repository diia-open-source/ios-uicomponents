
import Foundation
import UIKit

public final class DSChipTimeViewModel: NSObject {
    
    let chipMlc: DSChipTimeMlc
    @objc dynamic var isSelected: Bool = false
    var onChange: ((Bool) -> Void)?
    
    init(chipMlc: DSChipTimeMlc) {
        self.chipMlc = chipMlc
    }
}

final public class DSChipTimeMlcView: BaseCodeView {
    
    private let timeLabel = UILabel()
    
    public var viewModel: DSChipTimeViewModel?
    
    private var observations: [NSKeyValueObservation] = []
    
    override public func setupSubviews() {
        addSubview(timeLabel)
        
        timeLabel.font = FontBook.usualFont
        timeLabel.textAlignment = .center
        timeLabel.textColor = .black
        
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        
        timeLabel.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: Constants.padding)
        
        heightAnchor.constraint(equalToConstant: Constants.viewHeight).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    public func configure(for viewModel: DSChipTimeViewModel) {
        self.viewModel = viewModel
        accessibilityIdentifier = viewModel.chipMlc.componentId
        timeLabel.text = viewModel.chipMlc.label
        
        observations = [
            viewModel.observe(\.isSelected, onChange: { [weak self] selected in
                self?.backgroundColor = selected ? .black : .white
                self?.timeLabel.textColor = selected ? .white : .black
            })
        ]
    }
    
    @objc private func onTap() {
        guard let viewModel = viewModel else { return }
        viewModel.isSelected = true
        viewModel.onChange?(viewModel.isSelected)
    }
}

extension DSChipTimeMlcView {
    enum Constants {
        static let viewHeight: CGFloat = 40
        static let cornerRadius: CGFloat = 20
        static let padding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
}
