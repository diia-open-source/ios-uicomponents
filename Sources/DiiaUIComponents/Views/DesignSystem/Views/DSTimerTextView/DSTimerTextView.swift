
import UIKit

/// design_system_code: timerMlc
public class DSTimerTextView: BaseCodeView {
    // MARK: - Subviews
    private let expireLabel = DSExpireLabel()
    private let linkButton = DSLinkButton()
    
    // MARK: - Properties
    private var viewModel: DSTimerTextViewModel?
    
    // MARK: - Init
    public override func setupSubviews() {
        initialSetup()
    }
    
    private func initialSetup() {
        linkButton.isHidden = true
        linkButton.contentEdgeInsets = Constants.buttonEdgeInsets

        let subviews = [expireLabel, linkButton]
        addSubviews(subviews)
        subviews.forEach {
            $0.anchor(
                leading: leadingAnchor,
                bottom: bottomAnchor,
                padding: Constants.defaultPaddings)
            let topConstraint = $0.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Constants.topInset)
            topConstraint.priority = .defaultLow
            topConstraint.isActive = true
            $0.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24).isActive = true
        }
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSTimerTextViewModel) {
        expireLabel.isHidden = viewModel.expireLabel == nil
        if let expireLabelModel = viewModel.expireLabel {
            expireLabel.configure(for: expireLabelModel)
            viewModel.setupTimer(for: expireLabelModel.timer)
            
            addObservers(for: viewModel)
        }
        
        linkButton.setTitle(viewModel.buttonLink.label)
        linkButton.onClick = viewModel.onClick
        
        self.viewModel = viewModel
    }
    
    // MARK: - Private Methods
    private func addObservers(for viewModel: DSTimerTextViewModel) {
        self.viewModel?.timerText.removeObserver(observer: self)
        viewModel.timerText.observe(observer: self) { [weak self] timerText in
            guard let self = self, let timerText = timerText else { return }
            self.expireLabel.updateTimer(with: timerText)
        }
        self.viewModel?.isExpired.removeObserver(observer: self)
        viewModel.isExpired.observe(observer: self) { [weak self] isExpired in
            guard let self = self else { return }
            self.expireLabel.isHidden = isExpired
            self.linkButton.isHidden = !isExpired
        }
    }
}

// MARK: - Constants
extension DSTimerTextView {
    private enum Constants {
        static let topInset: CGFloat = 24
        static let defaultPaddings = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        static let buttonEdgeInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
    }
}
