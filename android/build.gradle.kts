allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// 自动修复第三方库兼容性问题
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    afterEvaluate {
        // 如果该模块是 Android 模块
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension

            // 1. 自动补全缺失的 namespace，防止编译报错
            if (android.namespace == null) {
                android.namespace = "com.fixed_namespace.${project.name.replace("-", "_")}"
            }

            // 2. 强制开启之前报错的 buildConfig
            android.buildFeatures.buildConfig = true
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}