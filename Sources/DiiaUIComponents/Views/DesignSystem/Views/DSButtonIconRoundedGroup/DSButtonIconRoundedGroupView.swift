
import UIKit

public struct DSButtonIconRoundedGroupViewModel {
    public let items: [DSButtonIconRoundedItem]
    public let touchCallback: (DSActionParameter) -> Void
    
    public init(items: [DSButtonIconRoundedItem], touchCallback: @escaping (DSActionParameter) -> Void) {
        self.items = items
        self.touchCallback = touchCallback
    }
}

/// design_system_code: btnIconRoundedGroupOrg
public final class DSButtonIconRoundedGroupView: BaseCodeView {
    private let buttonsStackView = UIStackView.create(.horizontal, alignment: .top, distribution: .fillEqually)
    
    private var viewModel: DSButtonIconRoundedGroupViewModel?
    
    override public func setupSubviews() {
        addSubview(buttonsStackView)
        buttonsStackView.fillSuperview()
    }
    
    // MARK: - Public Methods
    public func configure(with viewModel: DSButtonIconRoundedGroupViewModel) {
        self.viewModel = viewModel
        
        buttonsStackView.safelyRemoveArrangedSubviews()
        viewModel.items.forEach { item in
            let view = DSButtonIconRoundedItemView()
            view.configure(with: item.btnIconRoundedMlc) { [weak self] in
                self?.viewModel?.touchCallback(item.btnIconRoundedMlc.action)
            }
            buttonsStackView.addArrangedSubview(view)
        }
    }
}
