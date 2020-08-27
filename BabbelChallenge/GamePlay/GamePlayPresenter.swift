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
}

enum Status {
    case wrong, skipped, correct
}

class GamePlayPresenter: IGamePlayPresenter {
    @Published var word: String = ""
    @Published var translation: String = ""
    @Published var accuracy: String = ""
    @Published var movePercentage: Double = 0

    private var translationMap = [String: String]()
    private let numberOfOptionsPerQuery = 4
    private let numberOfQuery = 10
    private var currentTranslationNo = 0
    private let animationDuration = 8.0
    private let repository: ITranslationRepository

    init(repository: ITranslationRepository = TranslationRepository()) {
        self.repository = repository
        loadData()
    }

    private func loadData() {
    }

    func onViewAppear() {
        doInitialSetup()
    }

    private func checkResult() {
    }

    private func updateResult() {
    }

    private func setNextWord() {
    }

    private func showNextTranslation() {
    }

    private func isAllTranslationChoicesSkipped() -> Bool {
        true
    }

    func onTranslationSelected() {
        checkResult()
        updateResult()
        setNextWord()
        showNextTranslation()
    }

    func onAnimationCompleted() {
        if isAllTranslationChoicesSkipped() {
            checkResult()
            updateResult()
            setNextWord()
        }
        showNextTranslation()
    }

    private func doInitialSetup() {
    }
}
