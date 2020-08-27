//
//  SwiftUIView.swift
//  WordPlay
//
//  Created by Mamunul Mazid on 8/21/20.
//

import SwiftUI

struct AnimatableModifierDouble: AnimatableModifier {
    var targetValue: Double

    var animatableData: Double {
        didSet {
            checkIfFinished()
        }
    }

    var completion: () -> Void

    init(bindedValue: Double, completion: @escaping () -> Void) {
        self.completion = completion

        animatableData = bindedValue
        targetValue = bindedValue
    }

    func checkIfFinished() {
        if animatableData == targetValue {
            DispatchQueue.main.async {
                self.completion()
            }
        }
    }

    func body(content: Content) -> some View {
        content
            .animation(nil)
    }
}
