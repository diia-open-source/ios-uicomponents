
import Foundation

public enum ConstructorItemEvent {
    case action(DSActionParameter)
    case buttonAction(parameters: DSActionParameter, viewModel: DSLoadingButtonViewModel)
    case cardMlcAction(parameters: DSActionParameter, viewModel: DSCardMlcV2ViewModel)
    case inputChanged(ConstructorInputModel)
    case fileUploaderAction(viewModel: DSFileUploadViewModel)
    case dropContentAction(viewModel: DSSelectorViewModel)
    case buttonLoadIconAction(parameters: DSActionParameter, viewModel: IconedLoadingStateViewModel)
    case listAction(action: DSActionParameter, listItem: DSListItemViewModel, group: DSListViewModel)
    case paginationScroll(event: PaginationViewEvent, viewModel: DSConstructorPaginationViewModel)
    case calendarAction(event: DSCalendarEvent, viewModel: DSCalendarOrgViewModel)
    case editListAction(parameters: DSActionParameter, viewModel: DSListEditGroupViewModel)
    case phoneCodeAction(viewModel: DSInputPhoneCodeViewModel)
    case filterButtonAction(action: DSActionParameter, viewModel: DSWhiteAdditionalIconButtonViewModel)
    case fullVideoAction(model: DSFullScreenVideoOrg)
    case onComponentConfigured(with: ConstructorEventViewType)
    case collectionChange(item: String)
    case componentSizeDidChange
    
    /// Represents a dynamic event
    ///
    /// - Important:
    ///   Prefer strongly-typed `ConstructorItemEvent` cases whenever possible.
    ///   `dynamicEvent` is intended for external UI components implementations and
    ///   should not be used for common components.
    case customEvent(CustomConstructorEvent)
    
    public func actionParameters() -> DSActionParameter? {
        switch self {
        case .action(let parameters),
                .buttonAction(let parameters, _),
                .listAction(let parameters, _, _),
                .buttonLoadIconAction(let parameters, _),
                .editListAction(let parameters, _),
                .cardMlcAction(let parameters, _),
                .filterButtonAction(let parameters, _):
            return parameters
        case .calendarAction(let event, _):
            switch event {
            case .action(let parameters):
                return parameters
            default:
                return nil
            }
        default:
            return nil
        }
    }
}

public enum ConstructorEventViewType {
    case checkmark(viewModel: ChecklistViewModel)
    case ticker(viewModel: DSLargeTickerViewModel)
    case staticTicker(viewModel: DSStaticTickerViewModel)
    case smallCheckIcon(viewModel: DSSmallCheckIconOrgViewModel)
    case phoneCodeView(viewModel: DSInputPhoneCodeViewModel)
    case verificationOrg(viewModel: DSVerificationCodesViewModel)
    case loadingButton(viewModel: DSLoadingButtonViewModel)
    case resetStateComponent(component: DSResetStateComponentProtocol)
    case chipTabsView(viewModel: DSChipTabViewModel)
    case centerChipTabsView(viewModel: DSCenterChipBlackTabsOrgViewModel)
    case containerView(viewModel: DSContainerViewModel)
    case timer(viewModel: DSTimerTextViewModel)
    case inputLargeNumber(viewModel: DSInputNumberLargeViewModel)
    case listItems(viewModel: DSListViewModel)
    case cascadeView(viewModel: DSCheckboxCascadeViewModel)
    case linkQrShareView(viewModel: DSLinkQrShareViewModel)
    case titledView(viewModel: DSTitleMlcViewModel)
    case inputNumber(viewModel: DSInputNumberMlcViewModel)
    
    /// Represents a runtime-defined view type coming from UIComponents configuration.
    ///
    /// - Important:
    ///   Prefer strongly-typed cases whenever possible.
    ///   This case is intended for externally registered components.
    case customView(CustomConstructorViewTypeData)
}

public struct CustomConstructorEvent {
    public let code: String
    public let payload: [String: Any]
    
    public init(code: String, payload: [String: Any]) {
        self.code = code
        self.payload = payload
    }
}

public struct CustomConstructorViewTypeData {
    public let code: String
    public let viewModel: CustomConstructorViewModel
    
    public init(code: String, viewModel: CustomConstructorViewModel) {
        self.code = code
        self.viewModel = viewModel
    }
    
    public protocol CustomConstructorViewModel {}
}
