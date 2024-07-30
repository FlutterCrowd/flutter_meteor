//
//  FMSerialTaskQueue.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/30.
//

import Foundation

class FMSerialTaskQueue {
    
    private let queue: DispatchQueue
    private let semaphore = DispatchSemaphore(value: 1)
    
    init(label: String) {
        self.queue = DispatchQueue(label: label)
    }
    
    func addTask(_ task: @escaping (@escaping () -> Void) -> Void) {
        queue.async {
            self.semaphore.wait()
            DispatchQueue.main.async {
                task {
                    self.semaphore.signal()
                }
            }
        }
    }
    
    func addSyncTask(_ task: @escaping () -> Void) {
        queue.async {
            self.semaphore.wait()
            task()
            self.semaphore.signal()
        }
    }
}
