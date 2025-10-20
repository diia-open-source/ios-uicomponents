
import Foundation
import UIKit

public final class DSCardMlcV2View: BaseCodeView {
    private let mainStack = UIStackView.create(.vertical, spacing: Constants.spacing)
    private let contentHStack = UIStackView.create(.horizontal, spacing: Constants.contentHStackSpacing, alignment: .leading)
    private let contentVStack = UIStackView.create(.vertical, spacing: Constants.mediumSpacing)
    private let descriptionsStack = UIStackView.create()
    private let rowsStack = UIStackView.create(spacing: Constants.mediumSpacing)
    private let statusLabelStack = UIStackView.create(.horizontal, alignment: .center, distribution: .fill)
    private let descriptionLabelStack =  UIStackView.create(spacing: Constants.smallSpacing)
    private let attentionIconMessageView = DSAttentionIconMessageView()
    private let chipStatusAtmView = DSChipStatusAtmView()
    private let label = UILabel().withParameters(font: FontBook.bigText)
    private let rightLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: Constants.grayTextColor)
    private let iconUrlView = DSIconUrlAtmView()
    private let bottomIconContainer = UIView()
    private let bottomRightIcon = DSIconView()
    private var eventHandler: ((ConstructorItemEvent) -> Void) = { _ in }
    private var chipsCollectionViewHeightConstraint: NSLayoutConstraint?
    private var viewModel: DSCardMlcV2ViewModel?
    
    private var lastChipsWidthStored: CGFloat = 0
    private var lastAppliedChipsHeight: CGFloat = 0
    
    private lazy var chipsCollectionView: UICollectionView = {
        let layout = DSCardMlcV2CollectionFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.minimumInteritemSpacing = Constants.minimumLineSpacing
        layout.estimatedItemSize = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DSCardMlcV2ChipCell.self, forCellWithReuseIdentifier: DSCardMlcV2ChipCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        collectionView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .zero
        collectionView.scrollIndicatorInsets = .zero
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.alwaysBounceVertical = false

        return collectionView
    }()
    
    // MARK: - Lifecycle
    public override func setupSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Constants.cornerRadius
        addSubviews()
        setupLayout()
        handleTap()
        
        bottomRightIcon.onClick = { [weak self] action in
            self?.viewModel?.onTap?(action)
        }
    }
    
    // MARK: - Public methods
    public override func layoutSubviews() {
        super.layoutSubviews()
        let width = chipsCollectionView.bounds.width
        guard width > 0 else { return }
        if width != lastChipsWidthStored {
            lastChipsWidthStored = width
            updateCollectionViewHeight()
        }
    }
    
    public func configure(with viewModel: DSCardMlcV2ViewModel) {
        self.viewModel = viewModel
        
        accessibilityIdentifier = viewModel.componentId
        label.text = viewModel.label
        
        attentionIconMessageView.isHidden = viewModel.attentionIconMessageMlc == nil
        if let attentionIconMessageMlc = viewModel.attentionIconMessageMlc {
            attentionIconMessageView.configure(with: attentionIconMessageMlc)
        }
        
        statusLabelStack.isHidden = viewModel.chipStatusAtm == nil && viewModel.rightLabel == nil
        chipStatusAtmView.isHidden = viewModel.chipStatusAtm == nil
        if let chipStatusAtm = viewModel.chipStatusAtm {
            chipStatusAtmView.configure(for: chipStatusAtm)
        }
        
        rightLabel.isHidden = viewModel.rightLabel == nil
        rightLabel.text = viewModel.rightLabel
        
        descriptionsStack.isHidden = viewModel.descriptions == nil
        if let descriptions = viewModel.descriptions {
            descriptionsStack.safelyRemoveArrangedSubviews()
            descriptions.forEach {
                let descriptionLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: Constants.grayTextColor)
                descriptionLabel.text = $0
                descriptionsStack.addArrangedSubview(descriptionLabel)
            }
        }
        
        rowsStack.isHidden = viewModel.rows?.isEmpty ?? true
        if let rows = viewModel.rows {
            rowsStack.safelyRemoveArrangedSubviews()
            rows.forEach {
                let rowLabel = UILabel().withParameters(font: FontBook.usualFont, textColor: Constants.grayTextColor)
                rowLabel.text = $0
                rowsStack.addArrangedSubview(rowLabel)
            }
        }
        
        iconUrlView.isHidden = viewModel.iconUrlAtm == nil
        if let iconUrlAtm = viewModel.iconUrlAtm {
            iconUrlView.configure(with: iconUrlAtm)
        }
        
        let iconModel = viewModel.currentStateIconModel ?? viewModel.smallIconAtm
        bottomIconContainer.isHidden = iconModel == nil
        if let iconModel {
            bottomRightIcon.setIcon(iconModel)
        }
        
        viewModel.smallIconAtmState.observe(observer: self) { [weak self] state in
            guard let iconModel = self?.viewModel?.currentStateIconModel else {
                return
            }
            
            self?.bottomRightIcon.setIcon(iconModel)
        }
        chipsCollectionView.isHidden = viewModel.chips?.isEmpty ?? true
        chipsCollectionView.reloadData()
        chipsCollectionView.layoutIfNeeded()
        updateCollectionViewHeight()
    }
    
    public func set(eventHandler: @escaping (ConstructorItemEvent) -> Void) {
        self.eventHandler = eventHandler
    }
    
    // MARK: - Private methods
    private func addSubviews() {
        addSubview(mainStack)
        mainStack.addArrangedSubviews([
            statusLabelStack,
            contentHStack,
            attentionIconMessageView
        ])
        
        statusLabelStack.addArrangedSubviews([
            chipStatusAtmView,
            rightLabel
        ])
        
        bottomIconContainer.addSubview(bottomRightIcon)
        
        contentHStack.addArrangedSubviews([
            iconUrlView,
            contentVStack,
            bottomIconContainer
        ])
        
        descriptionLabelStack.addArrangedSubviews([
            label,
            descriptionsStack
        ])
        
        contentVStack.addArrangedSubviews([
            descriptionLabelStack,
            rowsStack,
            chipsCollectionView
        ])
    }
    
    private func setupLayout() {
        mainStack.fillSuperview(padding: Constants.mainStackPaddings)
        chipStatusAtmView.withHeight(Constants.chipsHeight)
        iconUrlView.withSize(Constants.iconUrlSize)
        bottomRightIcon.withSize(Constants.bottomIconUrlSize)
        
        chipsCollectionViewHeightConstraint = chipsCollectionView.heightAnchor.constraint(equalToConstant: 0)
        chipsCollectionViewHeightConstraint?.isActive = true
        
        bottomIconContainer.anchor(bottom: contentHStack.bottomAnchor)
        bottomRightIcon.anchor(bottom: bottomIconContainer.bottomAnchor,trailing: bottomIconContainer.trailingAnchor)
        bottomIconContainer.widthAnchor.constraint(equalToConstant: Constants.widthAnchor).isActive = true
        
        bottomIconContainer.setContentHuggingPriority(.required, for: .horizontal)
        bottomIconContainer.setContentCompressionResistancePriority(.required, for: .horizontal)
        bottomRightIcon.tapArea = .superviewBounds
    }
    
    private func updateCollectionViewHeight() {
        guard let chips = viewModel?.chips, !chips.isEmpty else {
            if chipsCollectionViewHeightConstraint?.constant != 0 {
                chipsCollectionViewHeightConstraint?.constant = 0
                lastAppliedChipsHeight = 0
            }
            return
        }
        
        chipsCollectionView.collectionViewLayout.invalidateLayout()
        chipsCollectionView.layoutIfNeeded()
        
        let inset = chipsCollectionView.adjustedContentInset
        let contentH = chipsCollectionView.collectionViewLayout.collectionViewContentSize.height
        let verticalInset = inset.top + inset.bottom
        
        let newHeight = contentH - verticalInset
   
        if lastAppliedChipsHeight != newHeight {
            lastAppliedChipsHeight = newHeight
            if chipsCollectionViewHeightConstraint?.constant != newHeight {
                chipsCollectionViewHeightConstraint?.constant = newHeight
            }
        }
    }
    
    private func handleTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tap)
    }
    
    @objc private func onTap() {
        guard let action = viewModel?.action else { return }
        eventHandler(.action(action))
    }
}

// MARK: - UICollectionViewDataSource
extension DSCardMlcV2View: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.chips?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let chip = viewModel?.chips?[indexPath.item] {
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
        guard let chip = viewModel?.chips?[indexPath.item] else { return .zero }
        let width = DSChipStatusAtmView.widthForText(text: chip.chipStatusAtm.name)
        return CGSize(width: width, height: Constants.chipsHeight)
    }
}

// MARK: - Constants
private extension DSCardMlcV2View {
    enum Constants {
        static let cornerRadius: CGFloat = 16
        static let sideInset: CGFloat = 16
        static let spacing: CGFloat = 16
        static let mediumSpacing: CGFloat = 8
        static let smallSpacing: CGFloat = 4
        static let mainStackPaddings: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        static let contentHStackSpacing: CGFloat = 16
        static let grayTextColor: UIColor = .black.withAlphaComponent(0.5)
        static let chipsHeight: CGFloat = 18
        static let iconUrlSize: CGSize = .init(width: 32, height: 32)
        static let bottomIconUrlSize: CGSize = .init(width: 24, height: 24)
        static let minimumLineSpacing: CGFloat = 8
        static let minimumInteritemSpacing: CGFloat = 8
        static let widthAnchor: CGFloat = 44
    }
}
