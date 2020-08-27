//
//  GameView.swift
//  BabbelChallenge
//
//  Created by Mamunul Mazid on 8/21/20.
//

import SwiftUI

let gamePlayPresenter = GamePlayPresenter()

struct MovingView: View {
    @ObservedObject var presenter: GamePlayPresenter
    @Binding var percentage: Double
    var body: some View {
        GeometryReader { gm in
            Text(self.presenter.translation).padding()
                .modifier(AnimatableModifierDouble(bindedValue: self.percentage) {
                    self.percentage = 0.0
                    self.presenter.onAnimationCompleted()
                })
                .opacity(self.percentage)
                .offset(x: 0, y: CGFloat(CGFloat(self.percentage) * gm.size.height * 2) - gm.size.height)
        }
    }
}

struct GameView: View {
    @ObservedObject var presenter = gamePlayPresenter
    var body: some View {
        VStack {
            Text(presenter.word).padding()
            MovingView(presenter: presenter, percentage: self.$presenter.movePercentage)
            Button(action: {
                self.presenter.onTranslationSelected()
            }) {
                Text("Select").padding()
            }
            Text("Accuracy: " + presenter.accuracy).padding()
        }.onAppear{
            self.presenter.onViewAppear()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
