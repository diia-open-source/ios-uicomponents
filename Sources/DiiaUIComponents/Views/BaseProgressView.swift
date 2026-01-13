
import UIKit

public final class BaseProgressView: UIProgressView {
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // MARK: - Private methods
    private func setupView() {
        isHidden = true
        layer.backgroundColor = UIColor.clear.cgColor
        trackTintColor = .clear
        progressImage = R.image.loadingBar.image
    }
    
    // MARK: - Public methods
    public func setLoading(isActive: Bool) {
        layer.sublayers?.forEach { $0.removeAllAnimations() }
        setProgress(0.0, animated: false)
        isHidden = !isActive
        
        if !isActive { return }
        layoutIfNeeded()
        setProgress(1.0, animated: false)
        UIView.animate(
            withDuration: Constants.progressAnimationDuration,
            delay: 0,
            options: [.repeat],
            animations: { [unowned self] in self.layoutIfNeeded() }
        )
    }
}

// MARK: - Constants
extension BaseProgressView {
    private enum Constants {
        static let progressAnimationDuration: TimeInterval = 1.5
    }
}
