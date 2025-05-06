
import Foundation
import UIKit

public final class DSCardMlcV2View: BaseCodeView {
    private let mainStack = UIStackView.create(.vertical, spacing: Constants.spacing)
    private let contentHStack = UIStackView.create(.horizontal, spacing: Constants.contentHStackSpacing, alignment: .leading)
    private let contentVStack = UIStackView.create(.vertical, spacing: Constants.spacing)
    private let descriptionsStack = UIStackView.create()
    private let singleChipStack = UIStackView.create(.vertical, alignment: .leading)
    private let chipStatusAtmView = DSChipStatusAtmView()
    private let label = UILabel().withParameters(font: FontBook.bigText)
    private let iconUrlView = DSIconUrlAtmView()
    private let bottomRightIcon = UIImageView()
    private var eventHandler: ((ConstructorItemEvent) -> Void) = { _ in }
    private var model: DSCardMlcV2Model?
    
    private lazy var chipsCollectionView: UICollectionView = {
        let layout = DSCardMlcV2CollectionFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumLineSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DSCardMlcV2ChipCell.self, forCellWithReuseIdentifier: DSCardMlcV2ChipCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        collectionView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    public override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        addSubviews()
        setupLayout()
        handleTap()
    }
    // MARK: - Public methods
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }
    
    public func configure(with model: DSCardMlcV2Model) {
        self.model = model
        accessibilityIdentifier = model.componentId
        label.text = model.label
        
        singleChipStack.isHidden = model.chipStatusAtm == nil
        if let chipStatusAtm = model.chipStatusAtm {
            chipStatusAtmView.configure(for: chipStatusAtm)
        }
        
        descriptionsStack.isHidden = model.descriptions == nil
        if let descriptions = model.descriptions {
            descriptionsStack.safelyRemoveArrangedSubviews()
            descriptions.forEach {
                let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: Constants.descriptionLabelTextColor)
                descriptionLabel.text = $0
                descriptionsStack.addArrangedSubview(descriptionLabel)
            }
        }
        
        iconUrlView.isHidden = model.iconUrlAtm == nil
        if let iconUrlAtm = model.iconUrlAtm {
            iconUrlView.configure(with: iconUrlAtm)
        }
        
        chipsCollectionView.isHidden = model.chips == nil
        chipsCollectionView.reloadData()
    }
    
    public func set(eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }
    
    // MARK: - Private methods
    private func addSubviews() {
        addSubview(mainStack)
        mainStack.addArrangedSubviews([
            singleChipStack,
            contentHStack
        ])
        singleChipStack.addArrangedSubview(chipStatusAtmView)
        contentHStack.addArrangedSubviews([
            iconUrlView,
            contentVStack
        ])
        contentVStack.addArrangedSubviews([
            label,
            descriptionsStack,
            chipsCollectionView
        ])
    }
    
    private func setupLayout() {
        mainStack.fillSuperview(padding: Constants.mainStackPaddings)
        chipStatusAtmView.withHeight(Constants.chipsHeight)
        iconUrlView.withSize(Constants.iconUrlSize)
    }
    
    private func updateCollectionViewHeight() {
        guard let chips = model?.chips, !chips.isEmpty else { return }
        
        let availableWidth = mainStack.bounds.width - (Constants.mainStackPaddings.left + Constants.mainStackPaddings.right)
        guard availableWidth > 0 else { return }
        
        let contentHStackSpacing = Constants.contentHStackSpacing
        let adjustedWidth = availableWidth - contentHStackSpacing
        
        var currentRowWidth: CGFloat = 0
        var rowCount: CGFloat = 1
        
        for chip in chips {
            let chipWidth = DSChipStatusAtmView.widthForText(text: chip.chipStatusAtm.name)
            let totalChipWidth = chipWidth + (currentRowWidth > 0 ? Constants.minimumInteritemSpacing : 0)
            if currentRowWidth + totalChipWidth > adjustedWidth {
                rowCount += 1
                currentRowWidth = chipWidth
            } else {
                currentRowWidth += totalChipWidth
            }
        }
        let chipHeight = Constants.chipsHeight
        let totalHeight = (rowCount * chipHeight) + ((rowCount - 1) * Constants.minimumLineSpacing)
        
        chipsCollectionView.withHeight(totalHeight)
    }
    
    private func handleTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
    }
    
    @objc private func onTap() {
        guard let action = model?.action else { return }
        eventHandler(.action(action))
    }
}

// MARK: - UICollectionViewDataSource
extension DSCardMlcV2View: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.chips?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let chip = model?.chips?[indexPath.item] {
            let cell: DSCardMlcV2ChipCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: chip.chipStatusAtm)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DSCardMlcV2View: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let chip = model?.chips?[indexPath.item] else { return .zero }
        let width = DSChipStatusAtmView.widthForText(text: chip.chipStatusAtm.name)
        return CGSize(width: width, height: Constants.chipsHeight)
    }
}

// MARK: - Constants
private extension DSCardMlcV2View {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let sideInset: CGFloat = 16
        static let spacing: CGFloat = 8
        static let mainStackPaddings: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let contentHStackSpacing: CGFloat = 10
        static let descriptionLabelTextColor: UIColor = .black.withAlphaComponent(0.3)
        static let chipsHeight: CGFloat = 18
        static let iconUrlSize: CGSize = .init(width: 32, height: 32)
        static let minimumLineSpacing: CGFloat = 8
        static let minimumInteritemSpacing: CGFloat = 8
    }
}
