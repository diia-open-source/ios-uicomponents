
import Foundation
import DiiaCommonTypes

public class DSTimerTextViewModel {
    private let model: DSTimerTextModel
    public var onClick: Callback?
    
    private var timer: Timer?
    private var runTimer: Int = 0
    private var timerLength: TimeInterval = Constants.defaultTimerTime
    
    public var timerText: Observable<String?> = .init(value: .empty)
    public var isExpired: Observable<Bool> = .init(value: false)
    
    // MARK: - Init
    public init(model: DSTimerTextModel, onClick: Callback? = nil) {
        self.model = model
        self.onClick = onClick
    }
    
    // MARK: - Public Properties
    public var expireLabel: DSExpireLabelBox? {
        return model.expireLabel
    }
    
    public var buttonLink: DSButtonModel {
        return model.stateAfterExpiration.btnLinkAtm
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
        
        isExpired.value = (runTimer == .zero)
        if runTimer == .zero {
            timerText.value = nil
            cancelTimer()
        }
    }
    
    public func getTimerLength() -> Int {
        return model.expireLabel?.timer ?? Int(Constants.defaultTimerTime)
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
}

extension DSTimerTextViewModel {
    private enum Constants {
        static let defaultTimerTime: Double = 180
        static let timeInFrame = 60
        static let timerFormat = "%i:%02i"
    }
}
