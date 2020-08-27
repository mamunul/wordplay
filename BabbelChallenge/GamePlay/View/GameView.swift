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
        GeometryReader { geometry in
            Text(self.presenter.translation).padding()
                .modifier(AnimatableModifierDouble(bindedValue: self.percentage) {
                    self.presenter.onAnimationCompleted()
                })
                .opacity(self.percentage)
                .offset(x: 0, y: self.getCurrentY(geometry))
        }
    }

    private func getCurrentY(_ geometry: GeometryProxy) -> CGFloat {
        return CGFloat(percentage) * geometry.size.height - geometry.size.height / 2
    }
}

struct GameView: View {
    @ObservedObject var presenter = gamePlayPresenter
    @State var statusMessage: String = ""
    @State var color = Color.green
    @State var showAlert = false
    var body: some View {
        ZStack {
            VStack {
                Text(self.presenter.word).padding()
                Spacer()
                Button(action: {
                    self.presenter.onTranslationSelected()
                }) {
                    Text("Select").padding()
                }
            }
            MovingView(
                presenter: self.presenter,
                percentage: self.$presenter.movePercentage
            ).border(Color.blue)

            Text(self.statusMessage)
                .foregroundColor(self.color)
        }
        .onReceive(self.presenter.$queryStatus) { status in
            (self.statusMessage, self.color) = status.getTextAndColor()
        }
        .onAppear {
            self.presenter.onViewAppear()
        }
        .alert(isPresented: self.$presenter.isGameEnded) {
            getAlert()
        }
    }

    private func getAlert() -> Alert {
        Alert(
            title: Text("Game Finished"),
            message: Text(getAlertMessage()),
            primaryButton: .default(Text("Replay"), action: {
                self.presenter.resetGame()
            }),
            secondaryButton: .default(Text("Dismiss")
            )
        )
    }

    private func getAlertMessage() -> String {
        "Correct \($presenter.playerStatus.correctCount.wrappedValue) out of \($presenter.playerStatus.playedCount.wrappedValue)"
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
