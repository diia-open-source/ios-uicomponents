import UIKit

public struct InfoBlockViewConfig {
    let blocksSpacing: CGFloat
    let titledContentViewConfig: TitledContentViewConfig
    
    public init(blocksSpacing: CGFloat = 32,
                titledContentViewConfig: TitledContentViewConfig = .init()) {
        self.blocksSpacing = blocksSpacing
        self.titledContentViewConfig = titledContentViewConfig
    }
}

open class InfoBlockView: BaseCodeView {
    private let infoBlockViewConfig: InfoBlockViewConfig
    private let blocksStack = UIStackView.create(views: [])

    // MARK: - Lifecycle
    public init(config: InfoBlockViewConfig = .init()) {
        self.infoBlockViewConfig = config
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.infoBlockViewConfig = .init()
        super.init(coder: aDecoder)
    }
    
    public override func setupSubviews() {
        backgroundColor = .clear
        addSubview(blocksStack)
        blocksStack.spacing = infoBlockViewConfig.blocksSpacing
        blocksStack.fillSuperview()
    }
    
    // MARK: - Public
    public func configure(blocks: [TitledContentViewModel]) {
        blocksStack.safelyRemoveArrangedSubviews()
        for block in blocks {
            let titledContentView = TitledContentView(config: infoBlockViewConfig.titledContentViewConfig)
            titledContentView.configure(viewModel: block)
            blocksStack.addArrangedSubview(titledContentView)
        }
    }
}

public struct TitledContentViewModel {
    public let title: String?
    public let content: [TitledContentType]
    
    public init(title: String? = nil, content: [TitledContentViewModel.TitledContentType]) {
        self.title = title
        self.content = content
    }
    
    public enum TitledContentType {
        case single(value: String)
        case verticalPair(title: String, value: String)
        case horizontalPair(title: String, value: String)
        case separator
    }
}

public struct TitledContentViewConfig {
    let titleProportion: CGFloat
    let bigSpacing: CGFloat
    let smallSpacing: CGFloat
    let labelValueSpacing: CGFloat
    
    public init(titleProportion: CGFloat = 0.4,
                bigSpacing: CGFloat = 16,
                smallSpacing: CGFloat = 8,
                labelValueSpacing: CGFloat = 4) {
        self.titleProportion = titleProportion
        self.bigSpacing = bigSpacing
        self.smallSpacing = smallSpacing
        self.labelValueSpacing = labelValueSpacing
    }
}

public class TitledContentView: BaseCodeView {
    private let titledContenViewConfig: TitledContentViewConfig
    let titleLabel = UILabel().withParameters(font: FontBook.smallHeadingFont)
    let contentStack = UIStackView.create(views: [])

    // MARK: - Lifecycle
    public init(config: TitledContentViewConfig = .init()) {
        self.titledContenViewConfig = config
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupSubviews() {
        backgroundColor = .clear
        stack(titleLabel, contentStack, spacing: titledContenViewConfig.bigSpacing)
        contentStack.spacing = titledContenViewConfig.smallSpacing
    }
    
    // MARK: - Public
    public func configure(viewModel: TitledContentViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.isHidden = viewModel.title?.count ?? 0 == 0
        contentStack.isHidden = viewModel.content.count == 0
        contentStack.safelyRemoveArrangedSubviews()
        for item in viewModel.content {
            switch item {
            case .single(let value):
                contentStack.addArrangedSubview(singleLabelView(title: value))
            case .verticalPair(let title, let value):
                contentStack.addArrangedSubview(verticalLabelValueView(title: title, value: value))
            case .horizontalPair(title: let title, value: let value):
                contentStack.addArrangedSubview(horizontalLabelValueView(title: title, value: value))
            case .separator:
                let separator = UIView()
                separator.withHeight(2)
                separator.backgroundColor = UIColor(AppConstants.Colors.separatorColor)
                contentStack.addArrangedSubview(separator)
            }
        }
    }
    
    // MARK: - Private
    private func singleLabelView(title: String) -> UIView {
        let label = UILabel().withParameters(font: FontBook.usualFont)
        label.text = title
        return label
    }
    
    private func horizontalLabelValueView(title: String, value: String) -> UIView {
        let pairView = PairView()
        pairView.setupUI(titleProportion: titledContenViewConfig.titleProportion)
        pairView.configure(title: title, details: value)
        return pairView
    }
    
    private func verticalLabelValueView(title: String, value: String) -> UIView {
        let titleLbl = UILabel().withParameters(font: FontBook.usualFont)
        let valueLbl = UILabel().withParameters(font: FontBook.usualFont)
        titleLbl.text = title
        valueLbl.text = value
        return UIStackView.create(
            views: [titleLbl, valueLbl],
            spacing: titledContenViewConfig.labelValueSpacing)
    }
}
