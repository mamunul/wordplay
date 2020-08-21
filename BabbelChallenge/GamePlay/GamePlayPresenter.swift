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
    func onTranslationButtonTapped()
}

class GamePlayPresenter: IGamePlayPresenter {
    @Published var word: String
    @Published var translation: String
    @Published var accuracy: String

    private var translationMap = [String: String]()

    init() {
        accuracy = "0/0"
        word = "test"
        translation = "trans-test"
    }

    private func loadTranslationMap() {
        translationMap["test1"] = "1test"
        translationMap["test2"] = "2test"
        translationMap["test3"] = "3test"
    }

    func onTranslationButtonTapped() {
        accuracy = "1/1"
    }
}
