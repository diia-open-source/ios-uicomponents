
import Foundation
import UIKit

public final class DSExpireLabel: BaseCodeView {
    
    private let firstLabel = UILabel()
    private let timerLabel = UILabel()
    private let lastLabel = UILabel()
    private let stack = UIStackView.create(.horizontal, alignment: .leading)
    
    public override func setupSubviews() {
        super.setupSubviews()
        
        firstLabel.textAlignment = .left
        timerLabel.textAlignment = .center
        lastLabel.textAlignment = .right
        
        let labelArray = [firstLabel, timerLabel, lastLabel]
        labelArray.forEach({
            $0.font = FontBook.statusFont
            $0.textColor = UIColor.black.withAlphaComponent(Constants.alphaColor)
        })
        stack.addArrangedSubviews(labelArray)
        
        timerLabel.anchor(size: .init(width: Constants.timerWidth,
                                      height: .zero))
        
        addSubview(stack)
        
        stack.anchor(top: topAnchor,
                     leading: leadingAnchor,
                     bottom: bottomAnchor,
                     trailing: trailingAnchor,
                     size: .init(width: .zero,
                                 height: Constants.timerHeight))
    }
    
    public func configure(for model: DSExpireLabelBox) {
        firstLabel.text = model.expireLabelFirst
        lastLabel.text = model.expireLabelLast
    }
    
    public func updateTimer(with text: String) {
        timerLabel.text = text
    }
}

extension DSExpireLabel {
    enum Constants {
        static let timerWidth: CGFloat = 32
        static let timerHeight: CGFloat = 16
        static let alphaColor: CGFloat = 0.5
    }
}
