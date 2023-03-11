import Combine

public func captureOutput<P, O>(
    for publisher: P,
    droppingFirst dropCount: Int = 1,
    when block: () async -> Void
) async -> [O] where P: Publisher, P.Failure == Never, P.Output == O {
    var capturedOutput: [O] = []
    
    let publishing = publisher
        .dropFirst(dropCount)
        .sink { capturedOutput.append($0) }

    await block()
    publishing.cancel()
    return capturedOutput
}
