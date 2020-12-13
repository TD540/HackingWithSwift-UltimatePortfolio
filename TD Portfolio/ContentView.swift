//
//  ContentView.swift
//  Again
//
//  Created by Thomas on 13/11/2020.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.homeTag)
                .tabItem {
                    Image(systemName: "house")
                    Text("House")
                }

            ProjectsView(showClosedProjects: false)
                .tag(ProjectsView.closedTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }

            ProjectsView(showClosedProjects: true)
                .tag(ProjectsView.openTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
