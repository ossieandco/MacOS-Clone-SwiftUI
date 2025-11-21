import SwiftUI

// MARK: - Main App View

struct FinalCutProApp: View {
    @State private var timecode: String = "00:00:14:08"
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. Toolbar
            FCPToolbar(timecode: timecode)
            
            Divider().background(Color.black)
            
            // 2. Top Section (Browser | Viewer | Inspector)
            GeometryReader { geo in
                HStack(spacing: 0) {
                    // Library / Browser
                    BrowserView()
                        .frame(width: geo.size.width * 0.3)
                    
                    Divider().background(Color.black)
                    
                    // Viewer
                    ViewerView()
                        .frame(width: geo.size.width * 0.45)
                    
                    Divider().background(Color.black)
                    
                    // Inspector
                    InspectorPanel()
                        .frame(width: geo.size.width * 0.25)
                }
            }
            .frame(height: 350)
            
            // 3. Middle Bar (Tools)
            TimelineToolsBar()
            
            Divider().background(Color.black)
            
            // 4. Timeline
            TimelineView()
        }
        .background(FCPColors.bgDark)
        .preferredColorScheme(.dark)
    }
}

// MARK: - 4. Inspector

struct InspectorPanel: View {
    var body: some View {
        VStack(spacing: 0) {
            // Tabs
            HStack {
                Image(systemName: "film.fill").foregroundColor(.blue)
                Spacer()
                Image(systemName: "paintbrush.fill").foregroundColor(.gray)
                Spacer()
                Image(systemName: "speaker.wave.2.fill").foregroundColor(.gray)
                Spacer()
                Image(systemName: "info.circle.fill").foregroundColor(.gray)
            }
            .padding(10)
            .font(.system(size: 12))
            .background(FCPColors.headerGray)
            
            Divider().background(Color.black)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // FIX: Now allows multiple views inside the closure
                    InspectorSection(title: "Transform", expanded: true) {
                        InspectorSlider(label: "Position X")
                        InspectorSlider(label: "Position Y")
                        InspectorSlider(label: "Scale (All)")
                        InspectorSlider(label: "Rotation")
                    }
                    
                    Divider().background(Color.black)
                    
                    InspectorSection(title: "Crop", expanded: false) {
                        EmptyView()
                    }
                    
                    Divider().background(Color.black)
                    
                    InspectorSection(title: "Distort", expanded: false) {
                        EmptyView()
                    }
                    
                    Divider().background(Color.black)
                    
                    InspectorSection(title: "Compositing", expanded: true) {
                        HStack {
                            Text("Blend Mode").font(.caption).foregroundColor(.gray)
                            Spacer()
                            Text("Normal").font(.caption).foregroundColor(.white)
                        }
                        InspectorSlider(label: "Opacity", value: 1.0)
                    }
                }
            }
        }
        .background(FCPColors.panelGray)
    }
}

// MARK: - Inspector Section (Fixed with @ViewBuilder)

struct InspectorSection<Content: View>: View {
    let title: String
    let expanded: Bool
    let content: Content
    
    // FIX: Added @ViewBuilder here to support multiple views in the closure
    init(title: String, expanded: Bool, @ViewBuilder content: () -> Content) {
        self.title = title
        self.expanded = expanded
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(white: 0.8))
                Spacer()
                if expanded { Text("Show").font(.caption2).foregroundColor(.blue).opacity(0) }
                Text(expanded ? "Hide" : "Show").font(.caption2).foregroundColor(.blue)
            }
            .padding(.top, 8)
            .padding(.horizontal, 10)
            
            if expanded {
                VStack(spacing: 10) {
                    content
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.02))
    }
}

struct InspectorSlider: View {
    let label: String
    var value: CGFloat = 0.5
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
                .frame(width: 60, alignment: .trailing)
            
            ZStack(alignment: .leading) {
                Capsule().fill(Color.black).frame(height: 4)
                Capsule().fill(Color.gray).frame(width: 80 * value, height: 4)
                Circle().fill(Color.white).frame(width: 10, height: 10)
                    .offset(x: 80 * value - 5)
            }
            
            Spacer()
            
            Text("0.0")
                .font(.caption2)
                .monospacedDigit()
                .foregroundColor(.gray)
        }
    }
}

// MARK: - 1. Toolbar

