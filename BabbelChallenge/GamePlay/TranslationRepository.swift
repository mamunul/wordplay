//
//  TranslationRepository.swift
//  BabbelChallenge
//
//  Created by Mamunul Mazid on 8/21/20.
//

import Foundation

struct Translation: Decodable {
    let textEng: String
    let textSpa: String
}

class TranslationRepository {
    private var translationMap = [String: String]()

    func getTranslation() -> [String: String]{
        if translationMap.count > 0 {
            return translationMap
        }

        let url = Bundle.main.url(forResource: "words", withExtension: "json")!

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let jsonData = try? Data(contentsOf: url)

        if jsonData != nil {
            let result = try! decoder.decode([Translation].self, from: jsonData!)

            for element in result {
                translationMap[element.textEng] = element.textSpa
            }
        }

        return translationMap
    }
}
