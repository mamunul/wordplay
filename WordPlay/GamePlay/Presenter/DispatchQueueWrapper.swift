//
//  DispatchQueueWrapper.swift
//  Anonymous
//
//  Created by New User on 28/1/20.
//  Copyright © 2020 Mamunul Mazid. All rights reserved.
//

import Foundation

protocol IDispatchQueueWrapper {
    func async(in dispatchQueue: DispatchQueue, work: @escaping () -> Void)
    func sync(in dispatchQueue: DispatchQueue, work: () -> Void)
    func asyncAfter(
        in dispatchQueue: DispatchQueue,
        deadline: DispatchTime,
        execute work: @escaping @convention(block) () -> Void
    )
}

class DispatchQueueWrapper: IDispatchQueueWrapper {
    func async(in dispatchQueue: DispatchQueue, work: @escaping () -> Void) {
        dispatchQueue.async {
            work()
        }
    }

    func sync(in dispatchQueue: DispatchQueue, work: () -> Void) {
        dispatchQueue.sync {
            work()
        }
    }

    func asyncAfter(
        in dispatchQueue: DispatchQueue,
        deadline: DispatchTime,
        execute work: @escaping @convention(block) () -> Void
    ) {
        dispatchQueue.asyncAfter(deadline: deadline) {
            work()
        }
    }
}
