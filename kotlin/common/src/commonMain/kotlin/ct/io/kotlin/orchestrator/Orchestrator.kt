package ct.io.kotlin.orchestrator
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.cancel
import kotlinx.coroutines.delay
import orchestrator.KOrchestrator
var pauseDuration = 5000
var counter = 0


class Orchestrator : KOrchestrator<String, String>() {
    init {
        println("[K] <Initializing Orchestrator>")
    }

    override suspend fun sendMessageToClient(closureOut: (String) -> Unit) {
        println("[K] sendMessageToClient ${counter}")
        closureOut("${counter++}")
        delay(pauseDuration.toLong())
    }

    override fun onClientMessage(message: String) {
        println("[K] Got client message ${message}")
        if (message == "STOP") {
            throw CancellationException("Execution terminated")
        } else {
            message.toIntOrNull(10)?.let {
                pauseDuration = it
                println("[K] Changed pause duration to $it")
            }
        }
    }
}

fun runApp(
    closureIn: () -> (String),
    closureOut: (String) -> Unit
) = Orchestrator().run(closureIn, closureOut)

