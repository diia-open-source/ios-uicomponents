
import UIKit

/// design_system_code: progressBarAtm

public final class ProgressBarView: BaseCodeView {
    
    private let progressView = UIProgressView(progressViewStyle: .bar)
    private let percentLabel = UILabel().withParameters(font: FontBook.usualFont)
    
    public override func setupSubviews() {
        progressView.layer.cornerRadius = Constants.cornerRadius
        progressView.trackTintColor = Constants.trackColor
        progressView.clipsToBounds = true
        
        let boxProgress = BoxView(subview: progressView)
            .withConstraints(insets: Constants.insets)
        let progressStack = UIStackView.create(
            .horizontal,
            views: [boxProgress, percentLabel],
            spacing: Constants.spacing)
        progressStack.withHeight(Constants.progressHeight)
        
        addSubview(progressStack)
        progressStack.fillSuperview()
        
        setupAccessibility()
    }
    
    public func configure(for object: ProgressBarAtm) {
        percentLabel.text = object.percentText
        progressView.progress = object.percent
        
        percentLabel.accessibilityLabel = object.percentText
    }
    
    private func setupAccessibility() {
        progressView.isAccessibilityElement = false
        
        percentLabel.isAccessibilityElement = true
        percentLabel.accessibilityTraits = .staticText
    }
}

private extension ProgressBarView {
    enum Constants {
        static let cornerRadius: CGFloat = 3
        static let progressHeight: CGFloat = 18
        static let spacing: CGFloat = 16
        static let insets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        static let trackColor = UIColor("#E2ECF4")
    }
}
