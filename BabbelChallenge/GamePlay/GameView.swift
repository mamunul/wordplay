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
                    self.presenter.onAnimationCompletion()
                })
                .opacity(self.percentage)
                .offset(x: 0, y: CGFloat(CGFloat(self.percentage) * gm.size.height))
        }
    }
}

struct GameView: View {
    @ObservedObject var presenter = gamePlayPresenter
    @State var movePercentage: Double = 0
    var body: some View {
        VStack {
            Text(presenter.word).padding()
            MovingView(presenter: presenter, percentage: self.$movePercentage)
            Button(action: {
                self.presenter.onTranslationButtonTapped()
            }) {
                Text("Select").padding()
            }
            Button("ShowTranslation") {
                withAnimation(.easeInOut(duration: 4.0)) {
                    self.movePercentage = 1
                }
            }.padding()
            Text("Accuracy: " + presenter.accuracy).padding()
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