struct FCPToolbar: View {
    let timecode: String
    
    var body: some View {
        HStack(spacing: 15) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.down.doc")
                Image(systemName: "sidebar.left")
            }
            .foregroundColor(.white)
            .font(.system(size: 14))
            .padding(.leading, 70)
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("Summer Vlog 2025")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(timecode)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(4)
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Text("54%")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2).frame(width: 18, height: 18))
                
                Image(systemName: "square.and.arrow.up")
                Image(systemName: "list.bullet.indent")
            }
            .font(.system(size: 14))
            .foregroundColor(.white)
            .padding(.trailing, 15)
        }
        .frame(height: 42)
        .background(FCPColors.panelGray)
    }
}

// MARK: - 2. Browser

struct BrowserView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption)
                Text("Smart Collections").font(.caption).bold()
                Spacer()
            }
            .padding(8)
            .background(FCPColors.headerGray)
            
            VStack(alignment: .leading, spacing: 0) {
                BrowserRow(icon: "folder.fill", color: .blue, text: "All Video")
                BrowserRow(icon: "speaker.wave.2.fill", color: .green, text: "Audio Only")
                BrowserRow(icon: "heart.fill", color: .red, text: "Favorites")
                BrowserRow(icon: "camera.fill", color: .purple, text: "Stills")
                Divider().background(Color.black).padding(.vertical, 5)
                Text("2025 Events").font(.caption).foregroundColor(.gray).padding(.leading, 8).padding(.bottom, 5)
                BrowserRow(icon: "star.square.fill", color: .purple, text: "Beach Trip", isSelected: true)
                BrowserRow(icon: "star.square.fill", color: .purple, text: "City Walk")
                Spacer()
            }
            .padding(.top, 5)
            
            Divider().background(Color.black)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                    ForEach(1...8, id: \.self) { i in
                        VStack(spacing: 4) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .aspectRatio(16/9, contentMode: .fit)
                                .overlay(Image(systemName: "film").foregroundColor(.gray))
                                .cornerRadius(4)
                                .overlay(HStack(spacing: 2) { ForEach(0..<5) { _ in Rectangle().fill(Color.black.opacity(0.5)).frame(width: 1); Spacer() } })
                            Text("C00\(i).MOV").font(.system(size: 9)).foregroundColor(.white).lineLimit(1)
                        }
                    }
                }
                .padding(10)
            }
            .background(FCPColors.darkerGray)
        }
        .background(FCPColors.panelGray)
    }
}

struct BrowserRow: View {
    let icon: String
    let color: Color
    let text: String
    var isSelected: Bool = false
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.caption).foregroundColor(color)
            Text(text).font(.caption).foregroundColor(isSelected ? .white : .gray)
            Spacer()
        }
        .padding(.horizontal, 10).padding(.vertical, 4)
        .background(isSelected ? Color.blue.opacity(0.5) : Color.clear)
    }
}

// MARK: - 3. Viewer

struct ViewerView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color.black
                LinearGradient(colors: [.blue.opacity(0.2), .purple.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing).padding(20)
                Text("Viewer").font(.headline).foregroundColor(.gray.opacity(0.5))
                Rectangle().stroke(Color.yellow.opacity(0.3), lineWidth: 1).padding(40)
                VStack {
                    HStack { Handle(); Spacer(); Handle() }
                    Spacer()
                    HStack { Handle(); Spacer(); Handle() }
                }.padding(20)
            }.clipped()
            HStack(spacing: 20) {
                Group { Image(systemName: "backward.end.fill"); Image(systemName: "play.fill"); Image(systemName: "forward.end.fill") }
                    .font(.system(size: 14)).foregroundColor(.white)
                Spacer()
                HStack(spacing: 10) {
                    Text("00:00:14:08").font(.system(size: 12, design: .monospaced)).foregroundColor(.white)
                    HStack(spacing: 2) { ForEach(0..<2) { _ in VStack(spacing: 1) { Rectangle().fill(Color.red).frame(height: 4); Rectangle().fill(Color.yellow).frame(height: 4); Rectangle().fill(Color.green).frame(height: 12) }.frame(width: 4) } }
                }
            }.padding(.horizontal, 15).frame(height: 36).background(FCPColors.headerGray)
        }
    }
}

