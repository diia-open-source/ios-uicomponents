
import Foundation

public class DSSharingCodesOrgViewModel: NSObject {
    
    public let sharingCodes: DSSharingCodesOrg
    public let stubViewModel: StubMessageViewModel
    public let itemsVMs: [IconedLoadingStateViewModel]?
    
    private var timer: Timer?
    private var runTimer: Int = 0
    private var timerLength: TimeInterval = Constants.defaultTimerTime
    
    @objc public dynamic var isLoading = false
    @objc public dynamic var timerText: String? = ""
    @objc public dynamic var isExpired: Bool = false
    
    public init(sharingCodes: DSSharingCodesOrg,
                stubViewModel: StubMessageViewModel,
                itemsVMs: [IconedLoadingStateViewModel]?) {
        self.sharingCodes = sharingCodes
        self.stubViewModel = stubViewModel
        self.itemsVMs = itemsVMs
    }
    
    public func setupTimer(for timerTime: Int) {
        self.timerLength = TimeInterval(timerTime)
        self.startTimer()
    }
    
    @objc func updateTimer() {
        runTimer -= 1
        let minutes = (runTimer / Constants.timeInFrame) % Constants.timeInFrame
        let seconds = runTimer % Constants.timeInFrame
        
        timerText = String(format: Constants.timerFormat, minutes, seconds)
        
        if runTimer == .zero {
            isExpired = true
            timerText = nil
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        cancelTimer()
        runTimer = Int(timerLength)
        let timer = Timer.scheduledTimer(timeInterval: 1.0,
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
        isExpired = true
    }
    
    public func cancel() {
        cancelTimer()
    }
}

extension DSSharingCodesOrgViewModel {
    enum Constants {
        static let defaultTimerTime: Double = 180
        static let timeInFrame = 60
        static let timerFormat = "%i:%02i"
    }
}
