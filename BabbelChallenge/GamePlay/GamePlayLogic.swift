//
//  GamePlayLogic.swift
//  BabbelChallenge
//
//  Created by Mamunul Mazid on 8/27/20.
//

import Foundation

struct GameObject {
    let word: String
    let options: [String]
}

struct PlayerStatus {
    let playedCount = 0
    let correctCount = 0
}

enum GamePlayLogicError: Error {
    case GameQueryExceeds
}

protocol IGamePlayLogic {
    func isCorrect(translation: String, for word: String) -> Bool
    func nextWord() throws -> GameObject
    func resetGame()
}

class GamePlayLogic: IGamePlayLogic {
    private let queryCount: Int
    private let optionsPerQuery: Int
    private let translations: [String: String]
    private var currentQueryNo = 0

    private let wordList: [String]

    init(queryCount: Int, optionsPerQuery: Int, translations: [String: String]) {
        self.queryCount = queryCount
        self.optionsPerQuery = optionsPerQuery
        self.translations = translations
        wordList = translations.map { $0.key }
    }

    private func generateTranslationOptions(_ word: String) -> [String] {
        var options = [String]()

        let wordIndex = wordList.firstIndex(of: word) ?? 0
        let randomIndices = generateIndices(optionsPerQuery, 0 ..< wordList.count, wordIndex)

        for index in randomIndices {
            let randomWord = wordList[index]
            options.append(translations[randomWord]!)
        }

        return options
    }

    private func generateIndices(_ count: Int, _ inRange: Range<Int>, _ including: Int) -> [Int] {
        var indices = inRange.map { _ in Int.random(in: inRange) }

        indices.remove(at: including)
        indices = indices.dropLast(indices.count - (count + 1))
        indices.append(including)
        return indices
    }

    func isCorrect(translation: String, for word: String) -> Bool {
        translations[word] == translation
    }

    func nextWord() throws -> GameObject {
        if currentQueryNo > queryCount {
            throw GamePlayLogicError.GameQueryExceeds
        }
        let word = wordList[currentQueryNo]
        currentQueryNo += 1

        let options = generateTranslationOptions(word)
        return GameObject(word: word, options: options)
    }

    func resetGame() {
        currentQueryNo = 0
    }
}
