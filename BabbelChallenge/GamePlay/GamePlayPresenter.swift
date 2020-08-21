//
//  GamePlayPresenter.swift
//  BabbelChallenge
//
//  Created by Mamunul Mazid on 8/21/20.
//

import Foundation
import SwiftUI

protocol IGamePlayPresenter: ObservableObject {
    var word: String { get set }
    var translation: String { get set }
    var accuracy: String { get set }
    var movePercentage: Double { get set }
    func onAnimationCompletion()
    func onTranslationButtonTapped()
    func onViewAppear()
}

class GamePlayPresenter: IGamePlayPresenter {
    @Published var word: String
    @Published var translation: String
    @Published var accuracy: String
    @Published var movePercentage: Double

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
        movePercentage = 0.0
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
        showTranslation()
    }

    func onAnimationCompletion() {
        currentTranslationNo += 1
        movePercentage = 0.0
        checkResult()
        if isQueryCompleted() {
            showNewQuery()
        } else {
            translation = translateOptions[currentTranslationNo]
        }
        if isGameCompleted() {
            showGameCompletionStatus()
        }
        showTranslation()
    }

    func onViewAppear() {
        showTranslation()
    }

    private func showTranslation() {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 4.0)) {
                self.movePercentage = 1.0
            }
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
