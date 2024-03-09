import UIKit

/// design_system_code: topGroupOrg
public class DSTopGroupView: BaseCodeView {
    private var navigation = DSNavigationBarView()
    private var tabChipView = DSChipTabsView()
    
    public override func setupSubviews() {
        backgroundColor = .clear
        stack([navigation, tabChipView], spacing: Constants.stackSpacing)
    }
    
    public func configure(navigationViewModel: DSNavigationBarViewModel,
                          tabsViewModel: DSChipTabViewModel? = nil) {
        navigation.configure(viewModel: navigationViewModel)
        tabChipView.isHidden = tabsViewModel == nil
        if let tabs = tabsViewModel {
            tabChipView.configure(viewModel: tabs)
        }
    }
    
    public func setupTitle(_ title: String, font: UIFont? = nil) {
        navigation.setupTitle(title, font: font)
    }
}

private extension DSTopGroupView {
    enum Constants {
        static let stackSpacing: CGFloat = 4
    }
}
