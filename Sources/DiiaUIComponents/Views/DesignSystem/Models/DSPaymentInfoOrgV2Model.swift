
import DiiaCommonTypes

public struct DSPaymentInfoOrgV2Model: Codable {
    public struct TitleWithChipModel: Codable {
        public let text: String
        public let description: String?
        public let chipStatusAtm: DSCardStatusChipModel?
    }

    public let componentId: String
    public let title: String?
    public let titleWithChip: TitleWithChipModel?
    public let subtitle: String?
    public let items: [AnyCodable]
    public let tableItemHorizontalLargeMlc: DSTableItemHorizontalMlc?
    public let btnPrimaryAdditionalAtm: DSButtonModel?
    public let btnIconPlainStrokeMlc: DSBtnIconPlainStrokeMlcModel?
    public let description: String?

    public init(
        componentId: String,
        title: String?,
        titleWithChip: TitleWithChipModel?,
        subtitle: String?,
        items: [AnyCodable],
        tableItemHorizontalLargeMlc: DSTableItemHorizontalMlc?,
        btnPrimaryAdditionalAtm: DSButtonModel?,
        btnIconPlainStrokeMlc: DSBtnIconPlainStrokeMlcModel?,
        description: String?) {
            self.componentId = componentId
            self.title = title
            self.titleWithChip = titleWithChip
            self.subtitle = subtitle
            self.items = items
            self.tableItemHorizontalLargeMlc = tableItemHorizontalLargeMlc
            self.btnPrimaryAdditionalAtm = btnPrimaryAdditionalAtm
            self.btnIconPlainStrokeMlc = btnIconPlainStrokeMlc
            self.description = description
        }
}
