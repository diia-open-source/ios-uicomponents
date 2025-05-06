
import Foundation

public class DSPrimaryDefaultButton: LoadingStateButton, DSConditionComponentProtocol {
    private var viewModel: DSLoadingButtonViewModel?
    
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
    
    public func updateConditions(inputFields: [DSInputComponentProtocol]) {
        let isValid = inputFields.allSatisfy({ $0.isValid() })
        self.viewModel?.state.value = isValid ? .enabled : .disabled
    }
}
