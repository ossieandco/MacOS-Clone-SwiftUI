import SwiftUI
import Combine

struct WindowState: Identifiable, Equatable {
    let id: UUID
    let appType: AppType
    var title: String
    var position: CGPoint
    var size: CGSize
    var zIndex: Double
    var isMinimized: Bool = false
    var isMaximized: Bool = false
    
    // Helper to check equality
    static func == (lhs: WindowState, rhs: WindowState) -> Bool {
        return lhs.id == rhs.id &&
               lhs.position == rhs.position &&
               lhs.size == rhs.size &&
               lhs.zIndex == rhs.zIndex &&
               lhs.isMinimized == rhs.isMinimized &&
               lhs.isMaximized == rhs.isMaximized
    }
}

class DesktopViewModel: ObservableObject {
    @Published var windows: [WindowState] = []
    @Published var activeWindowId: UUID?
    @Published var activeMenu: String? // Tracks which menu is open (e.g., "Apple", "App")
    
    // Z-index management
    private var maxZIndex: Double = 0
    
    func launchApp(_ app: AppType) {
        // Check if app is already open (optional: for single instance apps)
        // For now, allow multiple instances or just bring to front if single instance desired
        
        // Initial position: Center-ish.
        // Assuming a generic screen size, we'll place it such that top-left is visible.
        // If we treat position as Top-Left, (100, 100) is fine.
        // If we treat position as Center, (100, 100) is bad.
        // We will switch to Top-Left interpretation in the View.
        // So (80, 80) + cascade is good for Top-Left.
        
        let newWindow = WindowState(
            id: UUID(),
            appType: app,
            title: app.title,
            position: CGPoint(x: 80 + Double(windows.count * 30), y: 100 + Double(windows.count * 30)), 
            size: app.defaultSize,
            zIndex: getNextZIndex()
        )
        
        windows.append(newWindow)
        bringToFront(windowId: newWindow.id)
    }
    
    func closeWindow(id: UUID) {
        windows.removeAll { $0.id == id }
        if activeWindowId == id {
            activeWindowId = nil
        }
    }
    
    func quitApp() {
        guard let activeId = activeWindowId else { return }
        closeWindow(id: activeId)
        activeMenu = nil
    }
    
    func bringToFront(windowId: UUID) {
        guard let index = windows.firstIndex(where: { $0.id == windowId }) else { return }
        
        maxZIndex += 1
        windows[index].zIndex = maxZIndex
        activeWindowId = windowId
    }
    
    func updateWindowPosition(id: UUID, newPosition: CGPoint) {
        guard let index = windows.firstIndex(where: { $0.id == id }) else { return }
        windows[index].position = newPosition
    }
    
    func updateWindowSize(id: UUID, newSize: CGSize) {
        guard let index = windows.firstIndex(where: { $0.id == id }) else { return }
        windows[index].size = newSize
    }
    
    private func getNextZIndex() -> Double {
        maxZIndex += 1
        return maxZIndex
    }
}
