import SwiftUI

struct ContentView: View {
    @StateObject private var desktop = DesktopViewModel()
    
    var body: some View {
        ZStack {
            // Wallpaper
            GeometryReader { proxy in
                Image("wallpaper")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width + 2, height: proxy.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
            
            // Windows Layer
            GeometryReader { geometry in
                ZStack {
                    ForEach($desktop.windows) { $window in
                        WindowView(
                            windowState: $window,
                            onClose: { desktop.closeWindow(id: window.id) },
                            onFocus: { desktop.bringToFront(windowId: window.id) }
                        ) {
                            // Content based on app type
                            switch window.appType {
                                case .finder:
                                    FinderApp()
                                case .safari:
                                    SafariApp()
                                case .settings:
                                    SettingsApp()
                                case .terminal:
                                    TerminalApp()
                                case .calculator:
                                    CalculatorApp()
                                case .finalCutPro:
                                    FinalCutProApp()
                                case .textEdit:
                                    TextEditApp()
                                case .xcode:
                                    XcodeApp()
                            }
                        }
                        .zIndex(window.zIndex)
                    }
                }
                .coordinateSpace(name: "desktop")
            }
            .ignoresSafeArea()
            
            // UI Layer
            VStack {
                MenuBar()
                    .environmentObject(desktop)
                    .environment(\.colorScheme, .light)
                    .ignoresSafeArea()
                
                Spacer()
                
                Dock()
                    .environmentObject(desktop)
                    .ignoresSafeArea()
            }
        }
        .statusBar(hidden: true)
    }
}

enum AppType: String, CaseIterable, Identifiable {
    case finder
    case safari
    case settings
    case terminal
    case calculator
    case finalCutPro
    case textEdit
    case xcode
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
            case .finder: return "Finder"
            case .safari: return "Safari"
            case .settings: return "System Settings"
            case .terminal: return "Terminal"
            case .calculator: return "Calculator"
            case .finalCutPro: return "Final Cut Pro"
            case .textEdit: return "TextEdit"
            case .xcode: return "Xcode"
        }
    }
    
    var iconName: String {
        switch self {
            case .finder: return "finder"
            case .safari: return "safari"
            case .settings: return "settings"
            case .terminal: return "terminal"
            case .calculator: return "calculator"
            case .finalCutPro: return "finalcutpro"
            case .textEdit: return "textedit"
            case .xcode: return "xcode"
        }
    }
    
    var defaultSize: CGSize {
        switch self {
            case .calculator: return CGSize(width: 250, height: 430)
            case .finalCutPro: return CGSize(width: 800, height: 450)
            case .textEdit: return CGSize(width: 400, height: 300)
            case .xcode: return CGSize(width: 800, height: 900)
            case .finder: return CGSize(width: 700, height: 350)
            default: return CGSize(width: 600, height: 350)
        }
    }
    
    var preferredColorScheme: ColorScheme {
        switch self {
        case .terminal, .calculator, .finalCutPro, .xcode:
            return .dark
        default:
            return .light
        }
    }
}

struct Dock: View {
    @EnvironmentObject var desktop: DesktopViewModel
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(AppType.allCases) { app in
                VStack(spacing: 4) {
                    ZStack {
                        Image(app.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 45, height: 45)
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
                .onTapGesture {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        desktop.launchApp(app)
                    }
                }
            }
        }
        .padding(14)
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.bottom, -13)
    }
}

struct MenuBar: View {
    @EnvironmentObject var desktop: DesktopViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Apple Logo
            Menu {
                Button("About This Mac", action: {})
                Divider()
                Button("System Settings...", action: {})
                Button("App Store...", action: {})
                Divider()
                Button("Sleep", action: {})
                Button("Restart...", action: {})
                Button("Shut Down...", action: {})
                Divider()
                Button("Lock Screen", action: {})
                Button("Log Out User...", action: {})
            } label: {
                Image(systemName: "apple.logo")
                    .font(.system(size: 14))
                    .padding(.leading, 15)
            }
            
            // App Name (Active App)
            Menu {
                Button("About \(desktop.activeWindowId != nil ? desktop.windows.first(where: { $0.id == desktop.activeWindowId })?.title ?? "Finder" : "Finder")", action: {})
                Divider()
                Button("Settings...", action: {})
                Divider()
                Button("Quit", action: { desktop.quitApp() })
            } label: {
                Text(desktop.activeWindowId != nil ? desktop.windows.first(where: { $0.id == desktop.activeWindowId })?.title ?? "Finder" : "Finder")
                    .font(.system(size: 13, weight: .bold))
            }
            
            // Menus (Static for now)
            HStack(spacing: 15) {
                Text("File")
                Text("Edit")
                Text("View")
                Text("Go")
                Text("Window")
                Text("Help")
            }
            .font(.system(size: 13))
            
            Spacer()
            
            // Right Side Items
            HStack(spacing: 15) {
                Image(systemName: "battery.100")
                Image(systemName: "wifi")
                Image(systemName: "magnifyingglass")
                Image(systemName: "switch.2") // Control Center icon approximation
                
                // Date/Time
                Text(Date(), style: .time)
                    .font(.system(size: 13))
            }
            .font(.system(size: 12))
            .padding(.trailing, 15)
        }
        .frame(height: 30)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialLight)))
        .foregroundColor(.primary)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
