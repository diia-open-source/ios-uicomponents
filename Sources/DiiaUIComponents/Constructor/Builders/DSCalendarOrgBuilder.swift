
import UIKit
import DiiaCommonTypes

public struct DSCalendarOrgBuilder: DSViewBuilderProtocol {
    public let modelKey = "calendarOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSCalendarOrg = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSCalendarOrgView()
        let viewModel = DSCalendarOrgViewModel(calendarOrg: data,
                                               inputCode: data.inputCode ?? self.modelKey)
        viewModel.eventHandler = eventHandler
        view.configure(for: viewModel)
        let container = UIView()
        container.addSubview(view)
        view.fillSuperview(padding: .init(top: Constants.offset, left: Constants.offset, bottom: 0, right: Constants.offset))
        return container
    }
}

extension DSCalendarOrgBuilder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCalendarOrg(
            componentId: "componentId",
            inputCode: "calendar_input",
            mandatory: true,
            currentTimeMlc: DSCurrentTimeMlc(
                componentId: "componentId",
                label: "Current Time",
                maxDate: "2024-12-31",
                action: DSActionParameter(
                    type: "time",
                    subtype: "current",
                    resource: "mock_resource",
                    subresource: "mock_subresource"
                )
            ),
            iconForMovingForward: DSMovingIcon(
                iconAtm: DSIconModel(
                    code: "home",
                    accessibilityDescription: "Move forward",
                    componentId: "componentId",
                    action: DSActionParameter(
                        type: "navigation",
                        subtype: "forward",
                        resource: "mock_resource",
                        subresource: "mock_subresource"
                    ),
                    isEnable: true
                )
            ),
            iconForMovingBackwards: DSMovingIcon(
                iconAtm: DSIconModel(
                    code: "info",
                    accessibilityDescription: "Move backward",
                    componentId: "componentId",
                    action: DSActionParameter(
                        type: "navigation",
                        subtype: "backward",
                        resource: "mock_resource",
                        subresource: "mock_subresource"
                    ),
                    isEnable: true
                )
            ),
            columnsAmount: 7,
            items: [
                DSCalendarItem(
                    calendarItemOrg: DSCalendarItemOrg(
                        componentId: "componentId",
                        date: "2024-01-15",
                        calendarItemAtm: DSCalendarItemAtm(
                            label: "15",
                            isActive: true,
                            isToday: false,
                            isSelected: false
                        ),
                        chipGroupOrg: DSChipGroupOrg(
                            componentId: "componentId",
                            label: "Chip Group",
                            preselectedCode: "event_chip",
                            items: [
                                DSChipItemMlc(
                                    chipMlc: DSChipMlc(
                                        componentId: "componentId",
                                        label: "Event",
                                        code: "event_chip",
                                        badgeCounterAtm: DSBadgeCounterModel(count: 1),
                                        iconLeft: DSIconModel(
                                            code: "info",
                                            accessibilityDescription: "Event icon",
                                            componentId: "componentId",
                                            action: DSActionParameter(
                                                type: "icon",
                                                subtype: "chip",
                                                resource: "mock_resource",
                                                subresource: "mock_subresource"
                                            ),
                                            isEnable: true
                                        ),
                                        active: true,
                                        selectedIcon: "home",
                                        isSelectable: true,
                                        chipInfo: DSChipInfo(hallId: "hall_123"),
                                        action: DSActionParameter(
                                            type: "chip",
                                            subtype: "calendar",
                                            resource: "mock_resource",
                                            subresource: "mock_subresource"
                                        )
                                    ),
                                    chipTimeMlc: DSChipTimeMlc(
                                        componentId: "componentId",
                                        id: "time_chip_1",
                                        label: "10:00",
                                        dataJson: .dictionary([
                                            "startTime": .string("10:00"),
                                            "endTime": .string("11:00"),
                                            "timeSlot": .string("morning")
                                        ]),
                                        active: true
                                    )
                                )
                            ]
                        )
                    )
                )
            ],
            stubMessageMlc: DSStubMessageMlc(
                icon: "info",
                title: "No Events",
                description: "No events available for this calendar",
                componentId: "componentId",
                parameters: [
                    TextParameter(
                        type: .link,
                        data: TextParameterData(
                            name: "learnMore",
                            alt: "Learn More",
                            resource: "https://example.com"
                        )
                    )
                ],
                btnStrokeAdditionalAtm: DSButtonModel(
                    label: "Add Event",
                    state: .enabled,
                    action: DSActionParameter(
                        type: "button",
                        subtype: "add_event",
                        resource: "mock_resource",
                        subresource: "mock_subresource"
                    ),
                    componentId: "componentId"
                )
            )
        )
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

private extension DSCalendarOrgBuilder {
    enum Constants {
        static let offset: CGFloat = 24
    }
}
