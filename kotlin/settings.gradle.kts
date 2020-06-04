rootProject.name="orchestrator-sample"

val kotlin_version: String by extra

include(":common")
include(":orchestrator")

enableFeaturePreview("GRADLE_METADATA")
