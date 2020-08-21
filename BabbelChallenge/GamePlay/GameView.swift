//
//  GameView.swift
//  BabbelChallenge
//
//  Created by Mamunul Mazid on 8/21/20.
//

import SwiftUI

let gamePlayPresenter = GamePlayPresenter()

struct MovingButtonView: View {
    @ObservedObject var presenter: GamePlayPresenter
    @Binding var show: Bool

    var body: some View {
        GeometryReader { gm in
            Button(action: {}) {
                Text(self.presenter.translation).padding()
            }
            .offset(x: 0, y: self.show ? -gm.size.height : gm.size.height)
        }
    }
}

struct GameView: View {
    @ObservedObject var presenter = gamePlayPresenter
    @State var show = false
    var body: some View {
        VStack {
            Text(presenter.word).padding()
            MovingButtonView(presenter: presenter, show: $show)
            Button("ShowTranslation") {
                withAnimation(.easeInOut(duration: 3.0)) {
                    self.show.toggle()
                }
            }.padding(20)
            Text("Accuracy: " + presenter.accuracy).padding()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
