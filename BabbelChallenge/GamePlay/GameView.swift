//
//  GameView.swift
//  BabbelChallenge
//
//  Created by Mamunul Mazid on 8/21/20.
//

import SwiftUI

let gamePlayPresenter = GamePlayPresenter()
struct GameView: View {
    @ObservedObject var presenter = gamePlayPresenter
    var body: some View {
        VStack {
            Text(presenter.word)
            Button(action: {}) {
                Text(presenter.translation)
            }
            Text(presenter.accuracy)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
