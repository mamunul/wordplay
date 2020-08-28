//
//  GamePlayHelperTests.swift
//  WordPlayTests
//
//  Created by Mamunul Mazid on 8/28/20.
//

@testable import WordPlay
import XCTest

class GamePlayHelperTests: XCTestCase {
    private var gamePlayHelper: GamePlayHelper!
    private var queryCount = 1
    private var optionsPerQuery = 4
    private var translations: [String: String]!

    override func setUpWithError() throws {
        translations = ["abc": "cba", "bcd": "dcb", "jkl": "lkj", "iop": "poi"]
        gamePlayHelper = GamePlayHelper(queryCount: queryCount, optionsPerQuery: optionsPerQuery, translations: translations)
    }

    func test_isCorrect_shouldBe_true() {
        let result = gamePlayHelper.isCorrect(translation: "cba", for: "abc")
        XCTAssertTrue(result)
    }

    func test_isCorrect_shouldBe_false() {
        let result = gamePlayHelper.isCorrect(translation: "lkj", for: "abc")
        XCTAssertFalse(result)
    }

    func test_nextWord_shuouldHave_correctWord() throws {
        let expectedValue = ["iop", "abc", "bcd", "jkl"]
        let result = try gamePlayHelper.nextWord()

        XCTAssertTrue(expectedValue.contains(result.word))
    }

    func test_nextWord_shuouldHave_correctOptions() throws {
        let expectedValue = ["cba", "dcb", "lkj", "poi"]
        let result = try gamePlayHelper.nextWord()

        XCTAssertEqual(expectedValue.sorted(), result.options.sorted())
    }

    func test_nextWord_throws_onExceeds() throws {
        _ = try gamePlayHelper.nextWord()
        XCTAssertThrowsError(try gamePlayHelper.nextWord())
    }

    func test_resetGame_wontThrow_exceeds() throws {
        _ = try gamePlayHelper.nextWord()
        gamePlayHelper.resetGame()
        XCTAssertNoThrow(try gamePlayHelper.nextWord())
    }
}
