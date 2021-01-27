//
//  DevelopmentTests.swift
//  TDPortfolioTests
//
//  Created by Thomas on 27/01/2021.
//

import CoreData
import XCTest
@testable import TDPortfolio

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "There should be 50 sample items.")
    }

    func testDeleteAllWorks() throws {
        try dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "There should be no projects in dataController.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0, "There should be no items in dataController.")
    }

    func testExampleProjectIsClosed() {
        let project = Project.example
        XCTAssertTrue(project.closed, "Example project should be closed.")
    }

    func testExampleItemisHighPriority() {
        let item = Item.example
        XCTAssertEqual(item.priority, 3, "Example item should be high priority.")
    }
}
