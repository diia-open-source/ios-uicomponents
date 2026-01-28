
import Foundation
import UIKit

public final class DSExpireLabel: BaseCodeView {
    public struct Configuration {
        public init(font: UIFont? = nil, textAlpha: CGFloat? = nil, timerLabelWidth: CGFloat? = nil) {
            self.font = font ?? FontBook.statusFont
            self.textAlpha = textAlpha ?? DSExpireLabel.Constants.alphaColor
            self.timerLabelWidth = timerLabelWidth ?? DSExpireLabel.Constants.timerWidth
        }
        
        public let font: UIFont
        public let textAlpha: CGFloat
        public let timerLabelWidth: CGFloat
    }

    private let firstLabel = UILabel()
    private let timerLabel = UILabel()
    private let lastLabel = UILabel()
    private let stack = UIStackView.create(.horizontal, alignment: .leading)

    private let configuration: Configuration

    // MARK: - Init
    public init(configuration: Configuration? = nil) {
        self.configuration = configuration ?? .default
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    public override func setupSubviews() {
        super.setupSubviews()
        
        firstLabel.textAlignment = .left
        timerLabel.textAlignment = .center
        lastLabel.textAlignment = .right
        
        let labelArray = [firstLabel, timerLabel, lastLabel]
        labelArray.forEach({
            $0.font = configuration.font
            $0.textColor = UIColor.black.withAlphaComponent(configuration.textAlpha)
        })
        stack.addArrangedSubviews(labelArray)
        
        timerLabel.anchor(size: .init(width: configuration.timerLabelWidth,
                                      height: .zero))
        
        addSubview(stack)
        
        stack.anchor(top: topAnchor,
                     leading: leadingAnchor,
                     bottom: bottomAnchor,
                     trailing: trailingAnchor,
                     size: .init(width: .zero,
                                 height: Constants.timerHeight))
        
        setupAccessibility()
    }
    
    public func configure(for model: DSExpireLabelBox) {
        firstLabel.text = model.expireLabelFirst
        lastLabel.text = model.expireLabelLast
        
        accessibilityLabel = model.expireLabelFirst
    }
    
    public func updateTimer(with text: String) {
        timerLabel.text = text
        
        accessibilityValue = text + (lastLabel.text ?? "")
    }
    
    // MARK: - Private
    private func setupAccessibility() {
        isAccessibilityElement = true
        accessibilityTraits = [.staticText, .updatesFrequently]
    }
}

private extension DSExpireLabel {
    enum Constants {
        static let timerWidth: CGFloat = 32
        static let timerHeight: CGFloat = 16
        static let alphaColor: CGFloat = 0.5
    }
}

public extension DSExpireLabel.Configuration {
    static let `default` = DSExpireLabel.Configuration()
}
