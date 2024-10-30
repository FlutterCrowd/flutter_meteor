//
//  MeteorSerialTaskQueue.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/30.
//

import Foundation

class MeteorSerialTaskQueue {
    private let queue: DispatchQueue
    private let semaphore = DispatchSemaphore(value: 1)

    init(label: String) {
        queue = DispatchQueue(label: label)
    }

    func addTask(_ task: @escaping (@escaping () -> Void) -> Void) {
        queue.async {
            self.semaphore.wait()
            task {
                self.semaphore.signal()
            }
        }
    }

    func addSyncTask(_ task: @escaping () -> Void) {
        queue.async {
            self.semaphore.wait()
            defer {
                self.semaphore.signal()
            }
            task()
        }
    }
}
