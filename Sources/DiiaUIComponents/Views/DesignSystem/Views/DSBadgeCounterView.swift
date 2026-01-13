
import UIKit

/// design_system_code: badgeCounterAtm
public final class DSBadgeCounterView: BaseCodeView {
    private let counterLabel = UILabel()
    
    override public func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(counterLabel)
        widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.labelHeight).isActive = true
        layer.cornerRadius = Constants.labelHeight / 2.0
        self.withHeight(Constants.labelHeight)
        counterLabel.fillSuperview(padding: Constants.labelInsets)
        setupUI()
    }
        
    // MARK: - Public Methods
    public func set(count: String) {
        counterLabel.text = count
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .black
       
        counterLabel.font = FontBook.statusFont
        counterLabel.textColor = .white
        counterLabel.textAlignment = .center
    }
}

// MARK: - Constants
extension DSBadgeCounterView {
    private enum Constants {
        static let labelInsets = UIEdgeInsets(top: 1, left: 6, bottom: 1, right: 6)
        static let labelHeight: CGFloat = 18
    }
}
