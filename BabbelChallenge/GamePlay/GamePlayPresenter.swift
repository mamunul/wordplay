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

        totalPresented += 1
        currentTranslationNo = 0
        correctCount += 1
        checkResult()
        showNewQuery()
        if isGameCompleted() {
            showGameCompletionStatus()
        }
    }

    func onAnimationCompletion() {
        currentTranslationNo += 1

        checkResult()
        showNewQuery()
        if isGameCompleted() {
            showGameCompletionStatus()
        }
    }

    private func showNewQuery() {
    }

    private func isGameCompleted() -> Bool {
        true
    }

    private func showGameCompletionStatus() {
    }

    private func checkResult() {
    }
}
