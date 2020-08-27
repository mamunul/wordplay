//
//  GameView.swift
//  WordPlay
//
//  Created by Mamunul Mazid on 8/21/20.
//

import Combine
import SwiftUI

struct GameViewTheme {
    static let wordColor = Color.black
    static let wordFont = Font.system(size: 25)
    static let translationColor = Color.blue
    static let translationFont = Font.system(size: 25)
    static let gameFinishedAlertTitle = "Game Finished"
    static let gameFinishedAlertReplayButtonTitle = "Game Finished"
    static let gameFinishedAlertDismissButtonTitle = "Game Finished"
    static let translationSelectButtonTitle = "Select Translation"
}

struct MovingView<Presenter: IGamePlayPresenter>: View {
    @ObservedObject var presenter: Presenter
    @Binding var percentage: Double
    var body: some View {
        GeometryReader { geometry in
            Text(self.presenter.translation)
                .foregroundColor(GameViewTheme.translationColor)
                .font(GameViewTheme.translationFont)
                .padding()
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

struct GameView<Presenter: IGamePlayPresenter>: View {
    @ObservedObject var presenter: Presenter
    @State var statusMessage: String = ""
    @State var color = Color.green
    @State var showAlert = false
    var body: some View {
        ZStack {
            VStack {
                Text(self.presenter.word)
                    .foregroundColor(GameViewTheme.wordColor)
                    .font(GameViewTheme.wordFont)
                    .padding()
                Spacer()
                Button(action: {
                    self.presenter.onTranslationSelected()
                }) {
                    Text(GameViewTheme.translationSelectButtonTitle).padding()
                }
            }
            MovingView(
                presenter: self.presenter,
                percentage: self.$presenter.movePercentage
            )

            Text(self.statusMessage)
                .foregroundColor(self.color)
        }
        .onReceive(Just(self.presenter.queryStatus)) { status in
            (self.statusMessage, self.color) = status.getTextAndColor()
        }
        .onAppear {
            self.presenter.startPlaying()
        }
        .alert(isPresented: self.$presenter.isGameEnded) {
            getAlert()
        }
    }

    private func getAlert() -> Alert {
        Alert(
            title: Text(GameViewTheme.gameFinishedAlertTitle),
            message: Text(getAlertMessage()),
            primaryButton:
            .default(Text(GameViewTheme.gameFinishedAlertReplayButtonTitle),
                     action: {
                         self.presenter.startPlaying()
                     }
            ),
            secondaryButton: .default(Text(GameViewTheme.gameFinishedAlertDismissButtonTitle)
            )
        )
    }

    private func getAlertMessage() -> String {
        "Correct \($presenter.playerStatus.correctCount.wrappedValue) out of \($presenter.playerStatus.playedCount.wrappedValue)"
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(presenter: GamePlayPresenter())
    }
}
