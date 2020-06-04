//
//  Created by Cedric Gatay on 29/05/2020.
//

import Foundation

/***
 * Base orchestrator to subclass for specifying types to use for `IN` and `OUT`
 *
 * `IN` type is the type of objects that will be produced by long running task
 * `OUT` type is the type of objects that will be produced on our end and be fed to the long running task
 */
public struct KBaseNativeOrchestrator<IN, OUT>: KNativeOrchestrator{
    public typealias ProviderType = IN
    public typealias Provider = LockingInProvider<ProviderType>
    public typealias ConsumerType = OUT
    public typealias Consumer = LockingOutConsumer<ConsumerType>
    
    private let queue = DispatchQueue(label: "app")
    
    public init(){}
    
    /***
     * main entry point for running a `mainTask`
     * accepting `IN` and `OUT` handlers to communicate both ways
     */
    public func runTool(mainTask: @escaping (@escaping ProviderClosure, @escaping ConsumerClosure) -> (),
                 inProvider: @escaping ProviderClosure,
                 outConsumer: @escaping ConsumerClosure) -> DispatchGroup {
     

        let appGroup = DispatchGroup()
        appGroup.enter()
        queue.async {
            mainTask(LockingInProvider(inProvider).produce,
                     LockingOutConsumer(outConsumer).consume)
            appGroup.leave()
        }
        return appGroup
    }
}


/***
 * In provider implementation dispatching and locking calls to underlying closure in another queue.
 * This allows proper asynchronous processing without locking our main task
 */
public class LockingInProvider<T>: InProvider{
    public typealias ItemType = T
    let wrapped: () -> T
    private let queueIn = DispatchQueue(label: "queueIn", qos: .background, attributes: .concurrent)

    init(_ inClosure: @escaping () -> T){
        self.wrapped = inClosure
    }
    
    public func produce() -> T {
        var result: T!
        let group = DispatchGroup()
        group.enter()
        self.queueIn.async {
            result = self.wrapped()
            group.leave()
        }
        group.wait()
        return result
    }
}

/***
* Out consumer implementation dispatching and locking calls to underlying closure in another queue.
* This allows proper asynchronous processing without locking our main task
*/
public class LockingOutConsumer<T>: OutConsumer{
    public typealias ItemType = T
    let wrapped: (T) -> ()
    private let queueOut = DispatchQueue(label: "queueOut", qos: .background, attributes: .concurrent)
    init(_ outClosure: @escaping (T) -> ()){
        self.wrapped = outClosure
    }
    
    public func consume(_ out: T) {
        let group = DispatchGroup()
        group.enter()
        self.queueOut.async {
            self.wrapped(out)
                group.leave()
            }
        group.wait()
    }
}
