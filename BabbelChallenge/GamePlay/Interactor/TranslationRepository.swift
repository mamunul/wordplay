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

protocol ITranslationRepository {
    func getTranslation() throws -> [String: String]
}

enum TranslationRepositoryError: Error {
    case invalidURL, inValidJSON, inValidData
}

class TranslationRepository: ITranslationRepository {
    private var translationMap = [String: String]()
    private let fileName = "words"
    private let fielExtension = "json"

    func getTranslation() throws -> [String: String] {
        if !translationMap.isEmpty {
            return translationMap
        }

        guard let url = Bundle.main.url(forResource: fileName, withExtension: fielExtension) else {
            throw TranslationRepositoryError.invalidURL
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let jsonData = try? Data(contentsOf: url) else { throw TranslationRepositoryError.inValidData }

        guard let result = try? decoder.decode([Translation].self, from: jsonData) else {
            throw TranslationRepositoryError.inValidJSON
        }

        for element in result {
            translationMap[element.textEng] = element.textSpa
        }

        return translationMap
    }
}
