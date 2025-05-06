
import UIKit
import DiiaCommonTypes

public struct DSCalendarOrgBuilder: DSViewBuilderProtocol {
    public static let modelKey = "calendarOrg"
    
    public func makeView(from object: AnyCodable,
                         withPadding paddingType: DSViewPaddingType,
                         viewFabric: DSViewFabric?,
                         eventHandler: @escaping (ConstructorItemEvent) -> Void) -> UIView? {
        guard let data: DSCalendarOrg = object.parseValue(forKey: Self.modelKey) else { return nil }
        let view = DSCalendarOrgView()
        let viewModel = DSCalendarOrgViewModel(calendarOrg: data,
                                               inputCode: data.inputCode ?? Self.modelKey)
        viewModel.eventHandler = eventHandler
        view.configure(for: viewModel)
        let container = UIView()
        container.addSubview(view)
        view.fillSuperview(padding: .init(top: Constants.offset, left: Constants.offset, bottom: 0, right: Constants.offset))
        return container
    }
}

private extension DSCalendarOrgBuilder {
    enum Constants {
        static let offset: CGFloat = 24
    }
}
