
import Foundation

public struct DSDocumentHeading: Codable, Equatable {
    public let headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel?
    public let headingWithSubtitleWhiteMlc: DSHeadingWithSubtitlesModel?
    public let docNumberCopyMlc: DSTableItemPrimaryMlc?
    public let docNumberCopyWhiteMlc: DSTableItemPrimaryMlc?
    public let stackMlc: DSStackMlc?
    public let iconAtm: DSIconModel?

    public init(headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel? = nil,
                headingWithSubtitleWhiteMlc: DSHeadingWithSubtitlesModel? = nil,
                docNumberCopyMlc: DSTableItemPrimaryMlc? = nil,
                docNumberCopyWhiteMlc: DSTableItemPrimaryMlc? = nil,
                iconAtm: DSIconModel? = nil,
                stackMlc: DSStackMlc? = nil) {
        self.headingWithSubtitlesMlc = headingWithSubtitlesMlc
        self.headingWithSubtitleWhiteMlc = headingWithSubtitleWhiteMlc
        self.docNumberCopyMlc = docNumberCopyMlc
        self.docNumberCopyWhiteMlc = docNumberCopyWhiteMlc
        self.iconAtm = iconAtm
        self.stackMlc = stackMlc
    }
}

public struct DSStackMlc: Codable, Equatable {
    public let smallIconAtm: DSIconModel
    public let amount: Int

    public init(smallIconAtm: DSIconModel,
                amount: Int) {
        self.smallIconAtm = smallIconAtm
        self.amount = amount
    }
}
