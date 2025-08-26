
import Foundation
import DiiaCommonTypes

public func onMainQueue(_ block: @escaping Callback) {
    DispatchQueue.main.async(execute: block)
}

public func onGlobalUtilityQueue(_ block: @escaping Callback) {
    DispatchQueue.global(qos: .utility).async(execute: block)
}

public func onGlobalQueue(qos: DispatchQoS.QoSClass = .utility, _ block: @escaping Callback) {
    DispatchQueue.global(qos: qos).async(execute: block)
}

public func onMainQueueAfter(time: TimeInterval, _ block: @escaping Callback) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: block)
}
