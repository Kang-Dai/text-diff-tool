pipeline {
    agent any

    environment {
        MAVEN_HOME = tool 'Maven 3.8.x'
        JAVA_HOME = tool 'JDK 8'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh "${MAVEN_HOME}/bin/mvn clean package -DskipTests"
            }
        }

        stage('Create Portable') {
            steps {
                sh '''
                    mkdir -p dist/portable
                    cp target/text-diff-tool-1.0.0.jar dist/portable/
                    cp TextDiffTool.bat dist/portable/
                    cp "给用户的说明.txt" dist/portable/说明.txt
                '''
            }
        }

        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'dist/portable/*', fingerprint: true
            }
        }

        stage('Build Installer') {
            when {
                anyOf {
                    branch 'main'
                    branch 'master'
                    tag pattern: "v\\d+\\.\\d+\\.\\d+", comparator: "REGEXP"
                }
            }
            steps {
                // 需要在Jenkins节点安装Inno Setup
                bat '"C:\\Program Files (x86)\\Inno Setup 6\\ISCC.exe" install-script.iss'
            }
        }

        stage('Upload Installer') {
            when {
                tag pattern: "v\\d+\\.\\d+\\.\\d+", comparator: "REGEXP"
            }
            steps {
                archiveArtifacts artifacts: 'dist/installer/*.exe', fingerprint: true
            }
        }
    }

    post {
        success {
            echo '构建成功！'
        }
        failure {
            echo '构建失败！'
        }
    }
}
