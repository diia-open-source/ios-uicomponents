import UIKit
import DiiaCommonTypes

/// design_system_code: navigationPanelMlc
public class TopNavigationView: UIView {

    // MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!

    @IBOutlet weak private var backButton: UIButton!
    @IBOutlet weak private var loadingContainer: UIView!
    @IBOutlet weak private var loadingIndicator: UIProgressView!
    @IBOutlet weak private var loadingLabel: UILabel!
    
    @IBOutlet weak private var stepContainer: UIView!
    @IBOutlet weak private var stepView: PublicServiceStepView!
    
    @IBOutlet weak private var contextButton: UIButton!

    // MARK: - Properties
    private var onCloseClick: Callback?
    private var onContextClick: Callback?

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        fromNib(bundle: Bundle.module)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fromNib(bundle: Bundle.module)
    }
    
    // MARK: - Life Cycle
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    // MARK: - Setup
    private func setup() {
        setupUI()
        backButton.accessibilityLabel = R.Strings.general_back.localized()
        contextButton.accessibilityLabel = R.Strings.general_context_menu_open.localized()
        loadingContainer.isHidden = true
        stepContainer.isHidden = true
        loadingLabel.text = R.Strings.general_loading.localized()
    }
    
    // MARK: - Public Methods
    public func setupUI(titleFont: UIFont = FontBook.smallHeadingFont, titleColor: UIColor = .black, backgroundColor: UIColor = .clear, buttonTintColor: UIColor = .black) {
        backButton.tintColor = buttonTintColor
        titleLabel?.font = titleFont
        titleLabel?.textColor = titleColor
        self.backgroundColor = backgroundColor
        loadingLabel.font = FontBook.usualFont
    }
    
    public func setupTitle(title: String?) {
        titleLabel.text = title
    }
    
    public func setupOnClose(callback: Callback?) {
        self.onCloseClick = callback
    }
    
    public func setupOnContext(callback: Callback?) {
        self.contextButton.isHidden = callback == nil
        self.onContextClick = callback
    }
    
    public func setupLoading(isActive: Bool) {
        loadingIndicator.layer.sublayers?.forEach { $0.removeAllAnimations() }
        loadingIndicator.setProgress(0.0, animated: false)
        loadingContainer.isHidden = !isActive
        
        if !isActive { return }
        self.loadingIndicator.layoutIfNeeded()
        self.loadingIndicator.setProgress(1.0, animated: false)
        UIView.animate(
            withDuration: Constants.progressAnimationDuration,
            delay: 0,
            options: [.repeat],
            animations: { [unowned self] in self.loadingIndicator.layoutIfNeeded() }
        )
    }
    
    public func setStepCounter(_ stepCounter: StepCounter?) {
        stepContainer.isHidden = stepCounter == nil
        stepView.setStep(stepCounter?.currentStep ?? 1, from: stepCounter?.numberOfSteps ?? 1)
    }
    
    // MARK: - Actions
    @IBAction private func contextMenuClicked() {
        onContextClick?()
    }
    
    @IBAction private func close() {
        onCloseClick?()
    }
}

// MARK: - Constants
extension TopNavigationView {
    private enum Constants {
        static let progressAnimationDuration: TimeInterval = 1.5
    }
}