struct Handle: View { var body: some View { Circle().fill(Color.blue).frame(width: 8, height: 8).overlay(Circle().stroke(Color.white, lineWidth: 1)) } }

// MARK: - 5. Timeline Tools

struct TimelineToolsBar: View {
    var body: some View {
        HStack(spacing: 15) {
            HStack(spacing: 0) { Text("Index").font(.caption).padding(.horizontal, 8); Image(systemName: "tag.fill").font(.caption) }.padding(4)
            Spacer()
            HStack(spacing: 20) { Image(systemName: "arrow.turn.up.right").foregroundColor(.white); Image(systemName: "arrow.uturn.down").foregroundColor(.white); Image(systemName: "arrow.append").foregroundColor(.blue) }
            Divider().frame(height: 20)
            HStack(spacing: 20) { Image(systemName: "cursorarrow").foregroundColor(.white); Image(systemName: "scissors").foregroundColor(.gray); Image(systemName: "square.dashed").foregroundColor(.gray); Image(systemName: "hand.draw").foregroundColor(.gray) }
            Spacer()
            HStack(spacing: 15) { Image(systemName: "headphones"); Image(systemName: "bolt.fill").foregroundColor(.blue) }.font(.caption).foregroundColor(.white).padding(.trailing, 10)
        }.frame(height: 32).background(FCPColors.bgDark)
    }
}

// MARK: - 6. Timeline

struct TimelineView: View {
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0..<20) { i in
                            VStack(alignment: .leading, spacing: 2) {
                                Text("00:00:\(String(format: "%02d", i * 10))").font(.system(size: 9, design: .monospaced)).foregroundColor(.gray).padding(.leading, 2)
                                HStack(spacing: 4) { Rectangle().frame(width: 1, height: 8); ForEach(0..<9) { _ in Rectangle().frame(width: 1, height: 4).opacity(0.3); Spacer() } }.foregroundColor(.gray)
                            }.frame(width: 100)
                        }
                    }.frame(height: 24).background(FCPColors.headerGray)
                    Divider().background(Color.black)
                    ZStack(alignment: .leading) {
                        Color(hex: "121212").frame(height: 300)
                        Rectangle().fill(Color.black.opacity(0.3)).frame(height: 1).offset(y: 100)
                        HStack(spacing: 2) { TimelineClip(name: "Intro_Vlog", duration: 120, color: .blue); TimelineClip(name: "B-Roll_Beach", duration: 80, color: .blue); TimelineClip(name: "Interview_A", duration: 200, color: .blue); TimelineClip(name: "B-Roll_City", duration: 90, color: .blue); TimelineClip(name: "Outro", duration: 150, color: .blue) }.padding(.leading, 50).offset(y: 80)
                        HStack(spacing: 0) { TimelineClip(name: "Background_Music.mp3", duration: 400, color: .green); TimelineClip(name: "SFX_Swoosh", duration: 30, color: .teal) }.padding(.leading, 50).offset(y: 135)
                        HStack(spacing: 0) { TimelineClip(name: "Lower_Third", duration: 100, color: .purple) }.padding(.leading, 250).offset(y: 35)
                        Rectangle().fill(Color.red).frame(width: 1, height: 300).overlay(Image(systemName: "arrowtriangle.down.fill").font(.caption2).foregroundColor(.red).offset(y: -150)).offset(x: 320)
                    }
                }
            }.frame(minWidth: 2000)
        }.background(FCPColors.darkerGray)
    }
}

struct TimelineClip: View {
    let name: String; let duration: CGFloat; let color: Color
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 4).fill(color.opacity(0.8)).overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.black.opacity(0.5), lineWidth: 1)).overlay(VStack { Spacer(); Rectangle().fill(Color.black.opacity(0.3)).frame(height: 15) })
            Text(name).font(.system(size: 10, weight: .medium)).foregroundColor(.white).shadow(radius: 1).padding(4).frame(maxHeight: .infinity, alignment: .topLeading)
        }.frame(width: duration, height: 50)
    }
}

// MARK: - Colors & Helpers

struct FCPColors {
    static let bgDark = Color(hex: "1E1E1E")
    static let panelGray = Color(hex: "262626")
    static let headerGray = Color(hex: "1D1D1D")
    static let darkerGray = Color(hex: "121212")
}

#Preview {
    FinalCutProApp()
}
