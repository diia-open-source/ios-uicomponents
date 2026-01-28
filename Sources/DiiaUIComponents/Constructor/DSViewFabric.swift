
import UIKit
import DiiaCommonTypes

public struct DSConstructorModel: Codable {
    public let topGroup: [AnyCodable]
    public let body: [AnyCodable]?
    public let centeredBody: [AnyCodable]?
    public let bottomGroup: [AnyCodable]?
    public let ratingForm: PublicServiceRatingForm?
    public let template: AlertTemplate?
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.topGroup = (try? container.decodeIfPresent([AnyCodable].self, forKey: .topGroup)) ?? []
        self.body = try? container.decodeIfPresent([AnyCodable].self, forKey: .body)
        self.centeredBody = try? container.decodeIfPresent([AnyCodable].self, forKey: .centeredBody)
        self.bottomGroup = try? container.decodeIfPresent([AnyCodable].self, forKey: .bottomGroup)
        self.ratingForm = try? container.decodeIfPresent(PublicServiceRatingForm.self, forKey: .ratingForm)
        self.template = try? container.decodeIfPresent(AlertTemplate.self, forKey: .template)
    }
    
    public init(topGroup: [AnyCodable] = [],
                body: [AnyCodable]? = [],
                centeredBody: [AnyCodable]? = nil,
                bottomGroup: [AnyCodable]? = [],
                ratingForm: PublicServiceRatingForm? = nil,
                template: AlertTemplate? = nil) {
        self.topGroup = topGroup
        self.body = body
        self.centeredBody = centeredBody
        self.bottomGroup = bottomGroup
        self.ratingForm = ratingForm
        self.template = template
    }
}

public final class DSViewFabric {
    public static let instance = DSViewFabric()
    
    private var viewBuilders: [String: DSViewBuilderProtocol]
    
    public init(viewBuilders: [DSViewBuilderProtocol] = DSViewFabric.defaultBuilders) {
        self.viewBuilders = [:]
        viewBuilders.forEach {
            self.viewBuilders[$0.modelKey] = $0
        }
    }
    
    public func makeView(
        from object: AnyCodable,
        withPadding: DSViewPaddingType,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        guard let key = object.keys().first else {
            return nil
        }

        guard let builder = viewBuilders[key] else {
            log("Can not find builder for key: \(key)")
            return nil
        }

        guard let view = builder.makeView(from: object, withPadding: withPadding, viewFabric: self, eventHandler: eventHandler) else {
            log("Can not create view for key: \(key)")
            return nil
        }
        return view
    }
    
