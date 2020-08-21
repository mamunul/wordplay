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
    private let animationDuration = 8.0
    private let repository: ITranslationRepository

    init(repository: ITranslationRepository = TranslationRepository()) {
        accuracy = "0/0"
        word = "test"
        translation = "trans-test"
        movePercentage = 0.0
        self.repository = repository
        loadTranslationMap()
    }

    private func loadTranslationMap() {
        translationMap = repository.getTranslation()
    }

    func onTranslationButtonTapped() {
        if translationMap[word] == translation {
            correctCount += 1
        }
        updateResult()
        showNewQuery()
        showTranslation()
    }

    func onAnimationCompletion() {
        currentTranslationNo += 1
        movePercentage = 0.0
        updateResult()
        if isQueryCompleted() {
            showNewQuery()
        } else {
            translation = translateOptions[currentTranslationNo]
        }
        showTranslation()
    }

    func onViewAppear() {
        currentTranslationNo = 0
        showNewQuery()
        showTranslation()
    }

    private func showTranslation() {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: self.animationDuration)) {
                self.movePercentage = 1.0
            }
        }
    }

    private func loadTranslationOptions(
        _ word: Dictionary<String, String>.Keys.Element,
        _ keyArray: [Dictionary<String, String>.Keys.Element]
    ) {
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

    private func showNewQuery() {
        currentTranslationNo = 0
        translateOptions.removeAll()

        let keyArray = Array(translationMap.keys)

        let word = keyArray[currentQueryIndex]
        self.word = word

        loadTranslationOptions(word, keyArray)

        translation = translateOptions[currentTranslationNo]
        currentQueryIndex += 1
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
        return currentTranslationNo + 1 == numberOfOptionsPerQuery
    }

    private func updateResult() {
        accuracy = "\(correctCount)/\(currentQueryIndex)"
    }
}
