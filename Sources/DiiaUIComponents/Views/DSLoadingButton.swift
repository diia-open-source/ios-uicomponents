
import Foundation

public class DSLoadingButtonViewModel {
    public let title: Observable<String> = .init(value: "")
    public let state: Observable<LoadingStateButton.LoadingState> = .init(value: .disabled)
    public var callback: (() -> Void)?
    
    public init(title: String, state: LoadingStateButton.LoadingState) {
        self.title.value = title
        self.state.value = state
    }
}

public class DSLoadingButton: LoadingStateButton {
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
            self?.titleLabel?.text = title
            self?.setTitle(title, for: .highlighted)
            self?.setTitle(title, for: .normal)
        }
        viewModel.state.observe(observer: self) { [weak self] state in
            self?.setLoadingState(state)
        }
    }
    
    @objc private func click() {
        viewModel?.callback?()
    }
}
