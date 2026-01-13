
import Foundation

/// design_system_code: qrCodeOrg
public struct DSQrCodeOrgModel: Codable {
    public let componentId: String
    public let text: String?
    public let qrCodeMlc: QRCodeMlc?
    public let expireLabel: DSExpireLabelBox?
    public let expireLabelWithoutTimer: String?
    public let stateAfterExpiration: DSQrCodeOrgModelExpirationModel?
    public let paginationMessageMlc: DSPaginationMessageMlcModel?
    public let btnPlainIconAtm: DSBtnPlainIconModel?

    public init(
        componentId: String,
        text: String? = nil,
        qrCodeMlc: QRCodeMlc? = nil,
        expireLabel: DSExpireLabelBox? = nil,
        expireLabelWithoutTimer: String? = nil,
        stateAfterExpiration: DSQrCodeOrgModelExpirationModel? = nil,
        paginationMessageMlc: DSPaginationMessageMlcModel? = nil,
        btnPlainIconAtm: DSBtnPlainIconModel? = nil
    ) {
        self.componentId = componentId
        self.text = text
        self.qrCodeMlc = qrCodeMlc
        self.expireLabel = expireLabel
        self.expireLabelWithoutTimer = expireLabelWithoutTimer
        self.stateAfterExpiration = stateAfterExpiration
        self.paginationMessageMlc = paginationMessageMlc
        self.btnPlainIconAtm = btnPlainIconAtm
    }
}

public struct DSQrCodeOrgModelExpirationModel: Codable {
    public let paginationMessageMlc: DSPaginationMessageMlcModel

    public init(paginationMessageMlc: DSPaginationMessageMlcModel) {
        self.paginationMessageMlc = paginationMessageMlc
    }
}

public final class DSQrCodeOrgViewModel {
    public enum State {
        case code(DSQrCodeOrgModel)
        case loading
        case error(DSPaginationMessageMlcModel)
    }

    public let state: Observable<State>

    private var timer: Timer?
    private var runTimer: Int = 0
    private var timerLength: TimeInterval = Constants.defaultTimerTime

    public let timerText: Observable<String?> = .init(value: .empty)
    public let isExpired: Observable<Bool> = .init(value: false)

    // MARK: - Init
    public init(model: DSQrCodeOrgModel?) {
        if let model {
            self.state = .init(value: .code(model))
        } else {
            self.state = .init(value: .loading)
        }
    }

    // MARK: - Timer
    public func setupTimer(for timerTime: Int) {
        self.timerLength = TimeInterval(timerTime)
        self.startTimer()
    }

    public func cancelTimer() {
        timer?.invalidate()
        timer = nil
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

        isExpired.value = (runTimer == .zero)
        if runTimer == .zero {
            timerText.value = nil
            cancelTimer()
        }
    }
}

extension DSQrCodeOrgViewModel {
    private enum Constants {
        static let defaultTimerTime: Double = 180
        static let timeInFrame = 60
        static let timerFormat = "%i:%02i"
    }
}
