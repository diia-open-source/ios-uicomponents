
import Foundation
import DiiaCommonTypes

public struct DSCardListModel: Codable {
    public let cardMlcl: [DSCardModel]
    
    public init(cardMlcl: [DSCardModel]) {
        self.cardMlcl = cardMlcl
    }
}

public struct DSCardModel: Codable {
    public let componentId: String?
    public let id: String
    public let title: String
    public let chipStatusAtm: DSCardStatusChipModel?
    public let label: String?
    public let subtitle: DSCardSubtitleModel?
    public let subtitles: [DSCardSubtitleModel]?
    public let description: String?
    public let botLabel: String?
    public let tickerAtm: DSTickerAtom?
    public let btnStrokeAdditionalAtm: DSButtonModel?
    public let btnPrimaryAdditionalAtm: DSButtonModel?
    
    public init(
        componentId: String?,
        id: String,
        title: String,
        chipStatusAtm: DSCardStatusChipModel?,
        label: String?,
        subtitle: DSCardSubtitleModel?,
        subtitles: [DSCardSubtitleModel]?,
        description: String?,
        botLabel: String?,
        tickerAtm: DSTickerAtom?,
        btnStrokeAdditionalAtm: DSButtonModel?,
        btnPrimaryAdditionalAtm: DSButtonModel?
    ) {
        self.componentId = componentId
        self.id = id
        self.title = title
        self.chipStatusAtm = chipStatusAtm
        self.label = label
        self.subtitle = subtitle
        self.subtitles = subtitles
        self.description = description
        self.botLabel = botLabel
        self.tickerAtm = tickerAtm
        self.btnStrokeAdditionalAtm = btnStrokeAdditionalAtm
        self.btnPrimaryAdditionalAtm = btnPrimaryAdditionalAtm
    }
}

public struct DSCardSubtitleModel: Codable {
    public let icon: String?
    public let value: String
    
    public init(icon: String?, value: String) {
        self.icon = icon
        self.value = value
    }
}
