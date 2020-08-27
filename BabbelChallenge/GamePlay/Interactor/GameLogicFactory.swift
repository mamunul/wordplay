//
//  GameLogicFactory.swift
//  BabbelChallenge
//
//  Created by Mamunul Mazid on 8/27/20.
//

import Foundation

protocol IGameLogicFactory {
    func make(queryCount: Int, optionsPerQuery: Int, translations: [String: String]) -> IGamePlayLogic
}

class GameLogicFactory: IGameLogicFactory {
    func make(queryCount: Int, optionsPerQuery: Int, translations: [String: String]) -> IGamePlayLogic {
        GamePlayLogic(queryCount: queryCount, optionsPerQuery: optionsPerQuery, translations: translations)
    }
}
