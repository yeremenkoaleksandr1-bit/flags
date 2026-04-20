allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = file("../build")

subprojects {
    project.buildDir = File(rootProject.buildDir, name)
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
