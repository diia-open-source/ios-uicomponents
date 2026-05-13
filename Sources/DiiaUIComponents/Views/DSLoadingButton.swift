
import Foundation
import DiiaCommonTypes

public final class DSLoadingButtonViewModel {
    public let title: Observable<String> = .init(value: "")
    public let state: Observable<LoadingStateButton.LoadingState> = .init(value: .disabled)
    public let componentId: String?
    public var callback: (() -> Void)?
    
    public init(title: String, state: LoadingStateButton.LoadingState, componentId: String? = nil) {
        self.title.value = title
        self.state.value = state
        self.componentId = componentId
    }
}

extension DSLoadingButtonViewModel: StatefullViewProtocol {
    public func setState(_ state: DSButtonState) {
        switch state {
        case .enabled, .selected, .invisible:
            self.state.value = .enabled
        case .disabled:
            self.state.value = .disabled
        case .loading:
            self.state.value = .loading
        }
    }
}

public final class DSLoadingButton: LoadingStateButton {
    public private(set) var viewModel: DSLoadingButtonViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    
    public func configure(viewModel: DSLoadingButtonViewModel) {
        self.viewModel?.title.removeObserver(observer: self)
        self.viewModel?.state.removeObserver(observer: self)
        self.viewModel = viewModel
        viewModel.title.observe(observer: self) { [weak self] title in
            self?.changeTitle(to: title)
        }
        viewModel.state.observe(observer: self) { [weak self] state in
            self?.changeTitle(to: state == .loading ? nil : self?.viewModel?.title.value)
            self?.setLoadingState(state)
        }
    }
    
    private func changeTitle(to title: String?) {
        self.titleLabel?.text = title
        self.setTitle(title, for: .normal)
    }
    
    @objc private func click() {
        viewModel?.callback?()
    }
}
