import Foundation

public struct DSTableBlockItemModel: Codable {
    public let tableMainHeadingMlc: DSTableHeadingItemModel?
    public let tableSecondaryHeadingMlc: DSTableHeadingItemModel?
    public let items: [DSTableItem]?
    
    public init(tableMainHeadingMlc: DSTableHeadingItemModel?,
                tableSecondaryHeadingMlc: DSTableHeadingItemModel?,
                items: [DSTableItem]?) {
        self.tableMainHeadingMlc = tableMainHeadingMlc
        self.tableSecondaryHeadingMlc = tableSecondaryHeadingMlc
        self.items = items
    }
}

public struct DSTableHeadingItemModel: Codable {
    public let label: String
    public let icon: DSIconModel?
    
    public init(label: String, icon: DSIconModel?) {
        self.label = label
        self.icon = icon
    }
}

public struct DSTableItem: Codable {
    public let tableItemVerticalMlc: DSTableItemVerticalMlc?
    public let tableItemHorizontalMlc: DSTableItemHorizontalMlc?
    public let tableItemPrimaryMlc: DSTableItemPrimaryMlc?
    public let docTableItemHorizontalMlc: DSTableItemHorizontalMlc?
    public let docTableItemHorizontalLongerMlc: DSTableItemHorizontalMlc?
    public let smallEmojiPanelMlc: DSSmallEmojiPanelMlcl?
    
    public init(tableItemVerticalMlc: DSTableItemVerticalMlc? = nil,
                tableItemHorizontalMlc: DSTableItemHorizontalMlc? = nil,
                tableItemPrimaryMlc: DSTableItemPrimaryMlc? = nil,
                docTableItemHorizontalMlc: DSTableItemHorizontalMlc? = nil,
                docTableItemHorizontalLongerMlc: DSTableItemHorizontalMlc? = nil,
                smallEmojiPanelMlc: DSSmallEmojiPanelMlcl? = nil
    ) {
        self.tableItemVerticalMlc = tableItemVerticalMlc
        self.tableItemHorizontalMlc = tableItemHorizontalMlc
        self.tableItemPrimaryMlc = tableItemPrimaryMlc
        self.docTableItemHorizontalMlc = docTableItemHorizontalMlc
        self.docTableItemHorizontalLongerMlc = docTableItemHorizontalLongerMlc
        self.smallEmojiPanelMlc = smallEmojiPanelMlc
    }
}

public struct DSSmallEmojiPanelMlcl: Codable {
    public let label: String
    public let icon: DSIconModel?
    
    public init(label: String,
                icon: DSIconModel?) {
        self.label = label
        self.icon = icon
    }
}

public struct DSTableItemPrimaryMlc: Codable {
    public let label: String?
    public let value: String
    public let icon: DSIconModel?
    
    public init(label: String?,
                value: String,
                icon: DSIconModel?) {
        self.label = label
        self.value = value
        self.icon = icon
    }
}

public struct DSTableItemHorizontalMlc: Codable {
    public var supportingValue: String?
    public let label: String
    public var secondaryLabel: String?
    public let value: String?
    public var secondaryValue: String?
    public var icon: DSIconModel?
    public let valueImage: DSDocumentContentData?
    
    public init(supportingValue: String? = nil,
                label: String,
                secondaryLabel: String? = nil,
                value: String?,
                secondaryValue: String? = nil,
                icon: DSIconModel? = nil,
                valueImage: DSDocumentContentData? = nil) {
        self.supportingValue = supportingValue
        self.label = label
        self.secondaryLabel = secondaryLabel
        self.value = value
        self.secondaryValue = secondaryValue
        self.icon = icon
        self.valueImage = valueImage
    }
}

public struct DSTableItemVerticalMlc: Codable {
    public var supportingValue: String?
    public let label: String?
    public var secondaryLabel: String?
    public let value: String?
    public var secondaryValue: String?
    public var icon: DSIconModel?
    public let valueImage: DSDocumentContentData?
    public let valueImages: [String]?
    public let valueIcons: [DSValueIcon]?
    
    public init(supportingValue: String? = nil,
                label: String? = nil,
                secondaryLabel: String? = nil,
                value: String? = nil,
                secondaryValue: String? = nil,
                icon: DSIconModel? = nil,
                valueImage: DSDocumentContentData? = nil,
                valueImages: [String]? = nil,
                valueIcons: [DSValueIcon]? = nil) {
        self.supportingValue = supportingValue
        self.label = label
        self.secondaryLabel = secondaryLabel
        self.value = value
        self.secondaryValue = secondaryValue
        self.icon = icon
        self.valueImage = valueImage
        self.valueImages = valueImages
        self.valueIcons = valueIcons
    }
}

public struct DSValueIcon: Codable {
    public let code: String
    public let description: String
    
    public init(code: String,
                description: String) {
        self.code = code
        self.description = description
    }
}

public struct DSTableBlockTwoColumnPlaneOrg: Codable {
    public let photo: DSDocumentContentData?
    public let items: [DSItemsModel]?
    public let headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel?
    
    public init(photo: DSDocumentContentData?,
                items: [DSItemsModel]?,
                headingWithSubtitlesMlc: DSHeadingWithSubtitlesModel?) {
        self.photo = photo
        self.items = items
        self.headingWithSubtitlesMlc = headingWithSubtitlesMlc
    }
}

public enum DSDocumentContentData: String, Codable {
    case photo, signature
}

public struct DSItemsModel: Codable {
    public let tableItemVerticalMlc: DSTableItemVerticalMlc
    
    public init(tableItemVerticalMlc: DSTableItemVerticalMlc) {
        self.tableItemVerticalMlc = tableItemVerticalMlc
    }
}

public struct DSPhotoItemModel: Codable {
    public let photo: DSDocumentContentData
    
    public init(photo: DSDocumentContentData) {
        self.photo = photo
    }
}

public struct DSHeadingWithSubtitlesModel: Codable {
    public let value: String
    public let subtitles: [String]?
    
    public init(value: String, subtitles: [String]?) {
        self.value = value
        self.subtitles = subtitles
    }
}
