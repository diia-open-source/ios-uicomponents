
import UIKit
import DiiaCommonTypes

public struct DSTopGroupViewBuilder: DSViewBuilderProtocol {
    public let modelKey = "topGroupOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSTopGroupOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        let stack = UIStackView.create(spacing: Constants.spacing)
        
        if let navigationPanelMlc = data.navigationPanelMlc {
            let view = DSTopGroupView()
            view.configure(title: navigationPanelMlc.label ?? "")
            stack.addArrangedSubview(view)
        }
        if let titleGroupMlc = data.titleGroupMlc {
            let view = TopNavigationBigView()
            let action: Action? = titleGroupMlc.mediumIconRight?.action.flatMap { iconAction in
                Action(iconName: UIComponentsConfiguration.shared.imageProvider.imageNameForCode(imageCode: titleGroupMlc.mediumIconRight?.code ?? "")) {
                    eventHandler(.action(iconAction))
                }
            }
            
            view.configure(
                viewModel: TopNavigationBigViewModel(
                    title: titleGroupMlc.heroText,
                    details: titleGroupMlc.label,
                    componentId: titleGroupMlc.componentId,
                    backAction: titleGroupMlc.hideBackButton == true ? nil : {
                        eventHandler(.action(DSActionParameter(type: "back")))
                    },
                    action: action
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
        
        return stack
    }
    
    private enum Constants {
        static let spacing: CGFloat = 8
        static let subviewsInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        static let dividerHeight: CGFloat = 1
    }
}

extension DSTopGroupViewBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSTopGroupOrg(
            titleGroupMlc: DSTopGroupMlc(
                componentId: "componentId",
                leftNavIcon: DSIconModel(
                    code: "code",
                    accessibilityDescription: "accessibilityDescription",
                    componentId: "componentId",
                    action: .init(
                        type: "iconAction"
                    ),
                    isEnable: true
                ),
                heroText: "heroText",
                label: "label",
                mediumIconRight: DSIconModel(
                    code: "code",
                    accessibilityDescription: "accessibilityDescription",
                    componentId: "componentId",
                    action: .init(
                        type: "iconAction"
                    ),
                    isEnable: true
                ),
                hideBackButton: false
            ),
            navigationPanelMlc: DSNavigationPanelMlc(
                label: "label",
                ellipseMenu: []
            ),
            chipTabsOrg: DSChipGroupOrg(
                componentId: "componentId",
                label: "label",
                preselectedCode: "preselectedCode",
                items: [DSChipItemMlc(
                    chipMlc: DSChipMlc(
                        componentId: "componentId",
                        label: "label",
                        code: "code",
                        badgeCounterAtm: DSBadgeCounterModel(count: 1),
                        iconLeft: DSIconModel(
                            code: "code",
                            accessibilityDescription: "accessibilityDescription",
                            componentId: "componentId",
                            action: .init(
                                type: "iconAction"
                            ),
                            isEnable: true
                        ),
                        active: false,
                        selectedIcon: "selectedIcon",
                        isSelectable: true,
                        chipInfo: DSChipInfo(hallId: "hallId"),
                        action: DSActionParameter(type: "action")
                    ),
                    chipTimeMlc: DSChipTimeMlc(
                        componentId: "componentId",
                        id: "id",
                        label: "label",
                        dataJson: .string("dataJson"),
                        active: false
                    )
                )]
            ),
            scalingTitleMlc: DSScalingTitleMlc(
                componentId: "componentId",
                label: "label"
            ),
            searchInputMlc: DSSearchModel(
                componentId: "componentId",
                label: "label",
                iconLeft: DSIconModel(
                    code: "code",
                    accessibilityDescription: "accessibilityDescription",
                    componentId: "componentId",
                    action: DSActionParameter(
                        type: "type",
                        subtype: "subtype",
                        resource: "resource",
                        subresource: "subresource"),
                    isEnable: true
                ),
                iconRight: DSIconModel(
                    code: "code",
                    accessibilityDescription: "accessibilityDescription",
                    componentId: "componentId",
                    action: DSActionParameter(
                        type: "type",
                        subtype: "subtype",
                        resource: "resource",
                        subresource: "subresource"),
                    isEnable: true
                )
            )
        )
        
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

