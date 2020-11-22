//
//  AgainApp.swift
//  Again
//
//  Created by Thomas on 13/11/2020.
//

import SwiftUI

@main
struct AgainApp: App {
    @StateObject var dataController: DataController
    
    init() {
       let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
