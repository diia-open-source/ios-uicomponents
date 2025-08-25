
import UIKit
import DiiaCommonTypes

public struct DSHorizontalScrollCardData: Codable {
    public let componentId: String?
    public let cardsGroup: [DSListGroup]
    
    public init(
        componentId: String? = nil,
        cardsGroup: [DSListGroup]
    ) {
        self.componentId = componentId
        self.cardsGroup = cardsGroup
    }
}

final public class DSHorizontalScrollCardView: BaseCodeView {
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        return view
    }()
    
    private let stackView : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = Constants.spacing
        return view
    }()
    
    private var cardWidth: CGFloat = 0
    
    var listViews: [UIView] = [] {
        didSet {
            setupListViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: Constants.leftRightInset, bottom: 0, right: 0)
    }

    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.delegate = self
        
        scrollView.addSubview(stackView)
        stackView.fillSuperview()
        
        scrollView.heightAnchor.constraint(equalToConstant: Constants.viewHeight).isActive = true
    }
    
    private func setupListViews() {
        stackView.safelyRemoveArrangedSubviews()
        
        for view in listViews {
            stackView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalToConstant: Constants.viewHeight).isActive = true
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor,
                                        multiplier: Constants.widthMultiplier).isActive = true
        }
        
        scrollView.isScrollEnabled = listViews.count > 1
        
        DispatchQueue.main.async {[weak self] in
            guard let self else { return }
            self.cardWidth = self.frame.width * Constants.widthMultiplier + Constants.spacing
            self.scrollView.contentSize = CGSize(
                width: self.cardWidth * CGFloat(self.listViews.count) + Constants.leftRightInset,
                height: Constants.viewHeight
            )
        }
    }
    
    func configure(with data: DSHorizontalScrollCardData,
                   eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        let builder = DSListViewBuilder()
        var viewList: [UIView] = []
        for card in data.cardsGroup {
            if let cardView = builder.makeView(
                from: card,
                withPadding: .fixed(paddings: Constants.itemPadding),
                eventHandler: eventHandler) as? BoxView<DSWhiteColoredListView> {
                cardView.subview.setupSubitems(alignment: .top,
                                               titleLines: Constants.titleLines,
                                               detailLines: Constants.detailLines)
                viewList.append(cardView)
            }
        }
        listViews = viewList
    }
}

extension DSHorizontalScrollCardView: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let estimatedIndex = (targetContentOffset.pointee.x + cardWidth / 2) / cardWidth - 1
        let roundedIndex = ceil(estimatedIndex)
        targetContentOffset.pointee.x = roundedIndex * cardWidth - Constants.leftRightInset
    }
}

private extension DSHorizontalScrollCardView {
    enum Constants {
        static let viewHeight: CGFloat = 189
        static let widthMultiplier: CGFloat = 0.88
        static let spacing: CGFloat = 8
        static let leftRightInset: CGFloat = 24
        static let titleLines = 3
        static let detailLines = 2
        static let itemPadding = UIEdgeInsets(top: 16, left: .zero, bottom: .zero, right: .zero)
    }
}
