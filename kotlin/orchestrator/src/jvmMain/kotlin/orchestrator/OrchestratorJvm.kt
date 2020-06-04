package orchestrator

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.runBlocking

actual fun runBlockingCoroutine(closure: suspend (CoroutineScope) -> Unit) {
    runBlocking { closure(this) }
}
