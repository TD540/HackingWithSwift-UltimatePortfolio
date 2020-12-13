//
//  EditProjectView.swift
//  Again
//
//  Created by thomas on 05/12/2020.
//

import SwiftUI

struct EditProjectView: View {
    let project: Project
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
//    @State private var creationDate: Date // ?
//    @State private var closed: Bool // ?
    @State private var showingDeleteConfirm = false
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    init(project: Project) {
        self.project = project
        _title = State(initialValue: project.projectTitle)
        _detail = State(initialValue: project.projectDetail)
        _color = State(initialValue: project.projectColor)
    }
    
    var body: some View {
        Form {
            // section 1
            Section(header: Text("Basic settings")) {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            // section 2
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { item in
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
                    }
                }
                .padding(.vertical)
            }
            Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project entirely")) {
                Button(project.closed ? "Reopen this project" : "Close project") {
                    project.closed.toggle()
                    update()
                }
                Button("Delete project") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
            }
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: {
            dataController.save()
        })
        .alert(isPresented: $showingDeleteConfirm, content: {
            Alert(title: Text("Delete project?"), message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."), primaryButton: .default(Text("Yes"), action: delete), secondaryButton: .cancel())
        })
    }
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }
    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
