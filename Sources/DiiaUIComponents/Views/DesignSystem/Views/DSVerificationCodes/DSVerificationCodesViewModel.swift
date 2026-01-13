
import UIKit
import DiiaCommonTypes

public final class DSVerificationCodesViewModel: NSObject {
    public var componentId: String?
    public var model: Observable<DSVerificationCodesData?> = .init(value: nil)
    public var sharingCode: Observable<String?> = .init(value: nil)
    public var repeatAction: Callback?
    
    private var timer: Timer?
    private var runTimer: Int = 0
    private var timerLength: TimeInterval = Constants.defaultTimerTime
    
    public var timerText: Observable<String?> = .init(value: .empty)
    public var isExpired: Observable<Bool> = .init(value: false)
    
    public init(
        componentId: String? = nil,
        model: DSVerificationCodesData? = nil,
        repeatAction: Callback? = nil
    ) {
        self.componentId = componentId
        self.model.value = model
        self.repeatAction = repeatAction
    }
    
    // MARK: - View models
    public var buttonsToggleGroup: DSButtonToggleGroupViewModel? {
        guard let toggleButtonGroup = model.value?.toggleButtonGroupOrg else { return nil }
        return DSButtonToggleGroupViewModel(model: toggleButtonGroup) { [weak self] code in
            self?.sharingCode.value = code
        }
    }
    
    public var stubMessage: StubMessageViewModel? {
        guard let stubMessageModel = model.value?.stubMessageMlc else { return nil }
        return StubMessageViewModel(
            icon: stubMessageModel.icon ?? .empty,
            title: stubMessageModel.title,
            btnTitle: model.value?.stubMessageMlc?.btnStrokeAdditionalAtm?.label,
            descriptionText: stubMessageModel.description,
            componentId: stubMessageModel.componentId)
    }
    
    public var isStatic: Bool {
        return (model.value?.toggleButtonGroupOrg == nil) && (model.value?.expireLabel == nil) && (model.value?.qrCodeMlc != nil || model.value?.barCodeMlc != nil)
    }
    
    public var staticViewModel: DSStaticVerificationViewModel? {
        guard model.value?.qrCodeMlc != nil || model.value?.barCodeMlc != nil else { return nil }
        return DSStaticVerificationViewModel(qrCode: model.value?.qrCodeMlc, barCode: model.value?.barCodeMlc)
    }
    
    // MARK: - Public Methods
    public func update(
        componentId: String?,
        model: DSVerificationCodesData?,
        repeatAction: Callback?
    ) {
        self.componentId = componentId
        self.model.value = model
        self.repeatAction = repeatAction
    }
    
    // MARK: - Timer
    public func setupTimer(for timerTime: Int) {
        self.timerLength = TimeInterval(timerTime)
        self.startTimer()
    }
    
    @objc func updateTimer() {
        runTimer -= 1
        let minutes = (runTimer / Constants.timeInFrame) % Constants.timeInFrame
        let seconds = runTimer % Constants.timeInFrame
        
        timerText.value = String(format: Constants.timerFormat, minutes, seconds)
        
        if runTimer == .zero {
            isExpired.value = true
            timerText.value = nil
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        cancelTimer()
        runTimer = Int(timerLength)
        let timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil, repeats: true)
        self.timer = timer
        timer.fire()
        RunLoop.main.add(timer, forMode: .common)
    }
    
    public func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    public func cancel() {
        cancelTimer()
    }
}

extension DSVerificationCodesViewModel {
    private enum Constants {
        static let defaultTimerTime: Double = 180
        static let timeInFrame = 60
        static let timerFormat = "%i:%02i"
    }
}
