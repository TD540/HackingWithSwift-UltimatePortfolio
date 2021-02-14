//
//  PerformanceTests.swift
//  TDPortfolioTests
//
//  Created by Thomas on 14/02/2021.
//

import XCTest
@testable import TDPortfolio

class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformance() throws {
        // Create a significant amount of test data
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        // Simulate lots of awards to check
//        let awards = Award.allAwards
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards.")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }

}
