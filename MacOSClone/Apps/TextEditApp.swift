import SwiftUI

struct TextEditApp: View {
    // Mock Data
    @State private var text: String = """
    To: The Team
    From: John Appleseed
    Subject: Project Update
    
    Hello everyone,
    
    We are making great progress on the SwiftUI macOS clone. The interface accuracy is improving with every iteration.
    
    Key items to review:
    1. Window chrome styling
    2. Toolbar interactions
    3. Font rendering
    
    Best,
    John
    """
    @State private var fontSize: CGFloat = 14
    @State private var isBold = false
    @State private var isItalic = false
    @State private var isUnderlined = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. The Toolbar
            TextEditToolbar(
                isBold: $isBold,
                isItalic: $isItalic,
                isUnderlined: $isUnderlined
            )
            
            Divider()
            
            // 2. The Ruler
            RulerView()
            
            Divider()
            
            // 3. The Document Area (Paper style)
            ZStack {
                // App Background (The "Desk")
                //Color(hex: "F0F0F0")
                
                // The Paper
                ScrollView([.vertical, .horizontal]) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $text)
                            .font(.system(size: fontSize, weight: isBold ? .bold : .regular))
                            .italic(isItalic)
                            .underline(isUnderlined)
                            .foregroundColor(.black)
                            .scrollContentBackground(.hidden) // Remove default iOS background
                            .padding(.horizontal, 10) // Paper Margins
                            .padding(.vertical, 10)
                            .frame(width: 400, height: 600)
                    }
                    .padding(20) // Space around paper
                }
            }
        }
        //.background(Color(hex: "F6F6F6")) // Window Background
    }
}

// MARK: - 1. Toolbar

struct TextEditToolbar: View {
    @Binding var isBold: Bool
    @Binding var isItalic: Bool
    @Binding var isUnderlined: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Font Picker
            HStack(spacing: 4) {
                Text("Helvetica")
                    .font(.system(size: 11))
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 9))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.white)
            .cornerRadius(4)
            .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            
            // Typeface Toggle
            HStack(spacing: 2) {
                ToolbarToggle(icon: "bold", isActive: $isBold)
                ToolbarToggle(icon: "italic", isActive: $isItalic)
                ToolbarToggle(icon: "underline", isActive: $isUnderlined)
            }
            .background(Color.white.opacity(0.5))
            .cornerRadius(4)
            
            Divider().frame(height: 16)
            
            // Alignment
            HStack(spacing: 2) {
                ToolbarButton(icon: "text.alignleft", active: true)
                ToolbarButton(icon: "text.aligncenter", active: false)
                ToolbarButton(icon: "text.alignright", active: false)
                ToolbarButton(icon: "text.justify", active: false)
            }
            
            Divider().frame(height: 16)
            
            // Spacing / Color
            HStack(spacing: 12) {
                Image(systemName: "arrow.up.and.down.text.horizontal")
                
                // Color Well
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 24, height: 14)
                    .border(Color.gray.opacity(0.5), width: 1)
            }
            .font(.system(size: 12))
            .foregroundColor(.gray)
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(height: 36)
    }
}

struct ToolbarToggle: View {
    let icon: String
    @Binding var isActive: Bool
    
    var body: some View {
        Button(action: { isActive.toggle() }) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .frame(width: 24, height: 22)
                .background(isActive ? Color.blue.opacity(0.15) : Color.clear)
                .foregroundColor(isActive ? .blue : .primary)
                .cornerRadius(3)
        }
        .buttonStyle(.plain)
    }
}

struct ToolbarButton: View {
    let icon: String
    let active: Bool
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .frame(width: 24, height: 22)
                .background(active ? Color.black.opacity(0.1) : Color.clear)
                .foregroundColor(.primary)
                .cornerRadius(3)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 2. Ruler View

struct RulerView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Left Margin (matches paper padding)
                Color.clear.frame(width: 50)
                
                // The Ruler content
                GeometryReader { geo in
                    ZStack(alignment: .bottomLeading) {
                        // Ticks
                        HStack(spacing: 0) {
                            ForEach(0..<10) { i in
                                RulerSegment()
                                    .frame(width: 60) // 1 inch approx
                            }
                        }
                        
                        // Numbers
                        HStack(spacing: 0) {
                            ForEach(1..<10) { i in
                                Text("\(i)")
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(.gray)
                                    .frame(width: 60, alignment: .leading)
                                    .offset(x: 58) // Offset to align number with the inch mark
                            }
                        }
                        .offset(y: -8)
                        
                        // Margin Markers
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.blue)
                            .offset(y: -12)
                        
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.blue)
                            .offset(x: 0, y: 2)
                        
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.blue)
                            .offset(x: 400, y: 2) // Trailing margin
                    }
                }
            }
            .frame(height: 24)
            .background(Color.white)
        }
    }
}

struct RulerSegment: View {
    var body: some View {
        HStack(spacing: 0) {
            // Major tick (Start of inch)
            Rectangle().fill(Color.gray.opacity(0.5)).frame(width: 1, height: 10)
            Spacer()
            // 1/8
            Rectangle().fill(Color.gray.opacity(0.5)).frame(width: 1, height: 4)
            Spacer()
            // 1/4
            Rectangle().fill(Color.gray.opacity(0.5)).frame(width: 1, height: 6)
            Spacer()
            // 3/8
            Rectangle().fill(Color.gray.opacity(0.5)).frame(width: 1, height: 4)
            Spacer()
            // 1/2
            Rectangle().fill(Color.gray.opacity(0.5)).frame(width: 1, height: 8)
            Spacer()
            // 5/8
            Rectangle().fill(Color.gray.opacity(0.5)).frame(width: 1, height: 4)
            Spacer()
            // 3/4
            Rectangle().fill(Color.gray.opacity(0.5)).frame(width: 1, height: 6)
            Spacer()
            // 7/8
            Rectangle().fill(Color.gray.opacity(0.5)).frame(width: 1, height: 4)
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    TextEditApp()
        .frame(width: 800, height: 350)
}
