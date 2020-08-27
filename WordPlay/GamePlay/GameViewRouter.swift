//
//  GameViewRouter.swift
//  WordPlay
//
//  Created by Mamunul Mazid on 8/21/20.
//

import Foundation
import SwiftUI

let gamePlayPresenter = GamePlayPresenter()
struct GameViewRouter {
    func route() -> some View {
        GameView(presenter: gamePlayPresenter)
    }
}
