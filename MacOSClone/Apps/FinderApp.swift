import SwiftUI

struct FinderApp: View {
    @State private var selectedItem: Int? = nil
    @State private var viewMode: Int = 0 // 0 = Icons, 1 = List...
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. Finder Toolbar
            FinderToolbar()
            
            Divider()
            
            // 2. Split View (Sidebar + Content)
            HStack(spacing: 0) {
                // Sidebar
                FinderSidebar()
                    .frame(width: 180)
                
                Divider()
                
                // Main Icon View
                FinderContentArea(selectedItem: $selectedItem)
            }
        }
        .background(Color(hex: "F6F6F6")) // Window BG
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - 1. Toolbar

struct FinderToolbar: View {
    var body: some View {
        HStack(spacing: 15) {
            // Traffic Lights Space
            Color.clear.frame(width: 60)
            
            // View Controls
            HStack(spacing: 0) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 12))
                    .padding(.horizontal, 8)
                    .foregroundColor(.gray)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .padding(.horizontal, 8)
                    .foregroundColor(.gray.opacity(0.5))
            }
            
            Text("Desktop")
                .font(.system(size: 13, weight: .bold))
            
            Spacer()
            
            // Icon View Toggles
            HStack(spacing: 18) {
                Image(systemName: "square.grid.2x2") // Icons
                Image(systemName: "list.bullet")      // List
                Image(systemName: "rectangle.grid.1x2") // Columns
                Image(systemName: "square.stack.3d.up") // Gallery
            }
            .font(.system(size: 12))
            .foregroundColor(.gray)
            
            // Search
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text("Search")
                    .font(.system(size: 12))
                    .foregroundColor(.gray.opacity(0.7))
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .frame(width: 150)
            .background(Color.white)
            .cornerRadius(6)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.2), lineWidth: 1))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .frame(height: 52)
        .background(Color(hex: "F6F6F6"))
    }
}

// MARK: - 2. Sidebar

struct FinderSidebar: View {
    var body: some View {
        List {
            Section(header: Text("Favorites").font(.caption).foregroundColor(.gray).padding(.leading, -10)) {
                SidebarRow(icon: "dot.radiowaves.left.and.right", color: .blue, title: "AirDrop")
                SidebarRow(icon: "clock", color: .gray, title: "Recents")
                SidebarRow(icon: "app.fill", color: .purple, title: "Applications")
                SidebarRow(icon: "desktopcomputer", color: .blue, title: "Desktop")
                SidebarRow(icon: "doc.fill", color: .blue, title: "Documents")
                SidebarRow(icon: "arrow.down.circle.fill", color: .blue, title: "Downloads")
            }
            
            Section(header: Text("iCloud").font(.caption).foregroundColor(.gray).padding(.leading, -10)) {
                SidebarRow(icon: "icloud.fill", color: .blue, title: "iCloud Drive")
                SidebarRow(icon: "folder.fill.badge.person.crop", color: .blue, title: "Shared")
            }
            
            Section(header: Text("Locations").font(.caption).foregroundColor(.gray).padding(.leading, -10)) {
                SidebarRow(icon: "internaldrive.fill", color: .gray, title: "Macintosh HD")
                SidebarRow(icon: "server.rack", color: .gray, title: "Network")
            }
        }
        .listStyle(SidebarListStyle())
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterialLight)))
    }
}

struct SidebarRow: View {
    let icon: String
    let color: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
                .frame(width: 16)
            Text(title)
                .font(.system(size: 13))
        }
        .padding(.vertical, 2)
    }
}

// MARK: - 3. Content Area

struct FinderContentArea: View {
    @Binding var selectedItem: Int?
    
    // Mock Data
    let folders = ["Project Alpha", "Designs", "Old Stuff", "Receipts"]
    let files = ["Budget.xlsx", "Notes.txt", "Logo.png", "Report.pdf", "Script.swift"]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 20) {
                    // Folders
                    ForEach(0..<folders.count, id: \.self) { i in
                        FinderItem(
                            icon: "folder.fill",
                            color: .blue,
                            name: folders[i],
                            isSelected: selectedItem == i
                        )
                        .onTapGesture { selectedItem = i }
                    }
                    
                    // Files
                    ForEach(0..<files.count, id: \.self) { i in
                        let offsetIndex = i + folders.count
                        FinderItem(
                            icon: getFileIcon(files[i]),
                            color: .gray,
                            name: files[i],
                            isSelected: selectedItem == offsetIndex
                        )
                        .onTapGesture { selectedItem = offsetIndex }
                    }
                }
                .padding(20)
            }
        }
    }
    
    func getFileIcon(_ name: String) -> String {
        if name.hasSuffix("png") { return "photo" }
        if name.hasSuffix("txt") { return "doc.text" }
        if name.hasSuffix("swift") { return "swift" }
        return "doc"
    }
}

struct FinderItem: View {
    let icon: String
    let color: Color
    let name: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
                .foregroundColor(color)
            
            Text(name)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? .white : .black)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isSelected ? Color.blue : Color.clear)
                )
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80, height: 90)
        .contentShape(Rectangle()) // Improves tap area
    }
}

#Preview {
    FinderApp()
        .frame(width: 800, height: 350)
}
