//
//  EditProjectView.swift
//  TD Portfolio
//
//  Created by thomas on 05/12/2020.
//

import CoreHaptics
import SwiftUI

struct EditProjectView: View {
    @ObservedObject var project: Project

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    @State private var showingDeleteConfirm = false
    @State private var showingNotificationsError = false

    @State private var remindMe: Bool
    @State private var reminderTime: Date

    @State private var engine = try? CHHapticEngine()

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project
        _title = State(initialValue: project.projectTitle)
        _detail = State(initialValue: project.projectDetail)
        _color = State(initialValue: project.projectColor)

        if let projectReminderTime = project.reminderTime {
            _reminderTime = State(initialValue: projectReminderTime)
            _remindMe = State(initialValue: true)
        } else {
            _reminderTime = State(initialValue: Date())
            _remindMe = State(initialValue: false)
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }

            Section(header: Text("Project reminders")) {
                Toggle("Show reminders", isOn: $remindMe.animation().onChange(update))
                    .alert(isPresented: $showingNotificationsError, content: {
                        Alert(
                            title: Text("Oh no!"),
                            message: Text("Oh no no no no no. Check your notifications settings, mate."),
                            primaryButton: .default(Text("Check Settings"), action: showAppSettings),
                            secondaryButton: .cancel()
                        )
                    })
                if remindMe {
                    DatePicker(
                        "Reminder time",
                        selection: $reminderTime.onChange(update),
                        displayedComponents: .hourAndMinute
                    )
                }
            }

            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project entirely.")) {
                Button(project.closed ? "Reopen this project" : "Close this project", action: toggleClosed)
                Button("Delete this project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: {
            dataController.save()
        })
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete project?"),
                message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."), // swiftlint:disable:this line_length
                primaryButton: .default(Text("Delete"),
                action: delete),
                secondaryButton: .cancel()
            )
        }
    }

    func update() {
        project.title = title
        project.detail = detail
        project.color = color

        if remindMe {
            project.reminderTime = reminderTime

            dataController.addReminders(for: project) { success in
                if success == false {
                    project.reminderTime = nil
                    remindMe = false

                    showingNotificationsError = true
                }
            }
        } else {
            project.reminderTime = nil
            dataController.removeReminders(for: project)
        }
    }

    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }

    func toggleClosed() {
        project.closed.toggle()
        if project.closed {
            do {
                try engine?.start()

                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                let intencity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)
                let parameter = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start, end],
                    relativeTime: 0
                )
                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intencity, sharpness],
                    relativeTime: 0
                )
                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [sharpness, intencity],
                    relativeTime: 0.125,
                    duration: 1
                )
                let pattern = try CHHapticPattern(
                    events: [event1, event2],
                    parameterCurves: [parameter]
                )
                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)

            } catch {
                // playing haptic didn't work, but no problem!
            }
        }
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fill)
                .cornerRadius(6)
            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
                ? [.isButton, .isSelected]
                : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
