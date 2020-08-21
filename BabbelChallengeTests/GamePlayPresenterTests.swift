//
//  BabbelChallengeTests.swift
//  BabbelChallengeTests
//
//  Created by Mamunul Mazid on 8/21/20.
//

@testable import BabbelChallenge
import XCTest

class GamePlayPresenterTests: XCTestCase {
    private var presenter: GamePlayPresenter!
    private var repository: MockTranslationRepository!

    override func setUpWithError() throws {
        repository = MockTranslationRepository()
        presenter = GamePlayPresenter(repository: repository)
    }

    func test_onAnimationCompletion_movePercentage_shouldBe_0() {
        let expected = 0.0
        presenter.onViewAppear()
        presenter.onAnimationCompletion()

        XCTAssertEqual(expected, presenter.movePercentage, accuracy: 0.01)
    }

    func test_onAnimationCompletion_checkQueryWord_isCorrect() {
        let expected = "abc"
        presenter.onViewAppear()

        XCTAssertEqual(expected, presenter.word)
    }

    func test_onAnimationCompletion_checkTranslation_isCOrrect() {
        let expected = "cba"
        presenter.onViewAppear()
        XCTAssertEqual(expected, presenter.translation)
    }
}

private class MockTranslationRepository: ITranslationRepository {
    func getTranslation() -> [String: String] {
        var mockData = [String: String]()
        mockData["abc"] = "cba"
        mockData["cvb"] = "bvc"
        mockData["qwerty"] = "ytrewq"
        return mockData
    }
}