    public func topGroupViews(for model: DSConstructorModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> [UIView] {
        return (model.topGroup).compactMap { makeView(from: $0, withPadding: .firstComponent, eventHandler: eventHandler) }
    }
    
    public func bodyViews(for model: DSConstructorModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> [UIView] {
        return (model.body ?? []).enumerated().compactMap { (index, element) in
            let paddingType: DSViewPaddingType = (index == 0) ? .firstComponent : .default
            return makeView(from: element, withPadding: paddingType, eventHandler: eventHandler)
        }
    }
    
    public func centeredBodyViews(for model: DSConstructorModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> [UIView] {
        return (model.centeredBody ?? []).enumerated().compactMap { (index, element) in
            let paddingType: DSViewPaddingType = (index == 0) ? .firstComponent : .default
            return makeView(from: element, withPadding: paddingType, eventHandler: eventHandler)
        }
    }
    
    public func bottomGroupViews(for model: DSConstructorModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> [UIView] {
        return (model.bottomGroup ?? []).enumerated().compactMap { (index, element) in
            let paddingType: DSViewPaddingType = (index == 0) ? .firstComponent : .default
            return makeView(from: element, withPadding: paddingType, eventHandler: eventHandler)
        }
    }
    
    public func setBuilder(_ builder: DSViewBuilderProtocol) {
        viewBuilders[builder.modelKey] = builder
    }
}

extension DSConstructorModel {
    public var navigationPanelMlc: DSNavigationPanelMlc? {
        for item in topGroup {
            guard let navigationPanel = navigationPanel(in: item) else {
                continue
            }
            return navigationPanel
        }
        return nil
    }
    
    private func navigationPanel(in element: AnyCodable) -> DSNavigationPanelMlc? {
        switch element {
        case .dictionary(let dict):
            if let result: DSNavigationPanelMlc = element.parseValue(forKey: "navigationPanelMlc") {
                return result
            } else {
                return navigationPanelInArray(Array(dict.values))
            }
        case .array(let array):
            return navigationPanelInArray(array)
        default:
            break
        }
        
        return nil
    }
    
    private func navigationPanelInArray(_ array: [AnyCodable]) -> DSNavigationPanelMlc? {
        for item in array {
            guard let navigationPanel = navigationPanel(in: item) else {
                continue
            }
            
            return navigationPanel
        }
        
        return nil
    }
}

public extension DSViewFabric {
    static let defaultBuilders: [DSViewBuilderProtocol] = [
        DSTopGroupViewBuilder(),
        DSSearchInputViewBuilder(),
        DSTitleLabelBuilder(),
        DSSubtitleLabelBuilder(),
        DSSectionTitleBuilder(),
        DSAttentionMessageViewBuilder(),
        DSCardListViewBuilder(),
        DSTextLabelBuilder(),
        DSTextViewBuilder(),
        DSButtonIconGroupBuilder(),
        DSCheckboxRoundGroupBuilder(),
        DSRadioButtonGroupBuilder(),
        DSRadioBtnWithAltOrgBuilder(),
        DSCheckboxButtonOrgBuilder(),
        DSSmallNotificationCarouselBuilder(),
        DSHalvedCardCarouselBuilder(),
        DSImageViewBuilder(),
        DSListViewBuilder(),
        DSVideoContainerBuilder(),
        DSStatusMessageBuilder(),
        DSStubMessageMlcViewBuilder(),
        DSBlackCardBuilder(),
        DSWhiteCardBuilder(),
        DSImageCardBuilder(),
        DSHorizontalCarouselBuilder(),
        DSButtonIconRoundedGroupBuilder(),
        DSMediaTitleBuilder(),
        DSArticlePicCarouselBuilder(),
        DSBottomGroupBuilder(),
        DSPrimaryButtonBuilder(),
        DSPrimaryLargeButtonBuilder(),
        DSPrimaryWideButtonBuilder(),
        DSStrokeButtonBuilder(),
        BtnStrokeWideAtmBuilder(),
        DSPlainButtonBuilder(),
        DSButtonLinkBuilder(),
        DSTableBlockOrgBuilder(),
        DSDocHeadingBuilder(),
        DSHeadingWithSubtitlesBuilder(),
        DSTableItemPrimaryBuilder(),
        DSFinalScreenBlockBuilder(),
        DSAvatarViewBuilder(),
        DSChipAtomBuilder(),
        DSTickerAtmBuilder(),
        DSInputTextViewBuilder(),
        DSQRSharingOrgBuilder(),
        DSLinkQrShareViewBuilder(),
        DSQuestionFormBuilder(),
        DSFileUploadGroupBuilder(),
        DSGroupFilesAddBuilder(),
        DSDividerLineBuilder(),
        DSTableBlockAccordionViewBuilder(),
        DSTableItemVerticalMlcBuilder(),
        DSTableItemHorizontalMlcBuilder(),
        DSTableItemPrimaryMlcBuilder(),
        DSDocTableItemHorizontalMlcBuilder(),
        DSTableItemHorizontalLargeMlcBuilder(),
        DSSmallEmojiPanelMlcBuilder(),
        DSTableBlockPlaneOrgBuilder(),
        DSInputNumberLargeViewBuilder(),
        DSTimerTextViewBuilder(),
        DSPaymentInfoBuilder(),
        DSButtonIconPlainGroupBuilder(),
        DSSharingCodesBuilder(),
        DSPaginationListViewBuilder(),
        DSListWidgetItemBuilder(),
        DSMultilineInputTextBuilder(),
        TextItemVerticalMlcBuilder(),
        DSInputNumberViewBuilder(),
        DSInputNumberFractionalViewBuilder(),
        DSSelectorOrgBuilder(),
        DSInputDateMlcBuilder(),
        DSInputTimeMlcBuilder(),
        DSCalendarOrgBuilder(),
        DSInputDateTimeMlcBuilder(),
        DSDashboardCardMlcBuilder(),
        DSDashboardCardTileOrgBuilder(),
        DSAlertCardBuilder(),
        DSAttentionIconMessageBuilder(),
        DSGrayTitleAtmBulder(),
        DSListItemMlcBuilder(),
        DSPaginationListWhiteViewBuilder(),
        DSLargeTickerAtmViewBuilder(),
        DSListEditGroupViewBuilder(),
        DSInputPhoneCodeBuilder(),
        DSWhiteLargeButtonBuilder(),
        DSChipsBlackOrgBuilder(),
        DSSearchBarOrgBuilder(),
        DSSwitchModeViewBuilder(),
        DSCheckboxBtnWhiteOrgBuilder(),
        DSSingleMediaUploadBuilder(),
        DSSmallCheckIconOrgBuilder(),
        DSPhotoGroupOrgBuilder(),
        DSBackgroundWhiteViewBuilder(),
        DSTableItemCheckboxViewBuilder(),
        DSTableMainHeadingBuilder(),
        DSScalingTitleBuilder(),
        DSTitleCentralizedMlcBuilder(),
        DSNavigationPanelMlcV2Builder(),
        DSTitleLabelIconViewBuilder(),
        DSMapChipTabsViewBuilder(),
        DSHorizontalScrollCardBuilder(),
        DSVerificationCodesBuilder(),
        DSTableBlockTwoColumnsOrgBuilder(),
        DSImageCardCarouselBuilder(),
        DSChipTabsViewBuilder(),
        DSLoopingVideoCardBuilder(),
        DSCardMlcV2Builder(),
        DSCheckboxCascadeGroupBuilder(),
        DSCheckboxCascadeBuilder(),
        DSRecursiveContainerOrgBuilder(),
        TableSecondaryHeadingBuilder(),
        BankingCardCarouselBuilder(),
        BankingCardBuilder(),
        UpdatedContainerViewBuilder(),
        SpacerBuilder(),
        DSTextItemHorizontalBuilder(),
        OutlineButtonOrgBuilder(),
		DSBtnWhiteLargeIconAtmBuilder(),
		InputPhoneCodeV2Builder(),
        DSPaginationMessageMlcBuilder(),
        DSRadioBtnGroupOrgV2Builder(),
		PaymentInfoV2Builder(),
        DSEditAutomaticallyDeterminedValueBuilder(),
        DSItemReadViewBuilder(),
        DSStubInfoMessageMlcViewBuilder(),
        DSTextBlockViewBuilder(),
        InputTextV2Builder(),
        DSAccordionOrgBuilder(),
        DSTableAccordionOrgViewBuilder(),
        DSAlertCardV2Builder(),
        DSTableBlockOrgV2Builder(),
        DSSubTitleCentralizedMlcBuilder(),
        DSCenterChipBlackTabsOrgBuilder(),
        DSBtnSlideMlcBuilder(),
        DSLinkSharingMlcBuilder(),
        DSQrCodeOrgBuilder(),
        DSInputBlockViewBuilder(),
        DSDetailsTextValueViewBuilder(),
        DSEditAutomaticallyDeterminedValueBuilder(),
        DSAttachmentCardBuilder(),
        PhotoCardCarouselBuilder(),
        PhotoCardMlcBuidler(),
        DSSelectorOrgV2Builder(),
        DSCalendarOrgV2Builder(),
        DSLinkSettingsBuilder(),
        DSBtnPrimaryPlainIconBuilder(),
        DSPBtnAddOptionAtmBuilder(),
        CardImageMlcBuilder(),
        CardImageCarouselBuilder(),
        DSCheckboxGroupOrgBuilder(),
        DSCheckboxMlcBuilder(),
        DSStaticTickerAtmViewBuilder(),
        DSScanModalMessageBuilder(),
        ScanModalCardBuilder(),
        ActionSheetOrgBuilder(),
        PermissionMessageMlcBuilder(),
        CardProgressMlcBuilder()
    ]
}
