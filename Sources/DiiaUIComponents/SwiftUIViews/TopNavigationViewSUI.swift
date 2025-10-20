
import SwiftUI
import DiiaMVPModule
import DiiaCommonTypes

public final class TopNavigationViewModel: ObservableObject {
    public let contextMenu: ContextMenuProviderProtocol
    @Published var title: String
    @Published var hasContextMenu: Bool
    private let navigation: NavigationHolder
    
    public init(contextMenu: ContextMenuProviderProtocol, navigation: NavigationHolder) {
        self.contextMenu = contextMenu
        self.navigation = navigation
        self.title = contextMenu.title ?? ""
        self.hasContextMenu = contextMenu.hasContextMenu()
    }
    
    func contextMenuClicked() {
        contextMenu.openContextMenu(in: navigation)
    }
    
    func closeView() {
        navigation.closeModule(animated: true)
    }
}

public struct TopNavigationViewSUI: View {
    @ObservedObject var viewModel: TopNavigationViewModel

    public init(viewModel: TopNavigationViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        HStack {
            Button {
                viewModel.closeView()
            } label: {
                Image("menu_back")
                    .foregroundColor(.primary)
                    .frame(width: 24, height: 24)
            }
            Text(viewModel.title)
                .font(Font(FontBook.smallHeadingFont))
            Spacer()
            if viewModel.hasContextMenu {
                Button {
                    viewModel.contextMenuClicked()
                } label: {
                    Image("more")
                        .foregroundColor(.primary)
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding()
    }
}
