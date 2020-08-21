//
//  GamePlayPresenter.swift
//  BabbelChallenge
//
//  Created by Mamunul Mazid on 8/21/20.
//

import Foundation

protocol IGamePlayPresenter: ObservableObject {
    var word: String { get set }
    var translation: String { get set }
    var accuracy: String { get set }
    var showTranslation: Bool { get set }
    func onAnimationCompletion()
    func onTranslationButtonTapped()
}

class GamePlayPresenter: IGamePlayPresenter {
    @Published var word: String
    @Published var translation: String
    @Published var accuracy: String
    @Published var showTranslation: Bool

    private var translationMap = [String: String]()
    private let numberOfOptionsPerQuery = 4
    private let numberOfQuery = 10
    private var currentTranslationNo = 0
    private var correctCount = 0
    private var totalPresented = 0
    private var currentQueryIndex = 0
    private var translateOptions = [String]()

    init() {
        accuracy = "0/0"
        word = "test"
        translation = "trans-test"
        showTranslation = false
    }

    private func loadTranslationMap() {
        translationMap["test1"] = "1test"
        translationMap["test2"] = "2test"
        translationMap["test3"] = "3test"
    }

    func onTranslationButtonTapped() {
        accuracy = "\(correctCount)/\(totalPresented)"

        checkResult()
        showNewQuery()
        if isGameCompleted() {
            showGameCompletionStatus()
        }
    }

    func onAnimationCompletion() {
        currentTranslationNo += 1

        checkResult()
        if isQueryCompleted() {
            showNewQuery()
        } else {
            translation = translateOptions[currentTranslationNo]
        }
        if isGameCompleted() {
            showGameCompletionStatus()
        }
    }

    private func showNewQuery() {
        currentQueryIndex += 1
        currentTranslationNo = 0
        translateOptions.removeAll()

        let keyArray = Array(translationMap.keys)

        let word = keyArray[currentQueryIndex]
        self.word = word

        if let translation = translationMap[word] {
            translateOptions.append(translation)
        }
        var usedIndices = [Int]()
        usedIndices.append(currentQueryIndex)

        for _ in 0 ..< (numberOfOptionsPerQuery - 1) {
            let index = random(in: 0 ..< keyArray.count, excludingIndices: usedIndices)
            if let translation = translationMap[keyArray[index]] {
                translateOptions.append(translation)
            }
        }
    }

    private func random(in range: Range<Int>, excludingIndices: [Int]) -> Int {
        var randValue = 0
        repeat {
            randValue = Int.random(in: Range(uncheckedBounds: (range.lowerBound, range.upperBound)))
        } while excludingIndices.contains(randValue)

        return randValue
    }

    private func isGameCompleted() -> Bool {
        currentQueryIndex + 1 == numberOfQuery
    }

    private func isQueryCompleted() -> Bool {
        return currentTranslationNo == numberOfOptionsPerQuery
    }

    private func showGameCompletionStatus() {
    }

    private func checkResult() {
        correctCount += 1
        totalPresented += 1
    }
}
