import Combine
import Foundation

public func captureIsMainThread<P>(
    for publisher: P,
    droppingFirst dropCount: Int = 1,
    when block: () async -> Void
) async -> [Bool] where P: Publisher, P.Failure == Never {
    var capturedIsMainThread: [Bool] = []

    let publishing = publisher
        .dropFirst(dropCount)
        .sink { _ in capturedIsMainThread.append(Thread.isMainThread) }

    await block()
    publishing.cancel()
    return capturedIsMainThread
}
