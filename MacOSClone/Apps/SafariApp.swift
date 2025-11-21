import SwiftUI
import WebKit
import Combine

// MARK: - Data Model
class SafariViewModel: ObservableObject {
    @Published var urlString: String = "https://www.apple.com"
    @Published var isLoading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    @Published var progress: Double = 0.0
    
    // References to control the WebView
    let webView: WKWebView
    
    init() {
        self.webView = WKWebView()
    }
    
    func loadUrl() {
        var formatted = urlString
        if !formatted.lowercased().hasPrefix("http") {
            formatted = "https://" + formatted
        }
        
        if let url = URL(string: formatted) {
            webView.load(URLRequest(url: url))
        }
    }
    
    func goBack() { webView.goBack() }
    func goForward() { webView.goForward() }
    func reload() { webView.reload() }
}

// MARK: - Main View
struct SafariApp: View {
    @StateObject private var model = SafariViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // 1. Unified Toolbar
            SafariToolbar(model: model)
            
            Divider()
            
            // 2. Web Content
            ZStack(alignment: .top) {
                SafariWebView(model: model)
                
                // Loading Progress Bar
                if model.isLoading {
                    GeometryReader { geo in
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: geo.size.width * model.progress, height: 2)
                            .animation(.linear, value: model.progress)
                    }
                    .frame(height: 2)
                }
            }
        }
        .background(Color(hex: "F6F6F6"))
        .onAppear {
            model.loadUrl()
        }
    }
}

// MARK: - Toolbar View
struct SafariToolbar: View {
    @ObservedObject var model: SafariViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Traffic Light Spacing
            Color.clear.frame(width: 60)
            
            // Sidebar Toggle
            Button(action: {}) {
                Image(systemName: "sidebar.left")
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
            }
            .buttonStyle(.plain)
            
            // Navigation
            HStack(spacing: 20) {
                Button(action: model.goBack) {
                    Image(systemName: "chevron.left")
                }
                .disabled(!model.canGoBack)
                .foregroundColor(model.canGoBack ? .primary : .gray.opacity(0.5))
                
                Button(action: model.goForward) {
                    Image(systemName: "chevron.right")
                }
                .disabled(!model.canGoForward)
                .foregroundColor(model.canGoForward ? .primary : .gray.opacity(0.5))
            }
            .font(.system(size: 14, weight: .medium))
            
            // Address Bar
            HStack {
                Image(systemName: "shield.fill")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                
                TextField("Search or enter website name", text: $model.urlString, onCommit: {
                    model.loadUrl()
                })
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 13))
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                
                if model.isLoading {
                    Image(systemName: "xmark")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .onTapGesture { model.webView.stopLoading() }
                } else {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .onTapGesture { model.reload() }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(8)
            .frame(maxWidth: 600) // Max width for address bar
            
            Spacer()
            
            // Right Actions
            HStack(spacing: 15) {
                Image(systemName: "square.and.arrow.up")
                Image(systemName: "plus")
                Image(systemName: "square.on.square")
            }
            .font(.system(size: 14))
            .foregroundColor(.primary)
            .padding(.trailing, 15)
        }
        .padding(.vertical, 10)
        .frame(height: 52)
        .background(Color(hex: "F6F6F6")) // Standard macOS window bg
    }
}

// MARK: - WebView Wrapper
struct SafariWebView: UIViewRepresentable {
    @ObservedObject var model: SafariViewModel
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = model.webView
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // State is managed by the model's persistence of the WKWebView instance
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(model)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var model: SafariViewModel
        var progressObservation: NSKeyValueObservation?
        
        init(_ model: SafariViewModel) {
            self.model = model
            super.init()
            
            // Observe Progress
            progressObservation = model.webView.observe(\.estimatedProgress, options: .new) { _, change in
                if let value = change.newValue {
                    DispatchQueue.main.async {
                        self.model.progress = value
                    }
                }
            }
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async { self.model.isLoading = true }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.model.isLoading = false
                self.model.canGoBack = webView.canGoBack
                self.model.canGoForward = webView.canGoForward
                if let url = webView.url?.absoluteString {
                    self.model.urlString = url
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async { self.model.isLoading = false }
        }
    }
}

#Preview {
    SafariApp()
        .frame(width: 800, height: 380)
}
