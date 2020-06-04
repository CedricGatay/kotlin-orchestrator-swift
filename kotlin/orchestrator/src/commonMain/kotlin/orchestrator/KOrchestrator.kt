package orchestrator

import kotlinx.coroutines.*
import kotlin.native.concurrent.ThreadLocal

expect fun runBlockingCoroutine(closure: suspend (CoroutineScope) -> Unit)

@ThreadLocal
var job: Job? = null
@ThreadLocal
var job2: Job? = null

abstract class KOrchestrator<IN,OUT>{
    fun run(
        closureIn: () -> (IN),
        closureOut: (OUT) -> Unit
    ) = runBlockingCoroutine {
        try {
            withContext(Dispatchers.Unconfined) mainContext@{
                job = launch(Dispatchers.Default) {
                    try {
                        println("[K] Entering outContext")
                        while (true) {
                            sendMessageToClient(closureOut)
                        }
                    } catch (e: CancellationException) {
                        this@mainContext.cancel("End execution from OutContext ${e.message}")
                        job2?.cancel(e)
                        throw e
                    }
                }
                job2 = launch {
                    println("[K] Entering inContext")
                    while (true) {
                        try {
                            onClientMessage(closureIn())
                        } catch (e: CancellationException) {
                            this@mainContext.cancel("End execution from InContext ${e.message}")
                            job?.cancel(e)
                            throw e
                        }
                    }
                }
            }
        } catch (e: CancellationException) {
            println("[K] Exiting execution due to cancellation")
        }

    }
    abstract suspend fun sendMessageToClient(
        closureOut: (OUT) -> Unit
    )

    abstract fun onClientMessage(message: IN)
}
