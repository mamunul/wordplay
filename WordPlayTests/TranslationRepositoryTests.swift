//
//  TranslationRepositoryTests.swift
//  WordPlayTests
//
//  Created by Mamunul Mazid on 8/28/20.
//

@testable import WordPlay
import XCTest

class TranslationRepositoryTests: XCTestCase {
    private var bundle: MockBundle!
    private var decoder: MockJSONDecoder!
    private var factory: MockDataFactory!
    private var repository: TranslationRepository!

    override func setUpWithError() throws {
        bundle = MockBundle()
        decoder = MockJSONDecoder()
        factory = MockDataFactory()
        repository = TranslationRepository(bundle: bundle, jsonDecoder: decoder, dataFactory: factory)
    }

    func test_getTranslation_throw_onNilUrl() {
        XCTAssertThrowsError(try repository.getTranslation())
    }

    func test_getTranslation_throw_onNilData() {
        bundle.url = URL(string: "a")
        XCTAssertThrowsError(try repository.getTranslation())
    }

    func test_getTranslation_throw_onInvalidJSON() {
        bundle.url = URL(string: "a")
        factory.data = Data()
        XCTAssertThrowsError(try repository.getTranslation())
    }

    func test_getTranslation_correctData() throws {
        bundle.url = URL(string: "ad")
        factory.data = Data()

        decoder.translations =
            [
                Translation(textEng: "abc", textSpa: "cba"),
                Translation(textEng: "bcd", textSpa: "dcb"),
                Translation(textEng: "xyz", textSpa: "zyx"),
            ]

        let result = try repository.getTranslation()

        let expectedValue1 = "cba"
        let expectedValue2 = "dcb"
        let expectedValue3 = "zyx"

        XCTAssertEqual(expectedValue1, result["abc"])
        XCTAssertEqual(expectedValue2, result["bcd"])
        XCTAssertEqual(expectedValue3, result["xyz"])
    }

    func test_getTranslation_wontCallJSONDecoder() throws {
        bundle.url = URL(string: "ad")
        factory.data = Data()

        decoder.translations =
            [
                Translation(textEng: "abc", textSpa: "cba"),
                Translation(textEng: "bcd", textSpa: "dcb"),
                Translation(textEng: "xyz", textSpa: "zyx"),
            ]
        _ = try repository.getTranslation()
        _ = try repository.getTranslation()

        XCTAssertFalse(decoder.decodeCalled)
    }
}

private class MockBundle: IBundle {
    var url: URL?
    func url(forResource name: String?, withExtension ext: String?) -> URL? {
        url
    }
}

private class MockJSONDecoder: IJSONDecoder {
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase
    var translations: [Translation]?
    var decodeCalled = false
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        decodeCalled = true
        if translations == nil {
            throw MockError.any
        } else {
            return translations as! T
        }
    }
}

private class MockDataFactory: IDataFactory {
    var data: Data?
    func make(url: URL) -> Data? {
        data
    }
}

private enum MockError: Error {
    case any
}
