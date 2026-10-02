allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://git.arksigner.com/api/packages/LiveAuth/maven")
            credentials {
                username = "erpa@liveauth.com"
                password = "412b91dae58c7c4eed20261429cff190c70ba719"
            }
        }
        maven {
            url = uri("https://developer.huawei.com/repo/")
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
