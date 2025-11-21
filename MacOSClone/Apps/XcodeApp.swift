import SwiftUI

// MARK: - Main View

struct XcodeApp: View {
    @State private var selectedFile: UUID? = sampleFiles[5].id // Default to ContentView.swift
    @State private var splitViewVisible = true
    @State private var inspectorVisible = true
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. macOS Window Bar / Xcode Toolbar
            // This provides the BACKGROUND for the window buttons, but leaves space for them
            XcodeToolbar()
            
            Divider().background(Color(white: 0.1))
            
            HStack(spacing: 0) {
                // 2. Navigator (Left)
                if splitViewVisible {
                    NavigatorView(selectedFile: $selectedFile)
                        .frame(width: 260)
                    
                    Divider().background(Color.black)
                }
                
                // 3. Editor (Center)
                VStack(spacing: 0) {
                    // Jump Bar
                    JumpBar()
                    Divider().background(Color(white: 0.1))
                    
                    // Code Area
                    EditorView()
                    
                    // Debug Area (Bottom)
                    Divider().background(Color(white: 0.1))
                    DebugAreaView()
                        .frame(height: 150)
                }
                
                // 4. Inspector (Right)
                if inspectorVisible {
                    Divider().background(Color.black)
                    InspectorView()
                        .frame(width: 260)
                }
            }
        }
        .background(Color(hex: "1F1F24")) // Authentic Xcode Dark Background
    }
}

// MARK: - Subviews

struct XcodeToolbar: View {
    var body: some View {
        HStack(spacing: 15) {
            
            // Run Controls
            // IMPORTANT: Added padding-leading 70 to make room for the WindowView close buttons
            HStack(spacing: 0) {
                Button(action: {}) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(white: 0.8))
                        .frame(width: 30, height: 24)
                }
                Button(action: {}) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(white: 0.4)) // Disabled look
                        .frame(width: 30, height: 24)
                }
            }
            .padding(.leading, 10) // Standard padding
            
            // Status Bar
            HStack {
                Image(systemName: "hammer.fill")
                    .font(.caption2)
                    .foregroundColor(.gray)
                VStack(alignment: .leading, spacing: 0) {
                    Text("Build Succeeded")
                        .font(.caption)
                        .foregroundColor(Color(white: 0.9))
                    Text("Today at 12:42 PM")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(white: 0.25))
            .cornerRadius(6)
            .frame(width: 250)
            
            Spacer()
            
            // Device Selector Mock
            HStack {
                Image(systemName: "iphone")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text("iPhone 15 Pro")
                    .font(.caption)
            }
            
            Spacer()
            
            // View Toggles
            HStack(spacing: 15) {
                Image(systemName: "square.split.bottomrightquarter")
                Image(systemName: "sidebar.left")
                    .foregroundColor(.blue) // Active
                Image(systemName: "sidebar.right")
                    .foregroundColor(.blue) // Active
            }
            .font(.system(size: 14))
            .foregroundColor(.gray)
            .padding(.trailing, 10)
        }
        .frame(height: 38) // Standard Toolbar Height
        .background(Color(hex: "2D2D30")) // The Toolbar Background Color
    }
}

// MARK: - Supporting Views (Unchanged, but included for compilation)

struct NavigatorView: View {
    @Binding var selectedFile: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                Image(systemName: "folder.fill").foregroundColor(.white).opacity(1.0)
                Image(systemName: "magnifyingglass").opacity(0.5)
                Image(systemName: "exclamationmark.triangle.fill").opacity(0.5)
                Image(systemName: "testtube.2").opacity(0.5)
                Image(systemName: "git.branch").opacity(0.5)
                Spacer()
            }
            .font(.system(size: 11))
            .padding(8)
            .background(Color(hex: "262626"))
            
            Divider().background(Color.black)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(sampleFiles) { file in
                        FileRow(file: file, isSelected: selectedFile == file.id)
                            .onTapGesture {
                                selectedFile = file.id
                            }
                    }
                }
                .padding(.top, 5)
            }
        }
        .background(Color(hex: "262626"))
    }
}

