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
            Text(presenter.word).padding()
            Button(action: {}) {
                Text(presenter.translation).padding()
            }
            Text("Accuracy: " + presenter.accuracy).padding()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
