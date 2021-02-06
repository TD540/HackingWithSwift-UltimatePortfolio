//
//  ExtensionTests.swift
//  TDPortfolioTests
//
//  Created by Thomas on 01/02/2021.
//

import SwiftUI
import XCTest
@testable import TDPortfolio

class ExtensionTests: XCTestCase {
    
    func testSequenceKeyPathSortingSelf() {
        // Given
        let items = [1, 4, 3, 2, 5]

        // When
        let sortedItems = items.sorted(by: \.self)

        // Then
        XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5], "The sorted numbers must be ascending.")
    }

    func testSecondSequenceKeyPathSorting() {
        // Given
        struct TestStruct: Equatable {
            let name: String
        }
        var customItems = [
            TestStruct(name: "B"),
            TestStruct(name: "E"),
            TestStruct(name: "D"),
            TestStruct(name: "A"),
            TestStruct(name: "C")
        ]
        let correctlySorted = [
            TestStruct(name: "A"),
            TestStruct(name: "B"),
            TestStruct(name: "C"),
            TestStruct(name: "D"),
            TestStruct(name: "E")
        ]

        // When
        customItems = customItems.sorted(by: \.name, using: { first, second in
            first < second
        })

        // Then
        XCTAssertEqual(customItems, correctlySorted, "The TestStruct array must be ascending.")
    }

    func testBundleDecodingAwards() {
        // Given Awards.json in the main bundle
        // When decoding
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")

        // Then
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode to a non-empty array.")
    }

    func testDecodingString() {
        // Given
        let bundle = Bundle(for: ExtensionTests.self)

        // When
        let data = bundle.decode(String.self, from: "DecodableString.json")

        // Then
        XCTAssertEqual(
            data,
            "The rain in Spain falls mainly on the Spaniards",
            "The string must match the content of DecodableString.json."
        )
    }

    func testDecodingDictionary() {
        // Given
        let bundle = Bundle(for: ExtensionTests.self)

        // When
        let data = bundle.decode([String: Int].self, from: "DecodableDictionary.json")

        // Then
        XCTAssertEqual(
            data,
            ["One": 1, "Two": 2, "Three": 3],
            "The dictionary must match the content of DecodableDictionary.json."
        )
        XCTAssertEqual(data.count, 3, "There should be 3 items decoded from DecodableDictionary.json")
        XCTAssertEqual(data["One"], 1, "The ductionary should contain Int to String mappings")
    }

    func testBindingOnChangeCallsFunction() {
        // Given
        var onChangeFunctionRun = false
        func exampleFunctionToCall() {
            onChangeFunctionRun = true
        }
        var storedValue = ""
        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0}
        )
        let changedBinding = binding.onChange(exampleFunctionToCall)

        // When
        changedBinding.wrappedValue = "Test"

        // Then
        XCTAssertTrue(
            onChangeFunctionRun,
            "The onChange() function must have run exampleFunctionToCall which changed the bool"
        )
    }

}
