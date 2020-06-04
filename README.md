# KNativeOrchestrator

A base orchestrator allowing to run long running task and input / output flows

See how they are used with Eklair samples


## Main goals

The main goal of this package is to abstract orchestration of long running task and input / output.

Current use case is bridging calls to a kotlin/native library that uses multiple coroutines:
 
  * One main coroutine that is a long running one (a `mainLoop`)
  * An input handling coroutine that sits until input is returned from `Swift` end
  * An output handling  coroutine that is `suspended`on `Kotlin` side
  
## Usage

Instanciate `KNativeBaseOrchestrator` with proper type arguments for `IN` and `OUT`parameters and implements closure for each types :
 
  * `() -> IN` or a function with this signature
  * `(OUT) -> ()` or a function with this signature
  

## Example

See `KNativeTestJobs.swift` file for example of producer and consumer implementations and a fake Kotlin side implementation aswell 
