
import UIKit
import DiiaCommonTypes

public struct DSTopGroupViewBuilder: DSViewBuilderProtocol {
    public static let modelKey = "topGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTopGroupOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        let stack = UIStackView.create(spacing: Constants.spacing)
        
        if let navigationPanelMlc = data.navigationPanelMlc {
            let view = DSTopGroupView()
            view.configure(title: navigationPanelMlc.label ?? "")
            stack.addArrangedSubview(view)
        }
        if let titleGroupMlc = data.titleGroupMlc {
            let view = TopNavigationBigView()
            view.configure(
                viewModel: TopNavigationBigViewModel(
                    title: titleGroupMlc.heroText,
                    details: titleGroupMlc.label,
                    componentId: titleGroupMlc.componentId,
                    backAction: {
                        eventHandler(.action(DSActionParameter(type: "back")))
                    },
                    action: Action(iconName: UIComponentsConfiguration.shared.imageProvider?.imageNameForCode(imageCode: titleGroupMlc.mediumIconRight?.code ?? "")) {
                        guard let action = titleGroupMlc.mediumIconRight?.action else { return }
                        eventHandler(.action(action))
                    }
                )
            )
            stack.addArrangedSubview(view)
        }
        if let chipsOrg = data.chipTabsOrg {
            stack.addArrangedSubview(DSChipTabsViewBuilder().makeView(data: chipsOrg, eventHandler: eventHandler))
        }
        if let searchInputMlc = data.searchInputMlc {
            let searchInput = DSSearchInputViewBuilder().makeView(data: searchInputMlc, eventHandler: eventHandler)
            let view = BoxView(subview: searchInput).withConstraints(insets: Constants.subviewsInsets)
            stack.addArrangedSubview(view)
        }
        if let scalingTitleMlc = data.scalingTitleMlc {
            let scalingTitleView = DSScalingTitleBuilder().makeView(
                from: scalingTitleMlc,
                eventHandler: eventHandler)
            stack.addArrangedSubview(scalingTitleView)
        }
        
        if data.chipTabsOrg != nil {
            let divider = DSDividerLineView()
            divider.setupUI(height: Constants.dividerHeight)
            stack.addArrangedSubview(divider)
        }
        return stack
    }
    
    private enum Constants {
        static let spacing: CGFloat = 8
        static let subviewsInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        static let dividerHeight: CGFloat = 1
    }
}
