//
//  NodeManager.swift
//  Eklair
//
//  Created by Thomas CARTON on 03/04/2020.
//

import Foundation
import KNativeOrchestrator
import orchestrator

public class NodeManager {
    var counter = 0
    private var pause = 1000
    var item: DispatchWorkItem?
    let eklairQueue = DispatchQueue(label: "nodeManagerQueue", qos: .background)
    let workGroup = DispatchGroup()

    func updatePause(_ pause: Float){
        self.pause = Int(pause * 1000)
        workGroup.leave()
    }

    func startInOut(closure: @escaping () -> Void, closureOut: @escaping (String) -> Void) {
        let orchestrator = KBaseNativeOrchestrator<String, String>()
        let group = orchestrator.runTool(
            mainTask: OrchestratorKt.runApp,
                inProvider: closureToStopCount,
                outConsumer: closureOut)
        group.notify(queue: .main) {
            self.stopInOut()
        }


        item = DispatchWorkItem { [weak self] in
            var counter = 0
            while self?.item?.isCancelled == false {
                print(counter)
                counter += 1

                closure()
                sleep(1)
            }
        }

        eklairQueue.async(execute: item!)
    }

    func closureToStopCount() -> String{
        workGroup.enter()
        workGroup.wait()
        if pause == -1 {
            return "STOP"
        }
        return String(pause)
    }

    func closureOut(out: String) -> String{
     return out
    }

    func stopInOut() {
        pause = -1 //magic count to stop the world for the POC
        workGroup.leave()
        item?.cancel()
    }

}
