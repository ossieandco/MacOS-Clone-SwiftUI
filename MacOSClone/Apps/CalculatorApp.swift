import SwiftUI

struct CalculatorApp: View {
    let buttons: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        VStack(spacing: 1) {
            
            HStack {
                Spacer()
                Text("0")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.black)
            
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {}) {
                            Text(button)
                                .font(.title)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(self.buttonColor(button))
                                .foregroundColor(.white)
                        }
                        .frame(height: 60)
                    }
                }
            }
        }
        .background(Color.black)
    }
    
    func buttonColor(_ button: String) -> Color {
        if button == "÷" || button == "×" || button == "-" || button == "+" || button == "=" {
            return .orange
        } else if button == "AC" || button == "+/-" || button == "%" {
            return .gray
        } else {
            return Color(UIColor.darkGray)
        }
    }
}
