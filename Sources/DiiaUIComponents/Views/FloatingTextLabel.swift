
import UIKit

/// design_system_code: tickerAtm
public class FloatingTextLabel: BaseCodeView {

    public var labelText: String? {
        didSet {
            setupLabel()
        }
    }
    public var backgroundImage: UIImage = UIImage.from(color: UIColor(AppConstants.Colors.yellowErrorColor)) {
        didSet {
            backgroundView.image = backgroundImage
        }
    }
    public var textColor: UIColor = .black
    
    private let backgroundView = UIImageView()
    private var rect0: CGRect!
    private var rect1: CGRect!
    private var labels = [UILabel]()
    private var timeInterval: TimeInterval!
    private var isStopped: Bool = true
    private var font: UIFont = FontBook.usualFont
    private var leadingBuffer: CGFloat = 16.0
    private var loopStartDelay: TimeInterval = 0.0
    
    public override func setupSubviews() {
        addSubview(backgroundView)
        backgroundView.fillSuperview()
        backgroundView.image = backgroundImage
        clipsToBounds = true
    }
    
    public func stopAnimation() {
        isStopped = true
        reset()
    }
    
    public func animate() {
        if !isStopped {
            layer.removeAllAnimations()
            setupLabel()
        }
        isStopped = false
        setupSecondLabelIfNeeded()
        animateIfNeeded()
    }

    public func reset() {
        self.layer.removeAllAnimations()
        setupLabel()
        if !isStopped {
            animate()
        }
    }
    
    public func configure(model: DSTickerAtom, leadingBuffer: CGFloat = 16) {
        self.leadingBuffer = leadingBuffer
        withHeight(model.usage.height)
        layoutIfNeeded()
        labelText = model.value
        configureUI(backgroundImage: model.type.backgroundImage)
        animate()
        accessibilityIdentifier = model.componentId
    }

    deinit {
        stopAnimation()
    }

    public func configureUI(font: UIFont = FontBook.usualFont,
                            backgroundImage: UIImage = UIImage.from(color: UIColor(AppConstants.Colors.yellowErrorColor)),
                            leadingBuffer: CGFloat = 16,
                            loopStartDelay: TimeInterval = 0.0) {
        self.font = font
        self.backgroundImage = backgroundImage
        self.leadingBuffer = leadingBuffer
        self.loopStartDelay = loopStartDelay
    }
    
    // MARK: Private
    private func setupLabel() {
        labels.forEach {
            $0.layer.removeAllAnimations()
            $0.removeFromSuperview()
        }
        labels = []
        guard let labelText = labelText else { return }
        
        let label = UILabel()
        label.text = labelText
        label.textColor = textColor
        label.frame = CGRect.zero
        label.font = font
        
        let textWidth = labelText.width(withConstrainedHeight: .zero, font: label.font)
        
        rect0 = CGRect(x: leadingBuffer, y: 0, width: textWidth, height: self.bounds.size.height)
        rect1 = CGRect(x: rect0.origin.x + rect0.size.width + leadingBuffer, y: 0, width: textWidth, height: self.bounds.size.height)
        label.frame = rect0
        
        labels = [label]
        self.addSubview(label)
    }
    
    private func setupSecondLabelIfNeeded() {
        guard labels.count == 1 else { return }
        let label = labels[0]
        
        let textWidth = (labelText ?? "").width(withConstrainedHeight: .zero, font: label.font)
        let isTextTooLong = textWidth > (frame.size.width - (2 * leadingBuffer)) ? true : false
        
        if isTextTooLong {
            let additionalLabel = UILabel(frame: rect1)
            additionalLabel.font = FontBook.usualFont
            additionalLabel.text = labelText
            additionalLabel.textColor = textColor
            self.addSubview(additionalLabel)
            labels.append(additionalLabel)
        }
    }
    
    private func animateIfNeeded() {
        if(!isStopped && labels.count > 1), let labelText = labelText, window != nil {
            let labelAtIndex0 = labels[0]
            let labelAtIndex1 = labels[1]

            timeInterval = TimeInterval(labelText.count / 5)
            
            UIView.animate(withDuration: timeInterval,
                           delay: loopStartDelay,
                           options: [.curveLinear],
                           animations: {
                labelAtIndex0.frame = CGRect(
                    x: labelAtIndex0.frame.origin.x-labelAtIndex0.frame.size.width-self.leadingBuffer,
                    y: 0,
                    width: labelAtIndex0.frame.size.width,
                    height: labelAtIndex0.frame.size.height)
                labelAtIndex1.frame = self.rect0
            }, completion: { [weak self] _ in
                if self?.isStopped == true || labelAtIndex0 != self?.labels[0] { return }
                labelAtIndex0.frame = self?.rect1 ?? .zero
                labelAtIndex1.frame = self?.rect0 ?? .zero
                
                self?.labels[0] = labelAtIndex1
                self?.labels[1] = labelAtIndex0
                self?.animateIfNeeded()
            })
        } else {
            isStopped = true
            self.layer.removeAllAnimations()
        }
    }
}
