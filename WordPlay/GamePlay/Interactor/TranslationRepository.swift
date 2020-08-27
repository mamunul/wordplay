//
//  TranslationRepository.swift
//  WordPlay
//
//  Created by Mamunul Mazid on 8/21/20.
//

import Foundation

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
    private var bundle: IBundle
    private var jsonDecoder: IJSONDecoder
    private var dataFactory: IDataFactory

    init(
        bundle: IBundle = Bundle.main,
        jsonDecoder: IJSONDecoder = JSONDecoder(),
        dataFactory: IDataFactory = DataFactory()
    ) {
        self.bundle = bundle
        self.jsonDecoder = jsonDecoder
        self.dataFactory = dataFactory
    }

    func getTranslation() throws -> [String: String] {
        if !translationMap.isEmpty {
            return translationMap
        }

        guard let url = bundle.url(forResource: fileName, withExtension: fielExtension) else {
            throw TranslationRepositoryError.invalidURL
        }

        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let jsonData = dataFactory.make(url: url) else { throw TranslationRepositoryError.inValidData }

        guard let result = try? jsonDecoder.decode([Translation].self, from: jsonData) else {
            throw TranslationRepositoryError.inValidJSON
        }

        for element in result {
            translationMap[element.textEng] = element.textSpa
        }

        return translationMap
    }
}

protocol IBundle {
    func url(forResource name: String?, withExtension ext: String?) -> URL?
}

extension Bundle: IBundle {
}

protocol IJSONDecoder {
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get set }
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: IJSONDecoder {
}
