package orchestrator

import kotlin.coroutines.CoroutineContext
import kotlinx.coroutines.*
import kotlinx.coroutines.Dispatchers.Main
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.*


actual fun runBlockingCoroutine(closure: suspend (CoroutineScope) -> Unit) {
    runBlocking { closure(this) }
}
