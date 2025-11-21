import SwiftUI

struct SettingsApp: View {
    @State private var selection: String? = "General"
    
    var body: some View {
        HStack(spacing: 0) {
            // 1. Sidebar
            SettingsSidebar(selection: $selection)
                .frame(width: 220)
            
            Divider()
            
            // 2. Content Pane
            SettingsContent(selection: selection)
        }
        .background(Color(hex: "F6F6F6")) // Standard Window BG
    }
}

// MARK: - 1. Sidebar

struct SettingsSidebar: View {
    @Binding var selection: String?
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                Text("Search")
                    .foregroundColor(.gray.opacity(0.7))
                Spacer()
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(6)
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.2), lineWidth: 1))
            .padding(10)
            
            // Apple ID Banner
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("John Appleseed")
                        .font(.system(size: 13, weight: .semibold))
                    Text("Apple ID")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
            
            // List
            ScrollView {
                VStack(spacing: 2) {
                    Group {
                        SettingsRow(icon: "wifi", color: .blue, title: "Wi-Fi", selection: $selection)
                        SettingsRow(icon: "dot.radiowaves.left.and.right", color: .blue, title: "Bluetooth", selection: $selection)
                        SettingsRow(icon: "globe", color: .blue, title: "Network", selection: $selection)
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Group {
                        SettingsRow(icon: "bell.badge.fill", color: .red, title: "Notifications", selection: $selection)
                        SettingsRow(icon: "speaker.wave.2.fill", color: .pink, title: "Sound", selection: $selection)
                        SettingsRow(icon: "moon.fill", color: .indigo, title: "Focus", selection: $selection)
                        SettingsRow(icon: "hourglass", color: .purple, title: "Screen Time", selection: $selection)
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Group {
                        SettingsRow(icon: "gear", color: .gray, title: "General", selection: $selection)
                        SettingsRow(icon: "paintbrush.fill", color: .blue, title: "Appearance", selection: $selection)
                        SettingsRow(icon: "accessibility", color: .blue, title: "Accessibility", selection: $selection)
                        SettingsRow(icon: "switch.2", color: .gray, title: "Control Center", selection: $selection)
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Group {
                        SettingsRow(icon: "display", color: .blue, title: "Displays", selection: $selection)
                        SettingsRow(icon: "photo.fill", color: .cyan, title: "Wallpaper", selection: $selection)
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .background(Color(hex: "F0F0F0")) // Sidebar is slightly darker/translucent usually
    }
}

struct SettingsRow: View {
    let icon: String
    let color: Color
    let title: String
    @Binding var selection: String?
    
    var isSelected: Bool {
        selection == title
    }
    
    var body: some View {
        Button(action: { selection = title }) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .padding(4)
                    .background(color)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(isSelected ? Color.blue : Color.clear)
            .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 2. Content Pane

struct SettingsContent: View {
    let selection: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text(selection ?? "Settings")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding(20)
            
            ScrollView {
                VStack(spacing: 20) {
                    if selection == "General" {
                        GeneralSettingsView()
                    } else if selection == "Wi-Fi" {
                        WiFiSettingsView()
                    } else if selection == "Appearance" {
                        AppearanceSettingsView()
                    } else {
                        Text("Settings for \(selection ?? "")")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, minHeight: 300)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .background(Color(hex: "F6F6F6"))
    }
}

// MARK: - Detail Views

struct GeneralSettingsView: View {
    var body: some View {
        VStack(spacing: 10) {
            SettingsGroup {
                SettingsDetailRow(label: "About", value: "", hasChevron: true)
                Divider()
                SettingsDetailRow(label: "Software Update", value: "", hasChevron: true)
            }
            
            SettingsGroup {
                SettingsDetailRow(label: "Storage", value: "", hasChevron: true)
            }
            
            SettingsGroup {
                SettingsDetailRow(label: "AirDrop & Handoff", value: "", hasChevron: true)
                Divider()
                SettingsDetailRow(label: "Login Items", value: "", hasChevron: true)
            }
        }
    }
}

struct WiFiSettingsView: View {
    @State private var wifiOn = true
    
    var body: some View {
        VStack(spacing: 20) {
            SettingsGroup {
                HStack {
                    Text("Wi-Fi")
                        .font(.system(size: 13, weight: .medium))
                    Spacer()
                    Toggle("", isOn: $wifiOn)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                .padding(10)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Known Networks")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                SettingsGroup {
                    SettingsDetailRow(label: "Home Wi-Fi", value: "Connected", hasChevron: true, icon: "wifi")
                    Divider()
                    SettingsDetailRow(label: "Office 5G", value: "", hasChevron: true, icon: "wifi")
                    Divider()
                    SettingsDetailRow(label: "Starbucks", value: "", hasChevron: true, icon: "wifi")
                }
            }
        }
    }
}

struct AppearanceSettingsView: View {
    @State private var mode = 0
    @State private var accentColor = 0
    
    var body: some View {
        VStack(spacing: 20) {
            SettingsGroup {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Appearance")
                        .font(.system(size: 13, weight: .medium))
                    
                    HStack(spacing: 15) {
                        AppearanceOption(title: "Light", icon: "sun.max.fill", selected: mode == 0)
                            .onTapGesture { mode = 0 }
                        AppearanceOption(title: "Dark", icon: "moon.fill", selected: mode == 1)
                            .onTapGesture { mode = 1 }
                        AppearanceOption(title: "Auto", icon: "circle.lefthalf.filled", selected: mode == 2)
                            .onTapGesture { mode = 2 }
                    }
                }
                .padding(10)
            }
            
            SettingsGroup {
                HStack {
                    Text("Accent Color")
                        .font(.system(size: 13, weight: .medium))
                    Spacer()
                    HStack(spacing: 8) {
                        Circle().fill(Color.blue).frame(width: 14)
                        Circle().fill(Color.purple).frame(width: 14)
                        Circle().fill(Color.pink).frame(width: 14)
                        Circle().fill(Color.red).frame(width: 14)
                        Circle().fill(Color.orange).frame(width: 14)
                        Circle().fill(Color.yellow).frame(width: 14)
                        Circle().fill(Color.green).frame(width: 14)
                        Circle().fill(Color.gray).frame(width: 14)
                    }
                }
                .padding(10)
            }
        }
    }
}

struct AppearanceOption: View {
    let title: String
    let icon: String
    let selected: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .frame(width: 50, height: 35)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(selected ? Color.gray.opacity(0.5) : Color.clear, lineWidth: 2)
                )
            Text(title)
                .font(.caption)
        }
    }
}

// MARK: - Helper Components

struct SettingsGroup<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

struct SettingsDetailRow: View {
    let label: String
    let value: String
    let hasChevron: Bool
    var icon: String? = nil
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .frame(width: 16)
                    .foregroundColor(.blue)
            }
            Text(label)
                .font(.system(size: 13))
            Spacer()
            Text(value)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            if hasChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .padding(10)
        .contentShape(Rectangle())
    }
}

#Preview {
    SettingsApp()
        .frame(width: 700, height: 500)
}
