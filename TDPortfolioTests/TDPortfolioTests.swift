//
//  TDPortfolioTests.swift
//  TDPortfolioTests
//
//  Created by Thomas Decrick on 13/01/2021.
//

import CoreData
import XCTest
@testable import TDPortfolio

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
