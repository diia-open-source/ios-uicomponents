
import UIKit

/// design_system_code: topGroupOrg
public class DSTopGroupView: BaseCodeView {
    private var navigation = TopNavigationView()
    private var tabChipView = DSChipTabsView()
    
    public override func setupSubviews() {
        backgroundColor = .clear
        stack([navigation, tabChipView], spacing: Constants.stackSpacing)
    }
    
    public func configure(title: String,
                          tabsViewModel: DSChipTabViewModel? = nil) {
        navigation.setupTitle(title: title)
        tabChipView.isHidden = tabsViewModel == nil
        if let tabs = tabsViewModel {
            tabChipView.configure(viewModel: tabs)
        }
    }
}

private extension DSTopGroupView {
    enum Constants {
        static let stackSpacing: CGFloat = 4
    }
}
