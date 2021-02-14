//
//  ProjectTests.swift
//  TDPortfolioTests
//
//  Created by Thomas on 24/01/2021.
//

import CoreData
import XCTest
@testable import TDPortfolio

class ProjectTests: BaseTestCase {

    func testCreatingProjectsAndItems() {
        // Given
        let targetCount = 10

        // When
        for _ in 0..<targetCount {
            let project = Project(context: managedObjectContext)

            for _ in 0..<targetCount {
                let item = Item(context: managedObjectContext)
                item.project = project
            }
        }

        // Then
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), targetCount * targetCount)
    }

    func testDeletingProjectsCascateDeletesItems() throws {
        // Given
        try dataController.createSampleData()
        let request = NSFetchRequest<Project>(entityName: "Project")
        let projects = try managedObjectContext.fetch(request)

        // When
        dataController.delete(projects[0])

        // Then
        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 4)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 40)
    }

}
