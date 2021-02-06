//
//  AssetTest.swift
//  TDPortfolioTests
//
//  Created by Thomas Decrick on 13/01/2021.
//

import XCTest
@testable import TDPortfolio

class AssetTest: XCTestCase {

    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from Colors assets")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON")
    }

}
