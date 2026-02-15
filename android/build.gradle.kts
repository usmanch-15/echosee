allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "androidx.browser" && requested.name == "browser") {
                useVersion("1.8.0")
            }
            if (requested.group == "androidx.core" && (requested.name == "core" || requested.name == "core-ktx")) {
                if (requested.version?.startsWith("1.17") == true || requested.version?.startsWith("1.15") == true) {
                    useVersion("1.13.1")
                }
            }
        }
    }
}

subprojects {
    plugins.all {
        if (this.javaClass.name.contains("com.android.build.gradle.LibraryPlugin")) {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                    val namespaceMethod = android.javaClass.methods.find { it.name == "setNamespace" && it.parameterTypes.size == 1 && it.parameterTypes[0] == String::class.java }
                    // Special case for vosk_flutter to match its Manifest package
                    val targetNamespace = if (project.name == "vosk_flutter") "org.vosk.vosk_flutter" else "com.echosee.dependency.${project.name.replace(":", ".")}"
                    namespaceMethod?.invoke(android, targetNamespace)
                } catch (e: Exception) {
                    // Ignore
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
