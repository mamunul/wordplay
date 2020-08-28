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
    private var dispatchQueue: MockDispatchQueue!
    private var factory: MockGamePlayHelperFactory!
    private var gamePlayHelper: MockGamePlayHelper!
    private var repository: MockTranslationRepository!

    override func setUpWithError() throws {
        repository = MockTranslationRepository()
        gamePlayHelper = MockGamePlayHelper()
        factory = MockGamePlayHelperFactory()
        factory.gamePlayHelper = gamePlayHelper
        dispatchQueue = MockDispatchQueue()
        presenter =
            GamePlayPresenter(
                repository: repository,
                gameLogicFactory: factory,
                dispatchQueueWrapper: dispatchQueue
            )

        repository.mockData = ["abc": "cba", "cvb": "bvc", "qwerty": "ytrewq", "uiop": "poiu"]
        gamePlayHelper.gameObject = GameObject(word: "abc", options: ["erwe", "cba", "dfsdf", "sdf", "ghh"])
    }

    func test_startPlaying_isGameEnded_false() {
        presenter.startPlaying()
        XCTAssertFalse(presenter.isGameEnded)
    }

    func test_startPlaying_movePercentage_0() {
        let expectedValue = 0
        dispatchQueue.asyncAfterExecuteCount = 0
        dispatchQueue.asyncExecuteCount = 0
        presenter.startPlaying()
        XCTAssertEqual(Double(expectedValue), presenter.movePercentage, accuracy: 0.01)
    }

    func test_startPlaying_word_notnil() {
        presenter.startPlaying()
        XCTAssertFalse(presenter.word.isEmpty)
    }

    func test_startPlaying_translationNotNil() {
        dispatchQueue.asyncAfterExecuteCount = 1
        dispatchQueue.asyncExecuteCount = 3
        presenter.startPlaying()
        XCTAssertFalse(presenter.translation.isEmpty)
    }

    func test_onTranslationSelected_movePercentage_shouldBe_zero() {
        let expectedValue = 0
        dispatchQueue.asyncAfterExecuteCount = 0
        dispatchQueue.asyncExecuteCount = 0
        presenter.onTranslationSelected()
        XCTAssertEqual(Double(expectedValue), presenter.movePercentage, accuracy: 0.01)
    }

    func test_onTranslationSelected_playedCount_shouldBe_2() {
        let expectedValue = 2
        presenter.onTranslationSelected()
        presenter.onTranslationSelected()

        XCTAssertEqual(expectedValue, presenter.playerStatus.playedCount)
    }

    func test_onTranslationSelected_correctCount_shouldBe_3() {
        let expectedValue = 2
        gamePlayHelper.correct = true
        presenter.startPlaying()
        presenter.onTranslationSelected()
        presenter.onTranslationSelected()

        XCTAssertEqual(expectedValue, presenter.playerStatus.correctCount)
    }

    func test_onTranslationSelected_queryStatus_shouldBe_Wrong() {
        let expectedValue = QueryStatus.wrong
        gamePlayHelper.correct = false
        dispatchQueue.asyncAfterExecuteCount = 1
        presenter.startPlaying()
        presenter.onTranslationSelected()

        XCTAssertEqual(expectedValue, presenter.queryStatus)
    }

    func test_onTranslationSelected_queryStatus_shouldBe_Correct() {
        let expectedValue = QueryStatus.correct
        gamePlayHelper.correct = true
        dispatchQueue.asyncAfterExecuteCount = 1
        presenter.startPlaying()
        presenter.onTranslationSelected()

        XCTAssertEqual(expectedValue, presenter.queryStatus)
    }

    func test_onTranslationSelected_newWord_shouldBe_correct() {
        let expectedWord = "abc"
        dispatchQueue.asyncAfterExecuteCount = 1
        presenter.startPlaying()
        presenter.onTranslationSelected()

        XCTAssertEqual(expectedWord, presenter.word)
    }

    func test_onTranslationSelected_options_shouldHave_correctTranslations() {
        let expectedWord = "cba"
        dispatchQueue.asyncAfterExecuteCount = 1
        dispatchQueue.asyncExecuteCount = 4
        presenter.startPlaying()
        presenter.onAnimationCompleted()

        XCTAssertEqual(expectedWord, presenter.translation)
    }

    func test_onTranslationSelected_queryStatus_shouldBe_Ongoing() {
        let expectedValue = QueryStatus.ongoing
        dispatchQueue.asyncAfterExecuteCount = 2
        dispatchQueue.asyncExecuteCount = 3
        presenter.startPlaying()
        presenter.onTranslationSelected()
        XCTAssertEqual(expectedValue, presenter.queryStatus)
    }

    func test_onTranslationSelected_isGameEnded_shouldBe_True() {
        presenter.startPlaying()
        gamePlayHelper.gameObject = nil
        presenter.onTranslationSelected()
        XCTAssertTrue(presenter.isGameEnded)
    }

    func test_onTranslationSelected_movePercentage_shouldBe_one() {
        let expectedValue = 1.0
        dispatchQueue.asyncAfterExecuteCount = 1
        dispatchQueue.asyncExecuteCount = 4
        presenter.startPlaying()
        presenter.onTranslationSelected()
        XCTAssertEqual(Double(expectedValue), presenter.movePercentage, accuracy: 0.01)
    }

    func test_onTranslationSelected_translation_shouldBe_fromGameObject() {
        let expectedValues = ["erwe", "cba", "dfsdf", "sdf"]
        gamePlayHelper.gameObject = GameObject(word: "abc", options: expectedValues)
        dispatchQueue.asyncAfterExecuteCount = 1
        dispatchQueue.asyncExecuteCount = 4
        presenter.startPlaying()
        presenter.onTranslationSelected()

        XCTAssertTrue(expectedValues.contains(presenter.translation))
    }

    func test_onAnimationCompleted_movePercentage_shouldBe_0() {
        let expectedValue = 0.0
        dispatchQueue.asyncAfterExecuteCount = 1
        presenter.startPlaying()
        presenter.onAnimationCompleted()
        XCTAssertEqual(Double(expectedValue), presenter.movePercentage, accuracy: 0.01)
    }

    func test_onAnimationCompleted_onQueryFinished_isGamedEnded_shouldBe_true() {
        gamePlayHelper.gameObject = nil
        dispatchQueue.asyncAfterExecuteCount = 1
        dispatchQueue.asyncExecuteCount = 4
        presenter.startPlaying()
        presenter.onAnimationCompleted()

        XCTAssertTrue(presenter.isGameEnded)
    }

    func test_onAnimationCompleted_onSkippedOptions_queryStatus_shouldNotBe_skipped() {
        let expectedValue = QueryStatus.skipped
        dispatchQueue.asyncAfterExecuteCount = 1
        dispatchQueue.asyncExecuteCount = 6
        presenter.startPlaying()
        presenter.onAnimationCompleted()
        presenter.onAnimationCompleted()

        XCTAssertNotEqual(expectedValue, presenter.queryStatus)
    }

    func test_onAnimationCompleted_onSkippedOptions_queryStatus_shouldBe_skipped() {
        let expectedValue = QueryStatus.skipped
        dispatchQueue.asyncAfterExecuteCount = 1
        dispatchQueue.asyncExecuteCount = 6
        presenter.startPlaying()
        presenter.onAnimationCompleted()
        presenter.onAnimationCompleted()
        presenter.onAnimationCompleted()
        presenter.onAnimationCompleted()

        XCTAssertEqual(expectedValue, presenter.queryStatus)
    }

    func test_onAnimationCompleted_playedCount_notIncreased() {
        let expectedValue = 0
        dispatchQueue.asyncAfterExecuteCount = 1
        dispatchQueue.asyncExecuteCount = 7
        presenter.startPlaying()
        presenter.onAnimationCompleted()
        presenter.onAnimationCompleted()
        XCTAssertEqual(expectedValue, presenter.playerStatus.playedCount)
    }

    func test_onAnimationCompleted_playedCount_increased() {
        let expectedValue = 1
        dispatchQueue.asyncAfterExecuteCount = 1
        dispatchQueue.asyncExecuteCount = 7
        presenter.startPlaying()
        presenter.onAnimationCompleted()
        presenter.onAnimationCompleted()
        presenter.onAnimationCompleted()
        presenter.onAnimationCompleted()
        XCTAssertEqual(expectedValue, presenter.playerStatus.playedCount)
    }

    func test_onAnimationCompleted_word_shouldBe_nextOne() {
        let expectedValue = "bnm"
        dispatchQueue.asyncAfterExecuteCount = 2
        dispatchQueue.asyncExecuteCount = 7
        gamePlayHelper.gameObject = GameObject(word: "abc", options: ["erwe", "cba", "dfsdf", "sdf"])
        presenter.startPlaying()
        presenter.onAnimationCompleted()
        gamePlayHelper.gameObject = GameObject(word: expectedValue, options: ["erwe", "cba", "dfsdf", "sdf"])
        presenter.onAnimationCompleted()
        presenter.onAnimationCompleted()
        XCTAssertEqual(expectedValue, presenter.word)
    }

    func test_onAnimationCompleted_QueryStatus_shouldBe_onGoing() {
        let expectedValue = QueryStatus.ongoing
        dispatchQueue.asyncAfterExecuteCount = 1
        dispatchQueue.asyncExecuteCount = 7
        presenter.startPlaying()
        presenter.onAnimationCompleted()
        XCTAssertEqual(expectedValue, presenter.queryStatus)
    }
}

