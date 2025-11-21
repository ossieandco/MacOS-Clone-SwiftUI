import SwiftUI

struct WindowView<Content: View>: View {
    @Binding var windowState: WindowState
    let content: Content
    let onClose: () -> Void
    let onFocus: () -> Void
    
    @GestureState private var dragOffset: CGSize = .zero

    init(windowState: Binding<WindowState>, onClose: @escaping () -> Void, onFocus: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self._windowState = windowState
        self.onClose = onClose
        self.onFocus = onFocus
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            // Content
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
                .padding(.top, 28) // Push content down for title bar
                .onTapGesture {
                    onFocus()
                }
            
            // Title Bar
            HStack(spacing: 10) {
                HStack(spacing: 8) {
                    CircleButton(color: .red, action: onClose)
                    CircleButton(color: .yellow, action: {}) // Minimize
                    CircleButton(color: .green, action: {}) // Maximize
                }
                .padding(.leading, 10)
                
                Spacer()
                
                Text(windowState.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color.primary.opacity(0.8))
                
                Spacer()
                
                // Spacer to balance the buttons
                Spacer().frame(width: 60)
            }
            .frame(height: 28)
            .background(Color(UIColor.secondarySystemBackground).opacity(0.95))
            .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterial)))
            .gesture(
                DragGesture(coordinateSpace: .named("desktop"))
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded { value in
                        let newX = windowState.position.x + value.translation.width
                        let newY = windowState.position.y + value.translation.height
                        windowState.position = CGPoint(x: newX, y: newY)
                        onFocus() // Bring to front after drag ends to ensure z-order
                    }
            )
            .onTapGesture {
                onFocus()
            }
        }
        .frame(width: windowState.size.width, height: windowState.size.height)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        // Important: SwiftUI's .position places the CENTER of the view at the given point.
        // We want windowState.position to represent the TOP-LEFT corner.
        // So we must offset the center by half the size.
        .position(
            x: windowState.position.x + windowState.size.width / 2 + dragOffset.width,
            y: windowState.position.y + windowState.size.height / 2 + dragOffset.height
        )
        .ignoresSafeArea()
        .environment(\.colorScheme, windowState.appType.preferredColorScheme)
    }
}

struct CircleButton: View {
    let color: Color
    let action: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 12, height: 12)
            .overlay(
                Image(systemName: "xmark") // Placeholder for symbols
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.black.opacity(0.5))
                    .opacity(isHovering ? 1 : 0)
            )
            .onTapGesture(perform: action)
    }
}

// Helper for Blur
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

// Mock NSColor for iOS
extension Color {
    init(_ nsColor: UIColor) {
        self.init(uiColor: nsColor)
    }
}

extension UIColor {
    static var windowBackgroundColor: UIColor {
        return UIColor.secondarySystemBackground
    }
}
