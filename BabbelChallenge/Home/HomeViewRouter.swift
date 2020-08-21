//
//  HomeViewRouter.swift
//  BabbelChallenge
//
//  Created by Mamunul Mazid on 8/21/20.
//

import Foundation
import SwiftUI

struct HomeViewRouter {
    func routeToGameView() -> some View {
        GameViewRouter().route()
    }
}
