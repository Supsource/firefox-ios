// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import SwiftUI
import Shared

// MARK: - AddressAutofillToggle

/// A SwiftUI view representing a toggle with theming for address autofill functionality.
struct AddressAutofillToggle: View {
    let windowUUID: WindowUUID

    // MARK: - Theming

    /// The theme manager provided by the environment.
    @Environment(\.themeManager)
    var themeManager

    /// Text color for the view.
    @State private var textColor: Color = .clear

    /// Description text color for the view.
    @State private var descriptionTextColor: Color = .clear

    /// Background color for the view.
    @State private var backgroundColor: Color = .clear

    /// Toggle tint color for the view.
    @State private var toggleTintColor: Color = .clear

    /// Observed object representing the toggle state.
    @ObservedObject var model: ToggleModel

    // MARK: - Body

    var body: some View {
        VStack {
            // Divider line to separate content (hidden by default)
            Divider()
                .frame(height: 0.7)
                .padding(.leading, 16)
                .hidden()

            // Horizontal stack containing title, description, and toggle
            HStack {
                // Left-aligned stack for title and description
                VStack(alignment: .leading) {
                    // Title for the Toggle
                    Text(String.Addresses.Settings.SwitchTitle)
                        .font(.body)
                        .foregroundColor(textColor)

                    // Description for the Toggle
                    Text(String.Addresses.Settings.SwitchDescription)
                        .font(.footnote)
                        .foregroundColor(descriptionTextColor)
                }
                .padding(.leading, 16)

                Spacer()

                // Toggle switch
                Toggle(isOn: $model.isEnabled) {
                    EmptyView()
                }
                .padding(.trailing, 16)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: toggleTintColor))
                .frame(alignment: .trailing)
            }
            .accessibilityElement()
            .accessibilityLabel("\(String.Addresses.Settings.SwitchTitle), \(String.Addresses.Settings.SwitchDescription)")
            .accessibilityAction {
                model.isEnabled = !model.isEnabled
            }

            // Divider line to separate content
            Divider()
                .frame(height: 0.7)
                .padding(.leading, 16)
        }
        .background(backgroundColor)
        .onAppear {
            // Apply theme when the view appears
            applyTheme(theme: themeManager.currentTheme(for: windowUUID))
        }
        .onReceive(NotificationCenter.default.publisher(for: .ThemeDidChange)) { notification in
            guard let uuid = notification.object as? UUID, uuid == windowUUID else { return }
            applyTheme(theme: themeManager.currentTheme(for: windowUUID))
        }
    }

    // MARK: - Theme Application

    /// Apply the specified theme to the view's colors.
    func applyTheme(theme: Theme) {
        let color = theme.colors
        textColor = Color(color.textPrimary)
        descriptionTextColor = Color(color.textSecondary)
        backgroundColor = Color(color.layer2)
        toggleTintColor = Color(color.actionPrimary)
    }
}

// MARK: - AutofillToggle_Previews

/// A preview provider for the AddressAutofillToggle.
struct AutofillToggle_Previews: PreviewProvider {
    static var previews: some View {
        let model = ToggleModel(isEnabled: true)
        AddressAutofillToggle(windowUUID: .XCTestDefaultUUID, model: model)
    }
}
