
import UIKit

public class PublicServiceStepView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak private var progressView: UIProgressView!
    @IBOutlet weak private var stepLabel: UILabel!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fromNib(bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fromNib(bundle: Bundle.module)
    }
    
    // MARK: - LifeCycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        stepLabel.font = FontBook.usualFont
        stepLabel.textColor = .black
        stepLabel.alpha = Constants.textAlpha
        progressView.trackTintColor = Constants.progressBackgroundColor
    }
    
    // MARK: - Public Methods
    public func setStep(_ step: Int, from steps: Int, animated: Bool = false) {
        let progress = Float(step) / Float(steps)
        progressView.setProgress(progress, animated: animated)
        stepLabel.text = R.Strings.general_step.formattedLocalized(arguments: String(step), String(steps))
    }
}

// MARK: - Constants
extension PublicServiceStepView {
    private enum Constants {
        static let textAlpha: CGFloat = 0.5
        static let progressBackgroundColor = UIColor("#C5D9E9")
    }
}
