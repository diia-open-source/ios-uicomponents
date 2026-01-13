
import UIKit
import DiiaCommonTypes

public struct DSCalendarOrgV2Builder: DSViewBuilderProtocol {
    public let modelKey = "calendarOrgV2"
    
    public func makeView(from object: AnyCodable,
                         withPadding padding: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSCalendarOrgV2 = object.parseValue(forKey: self.modelKey) else { return nil }
        let view = DSCalendarOrgView()
        let viewModel = DSCalendarOrgViewModel(calendarOrg: data,
                                               inputCode: data.inputCode ?? self.modelKey)
        viewModel.eventHandler = eventHandler
        view.configure(for: viewModel)
        let insets = padding.defaultPaddingV2(object: object, modelKey: modelKey)
        let paddingBox = BoxView(subview: view).withConstraints(insets: insets)
        return paddingBox
    }
}

extension DSCalendarOrgV2Builder: DSViewMockableBuilderProtocol {
    public func makeMockModel() -> AnyCodable {
        let model = DSCalendarOrgV2(
            componentId: "calendarOrgV2",
            inputCode: "calendarOrgV2",
            mandatory: true,
            currentTimeMlc: .init(label: "Date.Year"),
            legends: [.init(legendGroupMlc: .init(
                componentId: "componentId",
                label: "label.legend",
                isVisible: true,
                type: .common))],
            iconForMovingForward: .mock,
            iconForMovingBackwards: .mock,
            columnsAmount: 6,
            items: [
                .init(
                    calendarItemOrg:
                            .init(
                                date: "Date.Year",
                                calendarItemAtm: .init(label: "Time:Minutes")))],
            paginationMessageMlc: .init(
                componentId: "paginationMessageMlc",
                title: "title",
                description: "description",
                btnStrokeAdditionalAtm: .init(label: "btnStrokeAdditionalAtm")))
        return .dictionary([
            modelKey: .fromEncodable(encodable: model)
        ])
    }
}

private extension DSCalendarOrgV2Builder {
    enum Constants {
        static let offset: CGFloat = 24
    }
}
