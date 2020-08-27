//
//  WordPlayTests.swift
//  WordPlayTests
//
//  Created by Mamunul Mazid on 8/21/20.
//

@testable import WordPlay
import XCTest

class GamePlayPresenterTests: XCTestCase {
    private var presenter: GamePlayPresenter!
    private var repository: MockTranslationRepository!

    override func setUpWithError() throws {
        repository = MockTranslationRepository()
        presenter = GamePlayPresenter(repository: repository)
    }

    func test_startPlaying_translationMap_notEmpty() {
    }

    func test_startPlaying_isGameEnded_false() {
    }

    func test_startPlaying_movePercentage_0() {
    }

    func test_startPlaying_word_notnil() {
    }

    func test_startPlaying_translationNotNil() {
    }

    func test_startPlaying_options_notEmpty() {
    }

    func test_onTranslationSelected_movePercentage_shouldBe_zero() {
    }

    func test_onTranslationSelected_playedCount_shouldBe_2() {
    }

    func test_onTranslationSelected_correctCount_shouldBe_3() {
    }

    func test_onTranslationSelected_queryStatus_shouldBe_Wrong() {
    }

    func test_onTranslationSelected_queryStatus_shouldBe_Correct() {
    }

    func test_onTranslationSelected_word_shouldBe_correct() {
    }

    func test_onTranslationSelected_translation_shouldBe_correct() {
    }

    func test_onTranslationSelected_queryStatus_shouldBe_Ongoing() {
    }

    func test_onTranslationSelected_isGameEnded_shouldBe_True() {
    }

    func test_onTranslationSelected_movePercentage_shouldBe_one() {
    }

    func test_onTranslationSelected_translation_shouldBe_fromGameObject() {
    }

    func test_onAnimationCompleted_movePercentage_shouldBe_0() {
    }

    func test_onAnimationCompleted_onQueryFiniched_isGamedEnded_shouldBe_true() {
    }

    func test_onAnimationCompleted_onSkippedOptions_queryStatus_shouldBe_skipped() {
    }

    func test_onAnimationCompleted_playedCount_increased() {
    }

    func test_onAnimationCompleted_word_shouldBe_nextOne() {
    }

    func test_onAnimationCompleted_QueryStatus_shouldBe_onGoing() {
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
