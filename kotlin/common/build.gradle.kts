import org.jetbrains.kotlin.gradle.plugin.mpp.KotlinNativeTarget
import org.jetbrains.kotlin.gradle.tasks.FatFrameworkTask

plugins {
    kotlin("multiplatform")
}

group = "io.ct.kotlin.orchestrator"
version = "1.0.0-SNAPSHOT"


repositories {
    mavenLocal()
    google()
    jcenter()
    mavenCentral()
}

kotlin {
    /* Targets configuration omitted.
    *  To find out how to configure the targets, please follow the link:
    *  https://kotlinlang.org/docs/reference/building-mpp-with-gradle.html#setting-up-targets */
    jvm()
    val isWinHost = System.getProperty("os.name").startsWith("Windows", ignoreCase = true)
    if (!isWinHost) {
        linuxX64("linux") {
            binaries {
                sharedLib()
            }
        }
    }

    ios("ios") {
        binaries {
            framework()
        }
    }

    sourceSets {
        val commonMain by getting {
            dependencies {
                implementation(kotlin("stdlib-common"))
                implementation(project(":orchestrator"))
            }
        }
        val commonTest by getting {
            dependencies {
                implementation(kotlin("test-common"))
                implementation(kotlin("test-annotations-common"))
            }
        }
        val jvmMain by getting {
            dependencies {
                implementation(kotlin("stdlib-jdk8"))
            }
        }
        val jvmTest by getting {
            dependencies {
                implementation(kotlin("test-junit"))
            }
        }
        if (!isWinHost) {
            val linuxMain by getting {
                dependencies {
                }
            }
        }
        val iosMain by getting {
            dependencies {
                implementation(kotlin("stdlib"))
            }
        }
    }

    sourceSets.all {
        languageSettings.useExperimentalAnnotation("kotlin.ExperimentalStdlibApi")
    }

    // Create a task building a fat framework.
    tasks.create("createFatFramework", FatFrameworkTask::class) {
        val buildType: String = project.findProperty("kotlin.build.type")?.toString() ?: "DEBUG"

        // The fat framework must have the same base name as the initial frameworks.
        baseName = "orchestrator"

        // The default destination directory is '<build directory>/fat-framework'.
        destinationDir = buildDir.resolve("${baseName}/${buildType.toLowerCase()}")

        val iosTargets = listOf(targets.findByName("iosArm64") as? KotlinNativeTarget, targets.findByName("iosX64") as? KotlinNativeTarget)
        // Specify the frameworks to be merged.
        val frameworksBinaries = iosTargets.mapNotNull { it?.binaries?.getFramework(buildType) }
        from(frameworksBinaries)
        dependsOn(frameworksBinaries.map { it.linkTask })

        // disable gradle's up to date checking
        outputs.upToDateWhen { false }

        doLast {
            val srcFile: File = destinationDir
            val targetDir = System.getProperty("configuration.build.dir") ?: project.buildDir.path
            println("\uD83C\uDF4E Copying ${srcFile} to ${targetDir}")
            copy {
                from(srcFile)
                into(targetDir)
                include("*.framework/**")
                include("*.framework.dSYM/**")
            }
        }
    }
}
