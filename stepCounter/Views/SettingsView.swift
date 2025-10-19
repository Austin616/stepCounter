import SwiftUI

struct SettingsView: View {
    @AppStorage("stepGoal") private var stepGoal: Int = 10000
    @State private var tempGoal: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Daily Goal")) {
                    TextField("Step Goal", text: $tempGoal)
                        .keyboardType(.numberPad)
                        .focused($isTextFieldFocused)
                }
                
                Section {
                    Text("Current goal: \(stepGoal) steps")
                        .foregroundColor(.secondary)
                }
                
                Section {
                    Button("Save Goal") {
                        isTextFieldFocused = false
                        if let newGoal = Int(tempGoal), newGoal > 0 {
                            stepGoal = newGoal
                            dismiss()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                tempGoal = String(stepGoal)
            }
        }
    }
}
