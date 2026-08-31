
import UIKit
import DiiaCommonTypes

public final class DropdownListViewModel {
    // MARK: - Properties
    public let componentId: String
    public let inputCode: String?
    public let items: [String]
    public let selectedItem: Observable<String>
    public let isOpen = Observable(value: false)
    
    public var eventHandler: ((ConstructorItemEvent) -> Void)?

    // MARK: - Init
    public init(componentId: String, inputCode: String?, items: [String], initialSelection: String? = nil) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.items = items
        self.selectedItem = Observable(value: initialSelection ?? items.first ?? "")
    }
    
    // MARK: - Public Methods
    public func toggleState() {
        isOpen.value.toggle()
    }
    
    public func selectItem(at index: Int) {
        guard index < items.count else { return }
        let newItem = items[index]
        selectedItem.value = newItem
        isOpen.value = false
    }
}

/// dropdownListMlc
public struct DropdownListMlc: Codable {
    public let componentId: String
    public let inputCode: String?
    public let value: String?
    public let items: [String]?
    
    public init(componentId: String, inputCode: String?, value: String? = nil, items: [String]? = []) {
        self.componentId = componentId
        self.inputCode = inputCode
        self.value = value
        self.items = items
    }
}

///dropdownListMlc
public final class DropdownListView: BaseCodeView, DSInputComponentProtocol {
    // MARK: - UI Components
    private let selectedItemLabel = UILabel().withParameters(font: FontBook.bigText, textColor: .black)
    private let arrowImageView = UIImageView().withSize(Constants.imageSize)
    private var overlayView: DropdownOverlayView?
    private let headerView = UIView()
    
