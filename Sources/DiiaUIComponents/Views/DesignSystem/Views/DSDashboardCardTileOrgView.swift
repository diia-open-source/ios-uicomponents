
import Foundation
import UIKit

/// design_system_code: dashboardCardTileOrg

public class DSDashboardCardTileViewModel {
    public let dashboardItems: [DSDashboardCardItem]
    public let eventHandler: ((ConstructorItemEvent) -> ())?
    
    init(dashboardItems: [DSDashboardCardItem],
         eventHandler: ((ConstructorItemEvent) -> ())?) {
        self.dashboardItems = dashboardItems
        self.eventHandler = eventHandler
    }
}

public class DSDashboardCardTileOrgView: BaseCodeView {
    
    private let widgetStack = UIStackView()
    
    private var viewModel: DSDashboardCardTileViewModel?
    
    public override func setupSubviews() {
        super.setupSubviews()
        widgetStack.axis = Constants.stackAxis
        widgetStack.alignment = .fill
        widgetStack.distribution = .fillEqually
        widgetStack.spacing = Constants.smallPadding
        addSubview(widgetStack)
        widgetStack.fillSuperview()
    }
    
    public func configure(with viewModel: DSDashboardCardTileViewModel) {
        self.viewModel = viewModel
        for item in viewModel.dashboardItems {
            if let dashboardCardMlc = item.dashboardCardMlc {
                let dashboardCardViewModel = DSDashboardCardMlcViewModel(dashboardCardMlc: dashboardCardMlc,
                                                                         eventHandler: viewModel.eventHandler)
                let dashboardCardView = DSDashboardCardMlcView()
                dashboardCardView.configure(with: dashboardCardViewModel)
                dashboardCardView.withHeight(Constants.viewHeight)
                widgetStack.addArrangedSubview(dashboardCardView)
            }
        }
    }
}

extension DSDashboardCardTileOrgView {
    enum Constants {
        static let smallPadding: CGFloat = 8
        static let viewHeight: CGFloat = 132
        static var stackAxis: NSLayoutConstraint.Axis = {
            switch UIScreen.main.bounds.width {
            case 320:
                return .vertical
            default:
                return .horizontal
            }
        }()

    }
}