struct FileRow: View {
    let file: FileItem
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Spacer().frame(width: file.indent)
            Image(systemName: "chevron.right")
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.gray)
                .opacity(file.isFolder ? 1 : 0)
            
            Image(systemName: file.icon)
                .font(.system(size: 13))
                .foregroundColor(file.color)
                .frame(width: 16)
            
            Text(file.name)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? .white : Color(white: 0.8))
            
            Spacer()
            
            if file.name.contains(".swift") {
                Text("M")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
            }
        }
        .frame(height: 22)
        .background(isSelected ? Color.blue.opacity(0.4) : Color.clear)
        .contentShape(Rectangle())
    }
}

struct JumpBar: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 10))
                .foregroundColor(.gray)
            
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                Image(systemName: "chevron.right")
            }
            .font(.system(size: 10))
            .foregroundColor(.gray)
            
            HStack(spacing: 5) {
                Image(systemName: "app.dashed").foregroundColor(.blue).font(.caption2)
                Text("MacOSClone").font(.system(size: 11))
                Image(systemName: "chevron.right").font(.caption2).foregroundColor(.gray)
                
                Image(systemName: "folder.fill").foregroundColor(.yellow).font(.caption2)
                Text("Views").font(.system(size: 11))
                Image(systemName: "chevron.right").font(.caption2).foregroundColor(.gray)
                
                Image(systemName: "swift").foregroundColor(.orange).font(.caption2)
                Text("ContentView.swift").font(.system(size: 11)).bold()
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(height: 28)
        .background(Color(hex: "1F1F24"))
    }
}

struct EditorView: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .trailing, spacing: 2) {
                ForEach(1..<30) { i in
                    Text("\(i)")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(Color(white: 0.4))
                        .frame(height: 18)
                }
                Spacer()
            }
            .padding(.top, 8)
            .padding(.trailing, 8)
            .frame(width: 35)
            .background(Color(hex: "1F1F24"))
            
            Divider().background(Color(white: 0.1))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    Group {
                        CodeLine(num: 1, text: [T("import ", .pink), T("SwiftUI", .white)])
                        CodeLine(num: 2, text: [])
                        CodeLine(num: 3, text: [T("struct ", .pink), T("ContentView", .cyan), T(": ", .white), T("View ", .purple), T("{", .white)])
                        CodeLine(num: 4, text: [T("    ", .white), T("@State ", .pink), T("private var ", .pink), T("counter ", .cyan), T("= ", .white), T("0", .yellow)])
                        CodeLine(num: 5, text: [])
                        CodeLine(num: 6, text: [T("    ", .white), T("var ", .pink), T("body", .cyan), T(": ", .white), T("some ", .pink), T("View ", .purple), T("{", .white)])
                        CodeLine(num: 7, text: [T("        ", .white), T("VStack ", .cyan), T("{", .white)])
                        CodeLine(num: 8, text: [T("            ", .white), T("Image", .cyan), T("(", .white), T("systemName", .purple), T(": ", .white), T("\"globe\"", .orange), T(")", .white)])
                        CodeLine(num: 9, text: [T("                ", .white), T(".imageScale", .purple), T("(", .white), T(".large", .purple), T(")", .white)])
                        CodeLine(num: 10, text: [T("                ", .white), T(".foregroundColor", .purple), T("(", .white), T(".accentColor", .purple), T(")", .white)])
                        CodeLine(num: 11, text: [T("            ", .white), T("Text", .cyan), T("(", .white), T("\"Hello, world!\"", .orange), T(")", .white)])
                    }
                    Group {
                        CodeLine(num: 12, text: [T("        ", .white), T("}", .white)])
                        CodeLine(num: 13, text: [T("        ", .white), T(".padding", .purple), T("()", .white)])
                        CodeLine(num: 14, text: [T("    ", .white), T("}", .white)])
                        CodeLine(num: 15, text: [T("}", .white)])
                        CodeLine(num: 16, text: [])
                        CodeLine(num: 17, text: [T("#Preview ", .pink), T("{", .white)])
                        CodeLine(num: 18, text: [T("    ", .white), T("ContentView", .cyan), T("()", .white)])
                        CodeLine(num: 19, text: [T("}", .white)])
                    }
                }
                .padding(.top, 8)
                .padding(.leading, 5)
            }
            .background(Color(hex: "1F1F24"))
        }
    }
}