    private lazy var optionsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.layer.borderWidth = Constants.borderWeight
        tableView.layer.borderColor = Constants.borderColorOpen.cgColor
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Constants.dividerColor
        tableView.separatorInset = .init(horizontal: Constants.padding)
        tableView.rowHeight = Constants.itemHeight
        tableView.isScrollEnabled = false
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentify)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Properties
    private var viewModel: DropdownListViewModel?
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Override Methods
    
    public override func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        headerView.addSubview(selectedItemLabel)
        headerView.addSubview(arrowImageView)
        
        headerView.backgroundColor = .white
        headerView.layer.cornerRadius = Constants.cornerRadius
        headerView.layer.borderWidth = Constants.borderWeight
        headerView.layer.borderColor = Constants.borderColorClose.cgColor
        
        addSubview(headerView)
        
        widthAnchor.constraint(equalToConstant: Constants.itemWidth).isActive = true
        
        setupConstraints()
        setupGesture()
        setupAccessibility()
    }
    
    // MARK: - Setup & Constraints
    
    private func setupConstraints() {
        tableViewHeightConstraint = optionsTableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
        
        headerView.withWidth(Constants.itemWidth)
        headerView.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          bottom: bottomAnchor,
                          trailing: arrowImageView.trailingAnchor,
                          padding: .init(right: -Constants.padding))
        
        headerView.withHeight(Constants.itemHeight)
        
        selectedItemLabel.anchor(leading: headerView.leadingAnchor,
                                 padding: .init(left: Constants.padding))
        
        NSLayoutConstraint.activate([
            selectedItemLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
        ])
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        headerView.addGestureRecognizer(tapGesture)
    }
    
    private func setupAccessibility() {
        headerView.isAccessibilityElement = true
        headerView.accessibilityTraits = .button
    }
    
    @objc private func headerTapped() {
        viewModel?.toggleState()
    }
    
    // MARK: - Public Configure
    
    public func configure(viewModel: DropdownListViewModel) {
        self.viewModel = viewModel
        
        optionsTableView.reloadData()
        setupObservers()
    }
    
    // MARK: - Observers
    
    private func setupObservers() {
        guard let viewModel else { return }
        viewModel.selectedItem.observe(observer: self) { [weak self] selectedText in
            guard let self else { return }
            self.selectedItemLabel.text = selectedText
            self.headerView.accessibilityLabel = selectedText
            self.headerView.accessibilityTraits.insert(.selected)
        }
        
        viewModel.isOpen.observe(observer: self) { [weak self] isOpen in
            guard let self else { return }
            
            if isOpen {
                self.arrowImageView.image = R.image.arrowUp.image
                self.headerView.layer.borderColor = Constants.borderColorOpen.cgColor
                self.showOverlay()
            } else {
                self.arrowImageView.image = R.image.arrowDown.image
                self.headerView.layer.borderColor = Constants.borderColorClose.cgColor
                self.hideOverlay()
            }
            
            let visibleItemsCount = min(viewModel.items.count, Constants.maxVisibleItems)
            let targetHeight: CGFloat = isOpen ? (CGFloat(visibleItemsCount) * Constants.itemHeight) : 0
            
            self.optionsTableView.isScrollEnabled = viewModel.items.count > Constants.maxVisibleItems
            self.tableViewHeightConstraint?.constant = targetHeight
        }
    }
    
    // MARK: - Overlay Window Logic
        
    private func showOverlay() {
        guard let window, let viewModel else { return }
        
        let overlay = DropdownOverlayView()
        overlay.backgroundColor = .clear
        overlay.allowedView = optionsTableView
        
        overlay.onOutsideTap = { [weak self] in
            self?.dismissDropdown()
        }
        
        window.addSubview(overlay)
        overlay.addSubview(optionsTableView)
        
        let headerFrameInWindow = headerView.convert(headerView.bounds, to: window)
        let visibleItemsCount = min(viewModel.items.count, Constants.maxVisibleItems)
        let tableHeight = CGFloat(visibleItemsCount) * Constants.itemHeight
        
        overlay.fillSuperview()
        optionsTableView.withWidth(headerFrameInWindow.width)
        
        optionsTableView.anchor(
            top: overlay.topAnchor,
            leading: overlay.leadingAnchor,
            padding: .init(
                horizontal: headerFrameInWindow.minX,
                vertical: headerFrameInWindow.maxY + Constants.stackSpacing))
        
        self.overlayView = overlay
        self.optionsTableView.isScrollEnabled = viewModel.items.count > Constants.maxVisibleItems
        self.tableViewHeightConstraint?.constant = tableHeight
        UIAccessibility.post(notification: .layoutChanged, argument: optionsTableView)
    }
    
    private func hideOverlay() {
        guard let overlayView else { return }
        self.optionsTableView.removeFromSuperview()
        overlayView.removeFromSuperview()
        self.overlayView = nil
    }

    private func dismissDropdown() {
        viewModel?.isOpen.value = false
    }
    
    //MARK: - DSInputComponentProtocol
    public func isValid() -> Bool {
        return true
    }
    
    public func inputCode() -> String {
        return viewModel?.inputCode ?? "dropdownListMlc"
    }
    
    public func inputData() -> AnyCodable? {
        return .string(viewModel?.selectedItem.value ?? "")
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension DropdownListView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentify, for: indexPath)
        cell.textLabel?.text = viewModel?.items[indexPath.row]
        cell.textLabel?.font = FontBook.bigText
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectItem(at: indexPath.row)
        UIAccessibility.post(notification: .layoutChanged, argument: headerView)
    }
}

private final class DropdownOverlayView: UIView {
    weak var allowedView: UIView?
    var onOutsideTap: (() -> Void)?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let allowedView else { return super.hitTest(point, with: event) }
        let allowedFrameInOverlay = allowedView.convert(allowedView.bounds, to: self)
        if allowedFrameInOverlay.contains(point) {
            return super.hitTest(point, with: event)
        }
        return self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        onOutsideTap?()
    }
}

// MARK: - Design Constants

extension DropdownListView {
    private enum Constants {
        static let itemHeight: CGFloat = 48
        static let itemWidth: CGFloat = 66
        static let cornerRadius: CGFloat = 12
        static let imageSize = CGSize(width: 12, height: 12)
        static let borderWeight: CGFloat = 1
        static let padding: CGFloat = 16
        static let stackSpacing: CGFloat = 8
        static let maxVisibleItems = 5
        
        static let cellIdentify = "dropdownCell"
        
        static let borderColorOpen = UIColor.black
        static let borderColorClose = UIColor(hex: 0xE2ECF4)
        static let dividerColor = UIColor(hex: 0xE2ECF4)
    }
}
