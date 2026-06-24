//
//  TimeTravelView.swift
//  MyDates
//
//  Created by Jin on 6/23/26.
//

import SwiftUI

/// Lets the user pick a virtual "now" so every countdown in the list reflects
/// how it would look at a different point in time. Passing `nil` back returns
/// the app to the real, live clock.
struct TimeTravelView: View {
    @Binding var travelDate: Date?
    @Environment(\.dismiss) private var dismiss

    // Working copy edited in the sheet; committed to `travelDate` on "Travel".
    @State private var workingDate: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section("Travel to") {
                    DatePicker(
                        "Date & time",
                        selection: $workingDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }

                Section("Quick jump") {
                    HStack {
                        jumpButton("-1y", days: -365)
                        jumpButton("-1w", days: -7)
//                        jumpButton("-1d", days: -1)
//                        jumpButton("+1d", days: 1)
                        jumpButton("+1w", days: 7)
                        jumpButton("+1m", days: 30)
                        jumpButton("+1y", days: 365)
                    }
                }

                Section {
                    Button {
                        travelDate = workingDate
                        dismiss()
                    } label: {
                        Label("Travel", systemImage: "clock.arrow.circlepath")
                    }

                    if travelDate != nil {
                        Button(role: .destructive) {
                            travelDate = nil
                            dismiss()
                        } label: {
                            Label("Return to Now", systemImage: "clock")
                        }
                    }
                }
            }
            .navigationTitle("Time Travel")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                workingDate = travelDate ?? Date()
            }
        }
    }

    private func jumpButton(_ label: String, days: Int) -> some View {
        Button(label) {
            workingDate = Calendar.current.date(byAdding: .day, value: days, to: workingDate) ?? workingDate
        }
        .buttonStyle(.bordered)
        .font(.footnote)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TimeTravelView(travelDate: .constant(nil))
}
