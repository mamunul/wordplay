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
    var queryStatus: QueryStatus { get set }
    func onAnimationCompleted()
    func onTranslationSelected()
    func onViewAppear()
}

enum QueryStatus {
    case ongoing, wrong, skipped, correct
}

class GamePlayPresenter: IGamePlayPresenter {
    @Published var word: String = ""
    @Published var translation: String = ""
    @Published var accuracy: String = ""
    @Published var movePercentage: Double = 0
    @Published var queryStatus = QueryStatus.ongoing

    private var translationMap = [String: String]()
    private let numberOfOptionsPerQuery = 4
    private let numberOfQuery = 10
    private var currentTranslationNo = 0
    private let animationDuration = 8.0
    private let repository: ITranslationRepository
    private let facotry: IGameLogicFactory
    private var gameLogic: IGamePlayLogic?
    private var gameObject: GameObject?

    init(
        repository: ITranslationRepository = TranslationRepository(),
        gameLogicFactory: IGameLogicFactory = GameLogicFactory()
    ) {
        self.repository = repository
        facotry = gameLogicFactory
    }

    private func loadData() {
        do {
            translationMap = try repository.getTranslation()
        } catch {
            print(error)
        }
    }

    private func doInitialSetup() {
        currentTranslationNo = 0
        DispatchQueue.main.async {
            self.word = ""
            self.translation = ""
            self.accuracy = ""
            self.movePercentage = 0
        }
        gameLogic =
            facotry.make(
                queryCount: numberOfQuery,
                optionsPerQuery: numberOfOptionsPerQuery,
                translations: translationMap
            )
    }

    func onViewAppear() {
        DispatchQueue.global(qos: .utility).async {
            self.loadData()
            self.doInitialSetup()
            self.startGame()
        }
    }

    func checkResult() {
        if translationMap[word] == translation {
            queryStatus = .correct
        } else {
            queryStatus = .wrong
        }
    }

    private func startGame() {
        setNextWord()
        showNextTranslation()
    }

    private func setNextWord() {
        currentTranslationNo = 0

        do {
            gameObject = try gameLogic?.nextWord()
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.word = self.gameObject?.word ?? ""
                self.queryStatus = .ongoing
            }

        } catch {
            showFinalResult()
        }
    }

    private func showFinalResult() {
    }

    private func showNextTranslation() {
        DispatchQueue.main.async {
            self.translation = self.gameObject?.options[self.currentTranslationNo] ?? ""
            self.currentTranslationNo += 1
            withAnimation(.easeInOut(duration: self.animationDuration)) {
                self.setFinalAnimationPosition()
            }
        }
    }

    private func setFinalAnimationPosition() {
        movePercentage = 1.0
    }

    private func isAllTranslationChoicesSkipped() -> Bool {
        currentTranslationNo + 1 == numberOfOptionsPerQuery
    }

    private func resetAnimationPosition() {
        movePercentage = 0.0
    }

    func onTranslationSelected() {
        resetAnimationPosition()
        checkResult()
        setNextWord()
        showNextTranslation()
    }

    func onAnimationCompleted() {
        resetAnimationPosition()
        if isAllTranslationChoicesSkipped() {
            queryStatus = .skipped
            setNextWord()
        }
        showNextTranslation()
    }
}
