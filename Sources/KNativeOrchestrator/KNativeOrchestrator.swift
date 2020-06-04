import Foundation
/***
 * Abstract protocol describing the way for Swift code to invoke a long running task
 * with proper `IN` / `OUT` handling.
 *
 * @see KBaseNativeOrchestrator for an implementation
 */
public protocol KNativeOrchestrator {
    typealias ProviderClosure = () -> ProviderType
    typealias ConsumerClosure = (ConsumerType) -> ()
    associatedtype ProviderType
    associatedtype ConsumerType
    associatedtype Provider: InProvider where Provider.ItemType == ProviderType
    associatedtype Consumer: OutConsumer where Consumer.ItemType == ConsumerType
    func runTool(
        mainTask: @escaping (@escaping ProviderClosure, @escaping ConsumerClosure) -> (),
        inProvider: @escaping ProviderClosure,
        outConsumer: @escaping ConsumerClosure
    ) -> DispatchGroup
}

public protocol InProvider{
    associatedtype ItemType
    func produce() -> ItemType
}

public protocol OutConsumer {
    associatedtype ItemType
    func consume(_ in: ItemType)
}
