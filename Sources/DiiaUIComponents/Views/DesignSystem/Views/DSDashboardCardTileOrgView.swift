
import Foundation
import UIKit

/// design_system_code: dashboardCardTileOrg
public final class DSDashboardCardTileViewModel {
    public let dashboardItems: [DSDashboardCardItem]
    public let eventHandler: ((ConstructorItemEvent) -> ())?
    
    init(dashboardItems: [DSDashboardCardItem],
         eventHandler: ((ConstructorItemEvent) -> ())?) {
        self.dashboardItems = dashboardItems
        self.eventHandler = eventHandler
    }
}

public final class DSDashboardCardTileOrgView: BaseCodeView {
    
    private let rowsStack = UIStackView()
    
    private var viewModel: DSDashboardCardTileViewModel?
    
    public override func setupSubviews() {
        super.setupSubviews()
        
        rowsStack.axis = .vertical
        rowsStack.spacing = Constants.smallPadding
        
        addSubview(rowsStack)
        rowsStack.fillSuperview()
    }
    
    public func configure(with viewModel: DSDashboardCardTileViewModel) {
        self.viewModel = viewModel
        rowsStack.safelyRemoveArrangedSubviews()
        
        let cardViews: [UIView] = viewModel.dashboardItems.compactMap(makeDashboardCard)
        for i in stride(from: 0, to: cardViews.count, by: 2) {
            let row = makeRowStack()
            row.addArrangedSubview(cardViews[i])
            if i + 1 < cardViews.count {
                row.addArrangedSubview(cardViews[i + 1])
            }
            rowsStack.addArrangedSubview(row)
        }
    }
    
    // MARK: - Private Methods
    private func makeDashboardCard(_ item: DSDashboardCardItem) -> UIView? {
        guard let viewModel, let dashboardCardMlc = item.dashboardCardMlc else { return nil }
        
        let dashboardCardViewModel = DSDashboardCardMlcViewModel(
            dashboardCardMlc: dashboardCardMlc,
            eventHandler: viewModel.eventHandler
        )
        let dashboardCardView = DSDashboardCardMlcView()
        dashboardCardView.configure(with: dashboardCardViewModel)
        dashboardCardView.withHeight(Constants.viewHeight)
        
        return dashboardCardView
    }
    
    private func makeRowStack() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.alignment = .fill
        row.distribution = .fillEqually
        row.spacing = Constants.smallPadding
        return row
    }
}

extension DSDashboardCardTileOrgView {
    enum Constants {
        static let smallPadding: CGFloat = 8
        static let viewHeight: CGFloat = 144
    }
}
