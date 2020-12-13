//
//  HomeView.swift
//  TD Portfolio
//
//  Created by Thomas on 17/11/2020.
//

import SwiftUI

struct HomeView: View {
    static let homeTag:String? = "Home"
    
    @EnvironmentObject var dataController: DataController

    var body: some View {
        NavigationView {
            VStack {
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
