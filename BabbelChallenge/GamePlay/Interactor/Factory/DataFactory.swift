//
//  DataFactory.swift
//  BabbelChallenge
//
//  Created by Mamunul Mazid on 8/27/20.
//

import Foundation

protocol IDataFactory {
    func make(url: URL) -> Data?
}

class DataFactory: IDataFactory {
    func make(url: URL) -> Data? {
        try? Data(contentsOf: url)
    }
}
