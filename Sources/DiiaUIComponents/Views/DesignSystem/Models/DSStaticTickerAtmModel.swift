
import Foundation
import DiiaCommonTypes

public struct DSStaticTickerAtmModel: Codable {
    public let componentId: String?
    public let type: DSTickerType
    public let label: String?
    public let expireLabel: DSExpireLabelBox?
    public let action: DSActionParameter?

    public init(type: DSTickerType, componentId: String? = nil, label: String? = nil, expireLabel: DSExpireLabelBox? = nil, action: DSActionParameter? = nil) {
        self.componentId = componentId
        self.type = type
        self.label = label
        self.expireLabel = expireLabel
        self.action = action
    }
}

public class DSStaticTickerViewModel {
    public let componentId: String?
    public var type: Observable<DSTickerType>
    public var label: Observable<String>
    public let action: DSActionParameter?
    public let expireLabel: DSExpireLabelBox?

    public let timerText: Observable<String?> = .init(value: .empty)

    private var timer: Timer?
    private var runTimer: Int = 0
    private var timerLength: TimeInterval = 0

    public var onTimerExpiration: (() -> Void)?

    public func setupTimer(for timerTime: Int) {
        if timerTime < 0 {
            timerText.value = "00:00"
        } else {
            self.timerLength = TimeInterval(timerTime)
            self.startTimer()
        }
    }

    public func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }

    public init(componentId: String?, type: DSTickerType, label: String?, expireLabel: DSExpireLabelBox?, action: DSActionParameter?) {
        self.componentId = componentId
        self.type = .init(value: type)
        self.label = .init(value: label ?? "")
        self.expireLabel = expireLabel
        self.action = action
    }

    public init(model: DSStaticTickerAtmModel) {
        self.componentId = model.componentId
        self.type = .init(value: model.type)
        self.label = .init(value: model.label ?? "")
        self.expireLabel = model.expireLabel
        self.action = model.action
    }

    // MARK: - Private
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

    @objc private func updateTimer() {
        runTimer -= 1
        let minutes = (runTimer / Constants.timeInFrame) % Constants.timeInFrame
        let seconds = runTimer % Constants.timeInFrame

        timerText.value = String(format: Constants.timerFormat, minutes, seconds)

        if runTimer <= .zero {
            cancelTimer()
            onTimerExpiration?()
        }
    }
}

extension DSStaticTickerViewModel {
    private enum Constants {
        static let timeInFrame = 60
        static let timerFormat = "%i:%02i"
    }
}
