//
//  GameLogicFactory.swift
//  WordPlay
//
//  Created by Mamunul Mazid on 8/27/20.
//

import Foundation

protocol IGameLogicFactory {
    func make(queryCount: Int, optionsPerQuery: Int, translations: [String: String]) -> IGamePlayHelper
}

class GameLogicFactory: IGameLogicFactory {
    func make(queryCount: Int, optionsPerQuery: Int, translations: [String: String]) -> IGamePlayHelper {
        GamePlayHelper(queryCount: queryCount, optionsPerQuery: optionsPerQuery, translations: translations)
    }
}