private class MockDispatchQueue: IDispatchQueueWrapper {
    var asyncExecuteCount = 1
    private var asyncExecuteCounter = 0
    var asyncAfterExecuteCount = 1
    private var asyncAfterExecuteCounter = 0
    func async(in dispatchQueue: DispatchQueue, work: @escaping () -> Void) {
        if asyncExecuteCounter < asyncExecuteCount {
            work()
            asyncExecuteCounter += 1
        }
    }

    func sync(in dispatchQueue: DispatchQueue, work: () -> Void) {
        work()
    }

    func asyncAfter(in dispatchQueue: DispatchQueue, deadline: DispatchTime, execute work: @escaping @convention(block) () -> Void) {
        if asyncAfterExecuteCounter < asyncAfterExecuteCount {
            work()
            asyncAfterExecuteCounter += 1
        }
    }
}

private class MockGamePlayHelperFactory: IGameLogicFactory {
    var gamePlayHelper: MockGamePlayHelper?
    func make(queryCount: Int, optionsPerQuery: Int, translations: [String: String]) -> IGamePlayLogic {
        gamePlayHelper!
    }
}

private class MockGamePlayHelper: IGamePlayLogic {
    var gameObject: GameObject?
    var correct = false
    func isCorrect(translation: String, for word: String) -> Bool {
        correct
    }

    func nextWord() throws -> GameObject {
        if gameObject == nil {
            throw GamePlayLogicError.GameQueryExceeds
        } else {
            return gameObject!
        }
    }

    func resetGame() {
    }
}

private class MockTranslationRepository: ITranslationRepository {
    var mockData = [String: String]()
    func getTranslation() -> [String: String] {
        return mockData
    }
}
