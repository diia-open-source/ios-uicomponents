
import UIKit
import DiiaCommonTypes

public struct DSConstructorModel: Codable {
    public let topGroup: [AnyCodable]
    public let body: [AnyCodable]?
    public let bottomGroup: [AnyCodable]?
    public let ratingForm: PublicServiceRatingForm?
    public let template: AlertTemplate?
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.topGroup = (try? container.decodeIfPresent([AnyCodable].self, forKey: .topGroup)) ?? []
        self.body = try? container.decodeIfPresent([AnyCodable].self, forKey: .body)
        self.bottomGroup = try? container.decodeIfPresent([AnyCodable].self, forKey: .bottomGroup)
        self.ratingForm = try? container.decodeIfPresent(PublicServiceRatingForm.self, forKey: .ratingForm)
        self.template = try? container.decodeIfPresent(AlertTemplate.self, forKey: .template)
    }
    
    public init(topGroup: [AnyCodable] = [],
                body: [AnyCodable]? = [],
                bottomGroup: [AnyCodable]? = [],
                ratingForm: PublicServiceRatingForm? = nil,
                template: AlertTemplate? = nil) {
        self.topGroup = topGroup
        self.body = body
        self.bottomGroup = bottomGroup
        self.ratingForm = ratingForm
        self.template = template
    }
}

public class DSViewFabric {
    public static let instance = DSViewFabric()
    
    private var viewBuilders: [String: DSViewBuilderProtocol]
    
    public init(viewBuilders: [String: DSViewBuilderProtocol] = DSViewFabric.builders) {
        self.viewBuilders = viewBuilders
    }
    
