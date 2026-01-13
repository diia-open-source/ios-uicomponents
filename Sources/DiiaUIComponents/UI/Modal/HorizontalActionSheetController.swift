
import UIKit
import DiiaMVPModule
import DiiaCommonTypes

public final class HorizontalActionSheetModule: BaseModule {
    private let view: HorizontalActionSheetController
    
    public init(title: String,
                actions: [Action],
                separatorColorStr: String = AppConstants.Colors.separatorColor) {
        view = HorizontalActionSheetController(
            title: title,
            actions: actions,
            separatorColorStr: separatorColorStr)
    }

    public func viewController() -> UIViewController {
        let vc = ChildContainerViewController()
        vc.childSubview = view
        vc.presentationStyle = .actionSheet
        return vc
    }
}

final class HorizontalActionSheetController: UIViewController, BaseView, ChildSubcontroller {
    
    weak var container: ContainerProtocol?    
    
    private let closingView = UIView()
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private var actionCollectionView: UICollectionView!
    private let separatorView = UIView()
    private let closeButton = ActionButton()
    private var cellWidth: CGFloat = 0

    var actionSheetTitle: String {
        didSet {
            titleLabel.setTextWithCurrentAttributes(text: actionSheetTitle)
        }
    }
    var actions: [Action] {
        didSet {
            updateCollectionInsets()
            actionCollectionView.reloadData()
        }
    }
    var separatorColorStr: String {
        didSet {
            closeButton.imageView?.tintColor = UIColor(separatorColorStr)
            separatorView.backgroundColor = UIColor(separatorColorStr)
        }
    }
    
    init(title: String, actions: [Action], separatorColorStr: String = AppConstants.Colors.separatorColor) {
        self.actionSheetTitle = title
        self.actions = actions
        self.separatorColorStr = separatorColorStr
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.actionSheetTitle = ""
        self.actions = []
        self.separatorColorStr = AppConstants.Colors.separatorColor
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Configuration
    private func setupViews() {
        view.backgroundColor = .clear
        
        setupClosingView()
        setupContainerView()
        setupTitle()
        setupCollectionView()
        setupSeparator()
        setupCloseButton()
    }
    
    fileprivate func setupSeparator() {
        containerView.addSubview(separatorView)
        separatorView.backgroundColor = UIColor(separatorColorStr)
        separatorView.anchor(top: actionCollectionView.bottomAnchor,
                             leading: containerView.leadingAnchor,
                             bottom: nil,
                             trailing: containerView.trailingAnchor,
                             padding: .init(top: Constants.innerSpacing,
                                            left: Constants.innerSpacing,
                                            bottom: 0,
                                            right: Constants.innerSpacing),
                             size: .init(width: 0,
                                         height: Constants.separatorHeight))
    }
    
    private func setupCollectionView() {
        cellWidth = (
                UIScreen.main.bounds.width
                - Constants.spacing*2
                - Constants.innerSpacing*2
                - Constants.interitemSpacing
                    * (Constants.cellsCount)
                )
                / Constants.cellsCount
        let cellHeight = cellWidth + Constants.collectionCellTextHeight
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        actionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        containerView.addSubview(actionCollectionView)
        actionCollectionView.anchor(
            top: titleLabel.bottomAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(
                top: Constants.innerSpacing,
                left: 0,
                bottom: 0,
                right: 0),
            size: .init(width: 0, height: cellHeight))
        updateCollectionInsets()
        actionCollectionView.register(ActionCollectionCell.nib, forCellWithReuseIdentifier: ActionCollectionCell.reuseID)
        actionCollectionView.backgroundColor = .clear
        actionCollectionView.dataSource = self
        actionCollectionView.delegate = self
    }
    
    func updateCollectionInsets() {
        let cellsSize: CGFloat = (cellWidth + Constants.interitemSpacing) * CGFloat(actions.count) - Constants.interitemSpacing
        let inset: CGFloat = max(Constants.innerSpacing,
                                 (UIScreen.main.bounds.width
                                 - Constants.spacing*2 - cellsSize) / 2)
        actionCollectionView.contentInset = .init(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    fileprivate func setupClosingView() {
        view.addSubview(closingView)
        closingView.fillSuperview()
        closingView.backgroundColor = .clear
        closingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
    }
    
    fileprivate func setupContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = Constants.cornerRadius
        view.addSubview(containerView)
        containerView.anchor(
            top: nil,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor,
            padding: .init(
                top: 0,
                left: Constants.spacing,
                bottom: Constants.spacing,
                right: Constants.spacing))
    }
    
    fileprivate func setupTitle() {
        containerView.addSubview(titleLabel)
        titleLabel.anchor(
            top: containerView.topAnchor,
            leading: containerView.leadingAnchor,
            bottom: nil,
            trailing: containerView.trailingAnchor,
            padding: .init(
                top: Constants.innerSpacing,
                left: Constants.innerSpacing,
                bottom: 0,
                right: Constants.innerSpacing))
        titleLabel.font = FontBook.smallHeadingFont
        titleLabel.textAlignment = .center
        titleLabel.text = actionSheetTitle
    }
    
    fileprivate func setupCloseButton() {
        closeButton.action = Action(
            title: nil,
            iconName: R.image.clear.name,
            callback: { [weak self] in
                self?.close()
        })
        closeButton.contentHorizontalAlignment = .center
        closeButton.contentVerticalAlignment = .center
        closeButton.iconRenderingMode = .alwaysTemplate
        closeButton.tintColor = UIColor(separatorColorStr)
        containerView.addSubview(closeButton)
        closeButton.anchor(top: separatorView.bottomAnchor,
                           leading: containerView.leadingAnchor,
                           bottom: containerView.bottomAnchor,
                           trailing: containerView.trailingAnchor,
                           padding: .init(top: 0,
                                          left: 0,
                                          bottom: 0,
                                          right: 0),
                           size: .init(width: 0,
                                       height: Constants.buttonHeight))
    }
    
    // MARK: - Actions
    @objc func close() {
        container?.close()
    }
}

extension HorizontalActionSheetController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionCollectionCell.reuseID, for: indexPath) as? ActionCollectionCell else { return UICollectionViewCell() }
        
        let action = actions[indexPath.item]
        cell.configure(with: action.title, image: action.image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.item]
        action.callback()
        close()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.interitemSpacing
    }
}

extension HorizontalActionSheetController {
    enum Constants {
        static let spacing: CGFloat = 16
        static let innerSpacing: CGFloat = 24
        static let interitemSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let buttonHeight: CGFloat = 64
        static let collectionCellTextHeight: CGFloat = 35
        static let separatorHeight: CGFloat = 2
        static let cellsCount: CGFloat = 4
    }
}
