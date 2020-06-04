plugins {
    kotlin("multiplatform")
}
repositories {
    mavenCentral()
    google()
    jcenter()
}

group = "io.c-t"
version = "1.0.0"

kotlin {
    jvm()
    // This is for iPhone simulator
    // Switch here to iosArm64 (or iosArm32) to build library for iPhone device
    linuxX64("linux") {
        binaries {
            sharedLib()
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
                implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.3.5-native-mt")
                implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core-common:1.3.5-native-mt")
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
                implementation(kotlin("stdlib"))
            }
        }
        val jvmTest by getting {
            dependencies {
                implementation(kotlin("test"))
                implementation(kotlin("test-junit"))
            }
        }
        val linuxMain by getting {
            dependencies{
                implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core-native:1.3.5-native-mt")
            }
        }
        val iosMain by getting {
            dependencies {
                implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core-native:1.3.5-native-mt")
            }
        }
        val iosTest by getting {
        }
    }
    sourceSets.all {
        languageSettings.useExperimentalAnnotation("kotlin.ExperimentalStdlibApi")
    }
}