    public func makeView(
        from object: AnyCodable,
        withPadding: DSViewPaddingType,
        eventHandler: @escaping (ConstructorItemEvent) -> Void
    ) -> UIView? {
        if let key = object.keys().first,
           let builder = viewBuilders[key],
           let view = builder.makeView(from: object, withPadding: withPadding, viewFabric: self, eventHandler: eventHandler)
        {
            return view
        }
        return nil
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
    
    public func bottomGroupViews(for model: DSConstructorModel, eventHandler: @escaping (ConstructorItemEvent) -> Void) -> [UIView] {
        return (model.bottomGroup ?? []).enumerated().compactMap { (index, element) in
            let paddingType: DSViewPaddingType = (index == 0) ? .firstComponent : .default
            return makeView(from: element, withPadding: paddingType, eventHandler: eventHandler)
        }
    }
    
    public func setBuilder(_ builder: DSViewBuilderProtocol, forKey key: String) {
        viewBuilders[key] = builder
    }
    
    public static let builders: [String: DSViewBuilderProtocol] = [
        DSTopGroupViewBuilder.modelKey: DSTopGroupViewBuilder(),
        DSSearchInputViewBuilder.modelKey: DSSearchInputViewBuilder(),
        DSTitleLabelBuilder.modelKey: DSTitleLabelBuilder(),
        DSSubtitleLabelBuilder.modelKey: DSSubtitleLabelBuilder(),
        DSSectionTitleBuilder.modelKey: DSSectionTitleBuilder(),
        DSAttentionMessageViewBuilder.modelKey: DSAttentionMessageViewBuilder(),
        DSCardListViewBuilder.modelKey: DSCardListViewBuilder(),
        DSTextLabelBuilder.modelKey: DSTextLabelBuilder(),
        DSTextViewBuilder.modelKey: DSTextViewBuilder(),
        DSButtonIconGroupBuilder.modelKey: DSButtonIconGroupBuilder(),
        DSCheckboxGroupBuilder.modelKey: DSCheckboxGroupBuilder(),
        DSRadioButtonGroupBuilder.modelKey: DSRadioButtonGroupBuilder(),
        DSRadioBtnWithAltOrgBuilder.modelKey: DSRadioBtnWithAltOrgBuilder(),
        DSCheckboxButtonOrgBuilder.modelKey: DSCheckboxButtonOrgBuilder(),
        DSSmallNotificationCarouselBuilder.modelKey: DSSmallNotificationCarouselBuilder(),
        DSHalvedCardCarouselBuilder.modelKey: DSHalvedCardCarouselBuilder(),
        DSImageViewBuilder.modelKey: DSImageViewBuilder(),
        DSListViewBuilder.modelKey: DSListViewBuilder(),
        DSVideoContainerBuilder.modelKey: DSVideoContainerBuilder(),
        DSStatusMessageBuilder.modelKey: DSStatusMessageBuilder(),
        DSEmptyStateViewBuilder.modelKey: DSEmptyStateViewBuilder(),
        DSBlackCardBuilder.modelKey: DSBlackCardBuilder(),
        DSWhiteCardBuilder.modelKey: DSWhiteCardBuilder(),
        DSImageCardBuilder.modelKey: DSImageCardBuilder(),
        DSHorizontalCarouselBuilder.modelKey: DSHorizontalCarouselBuilder(),
        DSButtonIconRoundedGroupBuilder.modelKey: DSButtonIconRoundedGroupBuilder(),
        DSMediaTitleBuilder.modelKey: DSMediaTitleBuilder(),
        DSArticlePicCarouselBuilder.modelKey: DSArticlePicCarouselBuilder(),
        DSBottomGroupBuilder.modelKey: DSBottomGroupBuilder(),
        DSPrimaryButtonBuilder.modelKey: DSPrimaryButtonBuilder(),
        DSPrimaryLargeButtonBuilder.modelKey: DSPrimaryLargeButtonBuilder(),
        DSPrimaryWideButtonBuilder.modelKey: DSPrimaryWideButtonBuilder(),
        DSStrokeButtonBuilder.modelKey: DSStrokeButtonBuilder(),
        BtnStrokeWideAtmBuilder.modelKey: BtnStrokeWideAtmBuilder(),
        DSPlainButtonBuilder.modelKey: DSPlainButtonBuilder(),
        DSButtonLinkBuilder.modelKey: DSButtonLinkBuilder(),
        DSTableBlockOrgBuilder.modelKey: DSTableBlockOrgBuilder(),
        DSDocHeadingBuilder.modelKey: DSDocHeadingBuilder(),
        DSHeadingWithSubtitlesBuilder.modelKey: DSHeadingWithSubtitlesBuilder(),
        DSTableItemPrimaryBuilder.modelKey: DSTableItemPrimaryBuilder(),
        DSAvatarViewBuilder.modelKey: DSAvatarViewBuilder(),
        DSChipAtomBuilder.modelKey: DSChipAtomBuilder(),
        DSTickerAtmBuilder.modelKey: DSTickerAtmBuilder(),
        DSInputTextViewBuilder.modelKey: DSInputTextViewBuilder(),
        DSQRSharingOrgBuilder.modelKey: DSQRSharingOrgBuilder(),
        DSEditAutomaticallyDeterminedValueBuilder.modelKey: DSEditAutomaticallyDeterminedValueBuilder(),
        DSQuestionFormBuilder.modelKey: DSQuestionFormBuilder(),
        DSFileUploadGroupBuilder.modelKey: DSFileUploadGroupBuilder(),
        DSGroupFilesAddBuilder.modelKey: DSGroupFilesAddBuilder(),
        DSDividerLineBuilder.modelKey: DSDividerLineBuilder(),
        DSTableBlockAccordionViewBuilder.modelKey: DSTableBlockAccordionViewBuilder(),
        DSTableItemVerticalMlcBuilder.modelKey: DSTableItemVerticalMlcBuilder(),
        DSTableItemHorizontalMlcBuilder.modelKey: DSTableItemHorizontalMlcBuilder(),
        DSTableItemPrimaryMlcBuilder.modelKey: DSTableItemPrimaryMlcBuilder(),
        DSDocTableItemHorizontalMlcBuilder.modelKey: DSDocTableItemHorizontalMlcBuilder(),
        DSDocTableItemHorizontalLongerMlcBuilder.modelKey: DSDocTableItemHorizontalLongerMlcBuilder(),
        DSTableItemHorizontalLargeMlcBuilder.modelKey: DSTableItemHorizontalLargeMlcBuilder(),
        DSSmallEmojiPanelMlcBuilder.modelKey: DSSmallEmojiPanelMlcBuilder(),
        DSTableBlockPlaneOrgBuilder.modelKey: DSTableBlockPlaneOrgBuilder(),
        DSInputNumberLargeViewBuilder.modelKey: DSInputNumberLargeViewBuilder(),
        DSTimerTextViewBuilder.modelKey: DSTimerTextViewBuilder(),
        DSPaymentInfoBuilder.modelKey: DSPaymentInfoBuilder(),
        DSButtonIconPlainGroupBuilder.modelKey: DSButtonIconPlainGroupBuilder(),
        DSSharingCodesBuilder.modelKey: DSSharingCodesBuilder(),
        DSPaginationListViewBuilder.modelKey: DSPaginationListViewBuilder(),
        DSListWidgetItemBuilder.modelKey: DSListWidgetItemBuilder(),
        DSMultilineInputTextBuilder.modelKey: DSMultilineInputTextBuilder(),
        DSInputNumberViewBuilder.modelKey: DSInputNumberViewBuilder(),
        DSInputNumberFractionalViewBuilder.modelKey: DSInputNumberFractionalViewBuilder(),
        DSSelectorOrgBuilder.modelKey: DSSelectorOrgBuilder(),
        DSInputDateMlcBuilder.modelKey: DSInputDateMlcBuilder(),
        DSInputTimeMlcBuilder.modelKey: DSInputTimeMlcBuilder(),
        DSCalendarOrgBuilder.modelKey: DSCalendarOrgBuilder(),
        DSInputDateTimeMlcBuilder.modelKey: DSInputDateTimeMlcBuilder(),
        DSDashboardCardMlcBuilder.modelKey: DSDashboardCardMlcBuilder(),
        DSDashboardCardTileOrgBuilder.modelKey: DSDashboardCardTileOrgBuilder(),
        DSAlertCardBuilder.modelKey: DSAlertCardBuilder(),
        DSAttentionIconMessageBuilder.modelKey: DSAttentionIconMessageBuilder(),
        DSGrayTitleAtmBulder.modelKey: DSGrayTitleAtmBulder(),
        DSListItemMlcBuilder.modelKey: DSListItemMlcBuilder(),
        DSPaginationListWhiteViewBuilder.modelKey: DSPaginationListWhiteViewBuilder(),
        DSLargeTickerAtmViewBuilder.modelKey: DSLargeTickerAtmViewBuilder(),
        DSListEditGroupViewBuilder.modelKey: DSListEditGroupViewBuilder(),
        DSInputPhoneCodeBuilder.modelKey: DSInputPhoneCodeBuilder(),
        DSWhiteLargeButtonBuilder.modelKey: DSWhiteLargeButtonBuilder(),
        DSChipsBlackOrgBuilder.modelKey: DSChipsBlackOrgBuilder(),
        DSSearchBarOrgBuilder.modelKey: DSSearchBarOrgBuilder(),
        DSSwitchModeViewBuilder.modelKey: DSSwitchModeViewBuilder(),
        DSCheckboxBtnWhiteOrgBuilder.modelKey: DSCheckboxBtnWhiteOrgBuilder(),
        DSSingleMediaUploadBuilder.modelKey: DSSingleMediaUploadBuilder(),
        DSSmallCheckIconOrgBuilder.modelKey: DSSmallCheckIconOrgBuilder(),
        DSPhotoGroupOrgBuilder.modelKey: DSPhotoGroupOrgBuilder(),
        DSBackgroundWhiteViewBuilder.modelKey: DSBackgroundWhiteViewBuilder(),
        DSTableItemCheckboxViewBuilder.modelKey: DSTableItemCheckboxViewBuilder(),
        DSTableMainHeadingBuilder.modelKey: DSTableMainHeadingBuilder(),
        DSScalingTitleBuilder.modelKey: DSScalingTitleBuilder(),
        DSTitleLabelIconViewBuilder.modelKey: DSTitleLabelIconViewBuilder(),
        DSMapChipTabsViewBuilder.modelKey: DSMapChipTabsViewBuilder(),
        DSHorizontalScrollCardBuilder.modelKey: DSHorizontalScrollCardBuilder(),
        DSVerificationCodesBuilder.modelKey: DSVerificationCodesBuilder(),
        DSTableBlockTwoColumnsOrgBuilder.modelKey: DSTableBlockTwoColumnsOrgBuilder(),
        DSImageCardCarouselBuilder.modelKey: DSImageCardCarouselBuilder(),
        DSChipTabsViewBuilder.modelKey: DSChipTabsViewBuilder(),
        DSLoopingVideoCardBuilder.modelKey: DSLoopingVideoCardBuilder(),
        DSCardMlcV2Builder.modelKey: DSCardMlcV2Builder(),
        DSCheckboxCascadeGroupBuilder.modelKey: DSCheckboxCascadeGroupBuilder(),
        DSCheckboxCascadeBuilder.modelKey: DSCheckboxCascadeBuilder(),
        DSRecursiveContainerOrgBuilder.modelKey: DSRecursiveContainerOrgBuilder(),
        TableSecondaryHeadingBuilder.modelKey: TableSecondaryHeadingBuilder(),
        BankingCardCarouselBuilder.modelKey: BankingCardCarouselBuilder(),
        BankingCardBuilder.modelKey: BankingCardBuilder(),
        UpdatedContainerViewBuilder.modelKey: UpdatedContainerViewBuilder(),
        SpacerBuilder.modelKey: SpacerBuilder()
    ]
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