struct CodeLine: View {
    let num: Int
    let text: [T]
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<text.count, id: \.self) { i in
                Text(text[i].str)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(text[i].color)
            }
            Spacer()
        }
        .frame(height: 18)
    }
}
struct T {
    let str: String
    let color: Color
    init(_ str: String, _ color: Color) { self.str = str; self.color = color }
}

struct DebugAreaView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "sidebar.left").font(.caption)
                Spacer()
                Text("All Output").font(.caption).bold()
                Spacer()
                Image(systemName: "trash").font(.caption)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color(hex: "262626"))
            .foregroundColor(Color(white: 0.6))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Build Succeeded")
                    .font(.system(size: 11, design: .monospaced))
                    .bold()
                Text("Launching MacOSClone")
                    .font(.system(size: 11, design: .monospaced))
                Text("Connected to iPhone 15 Pro")
                    .font(.system(size: 11, design: .monospaced))
            }
            .foregroundColor(Color(white: 0.8))
            .padding(5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "1F1F24"))
            
            Spacer()
        }
    }
}

struct InspectorView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 18) {
                Image(systemName: "doc.text")
                Image(systemName: "clock")
                Image(systemName: "questionmark.circle")
                Image(systemName: "slider.horizontal.3").foregroundColor(.blue)
                Image(systemName: "text.alignleft")
                Spacer()
            }
            .font(.system(size: 12))
            .padding(8)
            .background(Color(hex: "262626"))
            .foregroundColor(Color(white: 0.6))
            
            Divider().background(Color.black)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    InspectorSectionHeader(title: "Identity and Type")
                    VStack(spacing: 10) {
                        InspectorRow(label: "Name", value: "ContentView.swift")
                        InspectorRow(label: "Type", value: "Swift Source")
                        InspectorRow(label: "Location", value: "Relative to Group")
                    }
                    .padding(10)
                    Divider().background(Color(white: 0.2))
                    
                    InspectorSectionHeader(title: "Target Membership")
                    HStack {
                        Image(systemName: "checkmark.square.fill").foregroundColor(.blue)
                        Text("MacOSClone").font(.system(size: 11))
                        Spacer()
                    }
                    .padding(10)
                    Divider().background(Color(white: 0.2))
                    
                    InspectorSectionHeader(title: "Text Settings")
                    VStack(spacing: 10) {
                        InspectorRow(label: "Encoding", value: "UTF-8")
                        InspectorRow(label: "Line Endings", value: "LF")
                        HStack {
                            Text("Indent").font(.system(size: 11)).foregroundColor(.gray)
                            Spacer()
                            Text("4 Spaces").font(.system(size: 11))
                        }
                    }
                    .padding(10)
                }
            }
        }
        .background(Color(hex: "262626"))
    }
}

struct InspectorSectionHeader: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Color(white: 0.7))
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(Color(white: 0.15))
    }
}

struct InspectorRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.gray)
                .frame(width: 70, alignment: .trailing)
            Text(value)
                .font(.system(size: 11))
                .foregroundColor(.white)
                .padding(.leading, 5)
            Spacer()
        }
    }
}

// MARK: - Models

struct FileItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let isFolder: Bool
    let indent: CGFloat
}

let sampleFiles = [
    FileItem(name: "MacOSClone", icon: "app.dashed", color: .blue, isFolder: true, indent: 0),
    FileItem(name: "Shared", icon: "folder.fill", color: .yellow, isFolder: true, indent: 10),
    FileItem(name: "Models", icon: "folder.fill", color: .yellow, isFolder: true, indent: 20),
    FileItem(name: "Data.swift", icon: "swift", color: .orange, isFolder: false, indent: 30),
    FileItem(name: "Views", icon: "folder.fill", color: .yellow, isFolder: true, indent: 10),
    FileItem(name: "ContentView.swift", icon: "swift", color: .orange, isFolder: false, indent: 20),
    FileItem(name: "XcodeApp.swift", icon: "swift", color: .orange, isFolder: false, indent: 20),
    FileItem(name: "Assets.xcassets", icon: "photo.on.rectangle", color: .blue, isFolder: false, indent: 10),
    FileItem(name: "Info.plist", icon: "list.bullet.rectangle", color: .gray, isFolder: false, indent: 10)
]

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

// MARK: - Preview
struct XcodeApp_Previews: PreviewProvider {
    static var previews: some View {
        XcodeApp()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
