//
//  File.swift
//  
//
//  Created by Cedric Gatay on 29/05/2020.
//

import Foundation
import KNativeOrchestrator

struct StringProducer{
    let group = DispatchGroup()
    let queue = DispatchQueue(label: "counting")
    
    func makeString() -> String{
        group.enter()
        var out = ""
        print("<IN> Will load value later...")
        queue.asyncAfter(deadline: .now() + 5){
            out = UUID().uuidString
            print("<IN> Value loaded \(out)")
            self.group.leave()
        }
        group.wait()
        return out
    }
}


class StringConsumer{
    var callCount = 0
    func read(_ in: String){
        callCount += 1
        print("<OUT> StringConsumer called \(callCount) times, last call with : \(`in`)")
    }
}

//this ought to be a kotlin code
class MainTaskImpl{
    
    let kotlinQueue1 = DispatchQueue(label: "kotlinQueue1")
    let kotlinQueue2 = DispatchQueue(label: "kotlinQueue2")
    func runFakeInternalKotlinToSwift(_ out: @escaping (String) -> ()){
        //this simulate coroutine `launch`
        kotlinQueue1.async {
            while true {
                sleep(2)
                out("[K] \(Date().timeIntervalSince1970)")
            }
        }
    }
    
    func runFakeInternalSwiftToKotlin(_ in: @escaping () -> String){
        //this simulate coroutine `launch`
        kotlinQueue2.async{
            while true{
                print("[K] Will gather value")
                sleep(1)
                let swiftValue = `in`()
                print("[K] Value coming from swift world \(swiftValue)")
            }
        }
    }
    
    func run(in: @escaping () -> String, out: @escaping (String) -> ()){
        runFakeInternalKotlinToSwift(out)
        runFakeInternalSwiftToKotlin(`in`)
        var count = 0
        while count < 60{
            sleep(1)
            count += 1
            print("[K] Tick... \(count)")
        }
    }
}
