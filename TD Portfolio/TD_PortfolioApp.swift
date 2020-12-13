//
//  TD_PortfolioApp.swift
//  TD Portfolio
//
//  Created by Thomas on 13/11/2020.
//

import SwiftUI

@main
struct TD_PortfolioApp: App {
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
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
        }
    }
    
    func save(_ note: Notification) {
        dataController.save()
    }
}
