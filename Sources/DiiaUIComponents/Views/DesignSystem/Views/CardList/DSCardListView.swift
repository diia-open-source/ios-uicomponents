
import UIKit

/// design_system_code: cardsListOrg
public class DSCardListView: BaseCodeView {
    
    private let stackView = UIStackView.create(.vertical, spacing: Constants.stackSpacing)
   
    deinit {
        stackView.safelyRemoveArrangedSubviews()
    }
    
    override public func setupSubviews() {
        super.setupSubviews()
        
        addSubview(stackView)
        stackView.fillSuperview()
        backgroundColor = .clear
        stackView.backgroundColor = .clear
    }
    
    public func configure(items: [DSCommonCardViewModel]) {
        stackView.safelyRemoveArrangedSubviews()
        items.forEach {
            let view = DSCommonCardView()
            stackView.addArrangedSubview(view)
            view.configure(with: $0)
            view.willDisplay()
        }
        layoutIfNeeded()
    }
}

extension DSCardListView {
    private enum Constants {
        static let stackSpacing: CGFloat = 16
    }
}
