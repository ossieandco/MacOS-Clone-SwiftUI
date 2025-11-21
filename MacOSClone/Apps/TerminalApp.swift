import SwiftUI

struct TerminalApp: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Last login: \(Date().formatted()) on ttys000")
            Text("user@MacBook-Pro ~ %") + Text(" ").font(.system(size: 14))
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.black)
        .foregroundColor(.white)
        .font(.system(.body, design: .monospaced))
    }
}
