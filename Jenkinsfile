#!groovy
@Library('jenkinsbuild-libs')
import de.adito.aditoweb.jenkinsbuild.util.FileUtility

//noinspection GroovyAssignabilityCheck
node {

  def buildStages

  def javaHome = tool name: 'openjdk13latest', type: 'jdk'
  def javaHomeInstaller = tool name: 'jdk10latest', type: 'jdk'
  def mavenHome = tool name: 'maven_3.6.3', type: 'maven'

  //noinspection GroovyAssignabilityCheck
  withEnv([

      "JAVA_HOME=${javaHome}",
      "MAVEN_HOME=${mavenHome}",
      "PATH+JAVA=${javaHome}/bin",
      "PATH+MAVEN=${mavenHome}/bin",
      //"DOCKER_TLS_VERIFY=${env.DEFAULT_DOCKER_TLS_VERIFY}",
      //"DOCKER_HOST=${env.DEFAULT_DOCKER_HOST}",
      "INSTALL4J_JAVA_HOME=${javaHomeInstaller}",
      "MAVEN_OPTS=-Xmx2048M -Xss256M -XX:MetaspaceSize=1024M -XX:MaxMetaspaceSize=2048M -XX:+CMSClassUnloadingEnabled -XX:+UseConcMarkSweepGC",
      "DOCKER_BUILDKIT=1"
  ]) {

    def ADITO_BuildVersionReadable // Human readable version (4.6.110_RC5)

    /**
     * Prepares the Build to be executed.
     * Declaring properties the pipeline needs, checkout GIT-Repository
     */
    stage('Preparation') {

      // Fetches the tags and offers a list to choose one
      def paramTag = [$class       : 'ListGitBranchesParameterDefinition',
                      name         : 'tag',
                      remoteURL    : "git@gitintern.aditosoftware.local:devs/aditoonline.git",
                      description  : "Gibt den spezifischen Tag an, der gebaut werden soll.",
                      credentialsId: "7c3abcc5-9c48-4d07-810d-61121d78f641",
                      type         : "PT_TAG",
                      tagFilter    : getPipelineVersion().tagsPrefix,
                      sortMode     : 'DESCENDING_SMART',
      ]

      properties([
              disableConcurrentBuilds(),
              // Parameterized Build
              [$class: 'ParametersDefinitionProperty', parameterDefinitions: [
                      paramTag,
                      [$class: 'BooleanParameterDefinition', name: 'publishOnFiler', defaultValue: true, description: "Gibt an, ob der Build auf den ADITO-Filer kopiert werden soll (wenn erfolgreich)."],
                      [$class: 'BooleanParameterDefinition', name: 'publishOnFeed', defaultValue: false, description: "Gibt an, ob der Build auf den FTP-Server hochgeladen und im Feed eingetragen werden soll (wenn erfolgreich)."],
                      [$class: 'BooleanParameterDefinition', name: 'sendMailOnSuccess', defaultValue: true, description: "Schickt im erfolgsfall eine Benachrichtigung an die IT."],
                      [$class: 'BooleanParameterDefinition', name: 'cleanWorkspace', defaultValue: false, description: "Leert den Workspace vor dem Build."],
                      [$class: 'BooleanParameterDefinition', name: 'skipIntegrationTests', defaultValue: false, description: "Ignoriert die Integrationstests. Sinnvoll fürs Testen der Pipeline."],
                      [$class: 'BooleanParameterDefinition', name: 'skipDesignerPlugins', defaultValue: false, description: "Für Testzwecke: Update der Designer-Plugin-Kataloge überspringen."],
                      [$class: 'BooleanParameterDefinition', name: 'skipDockerBuild', defaultValue: false, description: "Überspringt das Bauen der Docker images (neu lokale Builds)."]
              ]]
      ])

      // Wenn der Parameter true ist, wird beim Checkout der Workspace geleert
      // Hintergrund: Wenn man "Scan Multibranch Pipeline Now" ausführt, startet er einen Build und nimmt einen zufälligen Tag
      // Offenbar kommt es dabei manchmal zu Problemen, die dazu führen, dass Klassen doppelt vorhanden sind.
      // Dadurch ist kein Build mehr möglich
      def extensions = []
      if (params.cleanWorkspace)
        extensions = [[$class: 'CleanBeforeCheckout']]

      // Grab git project[[name: "${params.TAG}"]]
      String defaultTagFilter = "tags/" + getPipelineVersion().tagsPrefix
      checkout changelog: true, poll: false, scm:
          [$class                           : 'GitSCM', branches: [[name:  (params.tag.isEmpty() ? "*/${defaultTagFilter}" : params.tag)]],
           browser                          : [$class: 'GitLab', repoUrl: "${env.ADITOONLINE_REPO_URL_HTTPS}", version: '8.10'],
           doGenerateSubmoduleConfigurations: false, extensions: extensions, submoduleCfg: [], userRemoteConfigs:
               [[credentialsId: '7c3abcc5-9c48-4d07-810d-61121d78f641', name: 'origin',
                 refspec      : (params.tag.isEmpty() ? "+refs/${defaultTagFilter}:refs/remotes/origin/${defaultTagFilter}" : params.tag),
                 url          : "${env.ADITOONLINE_REPO_URL_SSH}" ]]]

    }

    /**
     * Executes the main maven Build-Step without IntegrationTests.
     * Updates the displayName of the current Build, to ensure the enduser knows what to do with this build
     */
    stage('Build') {
      def fullVersion = getVersionWithHotfixWithoutPostfix("${params.tag}")
      try {
        sh """sed -i 's/\${adito.complete.final.version}/${fullVersion}/' addendum/assemblydesigner/buildresources/ADITOdesigner.conf"""
      } catch (e) {
        echo "Designer version replacement in ADITOdesigner.conf failed."
      }
      try
      {
        def buildSuffix = ""
        maven('.', 'clean install -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion().m2Folder + ' -T 1C -e ' +
                  '-P adito.maven.resources,adito.maven.javadoc,adito.production ' +
                  '-DJOB_NAME=${JOB_NAME} ' +
                  '-Dadito.build.version=\"' + getAditoMajorVerson() + '\" -Dadito.build.suffix=\"' + buildSuffix + '\"')


        // Builds the experimental and as of yet empty adito-designer project. In the future the ADITODesigner will be its own project and has to be built before the
        // ao project because it will be a dependency of the ao project. After clean installing the adito-designer, it will be available as a .zip file in the .m2
        // folder and can be used to create the final ao artifact
        withCredentials([
            sshUserPrivateKey(
                credentialsId: "ea4c430c-9650-4d51-899c-1d702ecad71e",
                keyFileVariable: 'keyFileVar')
        ]) {
          sh """
                rm -rf adito-designer
                export GIT_SSH_COMMAND="ssh -i ${keyFileVar}"
                git clone -b "${params.tag}" ${env.ADITO_DESIGNER_REPO_URL_SSH}
           """
        }
        // skipping tests because the designer itself should have tests in its CI, and no Tag should be set if those tests fail
        maven('adito-designer', 'clean install -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion().m2Folder + ' -T 1C -e -DskipTests')
        sh """rm -rf adito-designer"""

        maven('addendum', 'clean install -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion().m2Folder + ' -e ' +
            '-P adito.maven.assembly,adito.maven.resources,adito.maven.installer,adito.maven.javadoc,adito.production ' +
            '-DJOB_NAME=${JOB_NAME} ' +
            '-Dadito.build.version=\"' + getAditoMajorVerson() + '\" -Dadito.build.suffix=\"' + buildSuffix + '\"')

        // Add "-Candidate" to indicate builds which are not manually approved as "done"
        currentBuild.displayName = getVersionWithHotfixPostfix()
      }
      catch (pErr)
      {
        // Collect result on failure
        step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
        if (currentBuild.result == 'UNSTABLE')
          currentBuild.result = 'FAILURE'
        throw pErr
      }

      buildStages = prepareBuildStages()
    }


    /**
     * Parallel execution of some stages.
     */
    for (builds in buildStages) {
      parallel(builds)
    }

    /**
     * Collect all results to show on jenkins-jobPage and archive all artifacts we have.
     */
    stage('Results') {
      junit '**/target/surefire-reports/TEST-*.xml, **/target/failsafe-reports/TEST-*.xml'

      archiveArtifacts artifacts: 'docs/target/*_internal-doc.zip, ' +
          'library/server/target/server-*-javadoc.jar, ' +
          'library/server/target/generated-sources/annotations/jsStubs/js_stub_output.txt, ' +
          'addendum/buildtools/target/releasenotes*.pdf',
                       excludes: "addendum/assembly/target/output.txt, addendum/assembly/target/updates.xml",
                       onlyIfSuccessful: true

      // perform a clean in order to remove the installers and other files that are no longer needed (installers are copied to the filer, docker images are on docker).
      // this keeps the storage needed for the jenkins pipeline low
      maven(".", 'clean -P adito.maven.assembly,adito.maven.resources,adito.maven.installer,adito.maven.javadoc,adito.production')

      // send email if build was successful
      if (currentBuild.currentResult == 'UNSTABLE' || currentBuild.currentResult == 'SUCCESS')
      {
        // Report Error with mail to users
        sendNotificationMail()
      }
    }

  }
}

@NonCPS
String _getPreviousBuildID()
{
  def prevBuild = currentBuild.rawBuild.getPreviousBuild()
  return prevBuild.getEnvironment()['BUILD_ID']
}

void sendNotificationMail()
{
    if(params.sendMailOnSuccess == true)
    {
        String emailToString = '$DEFAULT_RECIPIENTS'
        String subject = "Jenkins: Build \'${currentBuild.displayName}\' in Pipeline \'${JOB_NAME}\' wurde erfolgreich gebaut"
        String content = "Build \'${currentBuild.displayName}\' (${BUILD_URL}) in Pipeline \"${JOB_NAME}\" war erfolgreich."

        echo "sending mail to ${emailToString} with content \'" + content + "\'"
        emailext attachLog: true, body: content, subject: subject, to: '$DEFAULT_RECIPIENTS'
    }
}


def maven(String pWorkingDir, String pParams)
{
  configFileProvider([configFile(fileId: 'adito-maven-settings-install4j8', variable: 'MAVEN_SETTINGS'),
                      configFile(fileId: 'adito-default-maven-toolchains', variable: 'MAVEN_TOOLCHAINS')]) {
    if (isUnix())
      sh "cd ${pWorkingDir} && mvn -s ${MAVEN_SETTINGS} -t ${MAVEN_TOOLCHAINS} ${pParams}"
    else
      bat(/mvn -s ${MAVEN_SETTINGS} -t ${MAVEN_TOOLCHAINS} ${pParams}/)
  }
}

// Create List of build stages to suit
def prepareBuildStages() {
  def buildList = []

  def buildStages = [:]
  buildStages.put("Deploy new Jdito-Types version", deployJditoTypes("Deploy Jdito-Types"))
  buildStages.put("Integration Tests Parallel", prepareIntegrationTestsBuildStage("Integration Tests Parallel"))
  buildStages.put("Deployment Parallel", prepareDeploymentBuildStage("Deployment Parallel"))
  buildStages.put("Designer Plugins", prepareDesignerPluginsBuildStage("Designer Plugins"))
  buildList.add(buildStages)
  return buildList
}

def prepareIntegrationTestsBuildStage(String name) {
  return {
    stage(name) {

      try {
        if (!params.skipIntegrationTests) {
          // Executes integration-tests defined inside the SourceCode
          maven('.', 'failsafe:integration-test -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion().m2Folder + ' -T 1C ' +
                  '-P adito.maven.testalldatabaseversions ' +
                  '-Dtestcontainers.environmentprovider.timeout=10 ' +
                  '-Dadito.debug=true') // activate debug-mode to show NetBeans-WorkingDir on IntegrationTest startup
        }
      } catch (e) {
        echo "Integration tests failed: " + e.getMessage();
        // build unstable but not failed
        if (currentBuild.currentResult == 'SUCCESS')
          currentBuild.result = 'UNSTABLE'
      }
    }
  }
}

// Stage that builds the release notes, packages the project and after that deploys the project to the filer
// and the atom feed (webserver).
def prepareDeploymentBuildStage(String name) {
  return {

    /**
     * Creates the downloadable ZIP-File which contains a bunch of dat-Files to create
     * the selfextracing installers.
     */
    stage('Packaging') {

      echo "Packaging installation packages..."
      String targetDir = "target/installer"
      String artifactsDir = "addendum/assembly/target"
      String artifactsLibs = "${artifactsDir}/ADITO_libs.dat/ADITO_libs.4197.dat ${artifactsDir}/ADITO_libs.dat/ADITO_libs.4435.dat ${artifactsDir}/ADITO_libs.dat/ADITO_libs.4436.dat ${artifactsDir}/ADITO_libs.dat/ADITO_libs.4438.dat"
      String artifactsUnix = "${artifactsDir}/ADITO_unix.dat/ADITO_unix.0.dat ${artifactsDir}/ADITO_unix.dat/ADITO_unix.169.170.171.348.dat ${artifactsDir}/ADITO_unix.dat/ADITO_unix.167.dat ${artifactsDir}/ADITO_unix.dat/ADITO_unix.169.dat ${artifactsDir}/ADITO_unix.dat/ADITO_unix.170.dat ${artifactsDir}/ADITO_unix.dat/ADITO_unix.171.dat ${artifactsDir}/ADITO_unix.dat/ADITO_unix.175.dat"
      String artifactsMacos = "${artifactsDir}/ADITO_macos.dat/ADITO_macos.0.dat ${artifactsDir}/ADITO_macos.dat/ADITO_macos.169.170.171.348.dat ${artifactsDir}/ADITO_macos.dat/ADITO_macos.167.dat ${artifactsDir}/ADITO_macos.dat/ADITO_macos.169.dat ${artifactsDir}/ADITO_macos.dat/ADITO_macos.170.dat ${artifactsDir}/ADITO_macos.dat/ADITO_macos.171.dat ${artifactsDir}/ADITO_macos.dat/ADITO_macos.175.dat"
      String artifactsWin64 = "${artifactsDir}/ADITO_windows-x64.dat/ADITO_windows-x64.0.dat ${artifactsDir}/ADITO_windows-x64.dat/ADITO_windows-x64.169.170.171.348.dat ${artifactsDir}/ADITO_windows-x64.dat/ADITO_windows-x64.167.dat ${artifactsDir}/ADITO_windows-x64.dat/ADITO_windows-x64.169.dat ${artifactsDir}/ADITO_windows-x64.dat/ADITO_windows-x64.170.dat ${artifactsDir}/ADITO_windows-x64.dat/ADITO_windows-x64.171.dat ${artifactsDir}/ADITO_windows-x64.dat/ADITO_windows-x64.175.dat"
      String artifactInstallers = "${artifactsDir}/*.dmg ${artifactsDir}/*.sh ${artifactsDir}/*.exe ${artifactsDir}/.installdata"
      String artifactSFX = "addendum/sfx/target/sfx.jar addendum/sfx/target/sfx.bat addendum/sfx/target/libs"
      String installerName = FileUtility.getFreeFileName(this, "target", "ADITO_${getAditoVersionReadable()}_installers", "zip")

      sh """
        mkdir -p ${targetDir}; 
        mkdir ${targetDir}/ADITO_libs.dat; 
        mkdir ${targetDir}/ADITO_unix.dat; 
        mkdir ${targetDir}/ADITO_macos.dat; 
        mkdir ${targetDir}/ADITO_windows-x64.dat;
        mkdir ${targetDir}/sfx

        mv -t ${targetDir}/ ${artifactInstallers};
        mv -t ${targetDir}/ADITO_libs.dat ${artifactsLibs};
        mv -t ${targetDir}/ADITO_unix.dat ${artifactsUnix};
        mv -t ${targetDir}/ADITO_macos.dat ${artifactsMacos};
        mv -t ${targetDir}/ADITO_windows-x64.dat ${artifactsWin64};
        mv -t ${targetDir}/sfx ${artifactSFX};

        rm ${targetDir}/ADITO_libs.exe
      """

      zip archive: true,
              dir: "${targetDir}",
              glob: '',
              zipFile: "target/${installerName}"

      // Execute sfx-creator, to create executable installers
      String sfxCreationDir = "target/installer"
      sh "cd ${sfxCreationDir}/sfx && java -cp \"sfx.jar:libs/*\" de.adito.aditoweb.sfx.InstallerCreator .."
      sh "cp target/installer/ADITO_unix.tar.gz addendum/assembly/target/"
      sh "cp -r target/installer/.installdata addendum/assembly/target/"

    }


    stage('Docker Build Server') {
      if (!params.skipDockerBuild) {
        ADITO_BuildVersionReadable = getVersionWithHotfixPostfix()
        dir("addendum/assembly/target") {
          docker.withRegistry("https://index.docker.io/v1/", "DOCKERHUB") {
            docker.build("adito/adito:" + ADITO_BuildVersionReadable, "-f Dockerfile .").push()
          }
        }
      }
    }

    stage('Docker Build Designer') {
      if (!params.skipDockerBuild) {
        ADITO_BuildVersionReadable = getVersionWithHotfixPostfix()
        dir("addendum/assembly/target") {
          docker.withRegistry("https://index.docker.io/v1/", "DOCKERHUB") {
            docker.build("adito/aditodesigner:" + ADITO_BuildVersionReadable, "-f Dockerfile_designer .").push()
          }
        }
      }
    }

    stage('Docker Build Project Deploy') {
      if (!params.skipDockerBuild) {
        ADITO_BuildVersionReadable = getVersionWithHotfixPostfix()
        dir("addendum/assembly/target") {
          docker.withRegistry("https://index.docker.io/v1/", "DOCKERHUB") {
            docker.build("adito/aditodeploy:" + ADITO_BuildVersionReadable, "-f Dockerfile_deploy .").push()
          }
        }
      }
    }

      stage('Docker Cleanup') {
        if (!params.skipDockerBuild) {
          echo "executing forced docker image prune"
          sh """
          docker image prune -f
          """
        }
      }

    /**
     * Generates the ReleaseNotes
     */
    stage('ReleaseNotes') {

      try {
        echo "Preparingrelease notes..."
//          maven('.', 'org.apache.maven.plugins:maven-dependency-plugin:unpack ')
        maven('.', 'dependency:unpack -f addendum/buildtools/pom.xml')
      } catch(e) {
        echo "Preparation for release notes failed: " + e.getMessage();
      }

      try {
        def aditoBuildVersion = getAditoVersion()
        echo "Creating core release notes for version ${aditoBuildVersion}..."
        maven('.', 'org.codehaus.mojo:exec-maven-plugin:1.5.0:java -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion().m2Folder + ' ' +
                '-P adito.maven.releasenotes ' +
                '-Dexec.mainClass=de.adito.releasenotes.changelogs.ChangeLogRangeCreator ' +
                '-Dexec.args="neon2.adito.de ' + getPipelineVersion().releaseNotesStart + ' ' + aditoBuildVersion + ' addendum/buildtools/target/releasenotes.html 1b9345d8-f9db-408b-b73a-638a52f8deb6 Plattform Infrastruktur@dc132bdc-4f7f-453e-bf66-c5b676dca4fd Neon@c50d6aa8-0eb9-4ece-bc43-7328d3b7979e Designer@9626f9e9-277b-4136-bde1-90d1d8d0f6c5 Allgemein@41b6fab1-97a2-412f-9528-25def6ca3f32 Contact-Management@3fa7f11a-11d9-40b3-9d13-f86e99c5ea6f Marketing@20076a51-cfd5-4bcc-8f5d-29d7dd5a7cad Sales@d032502e-4679-4163-a5ed-566e5402d3cc Service@d69856d7-a9be-41f5-98cc-6ae4de20a754" ' +
                '-f addendum/buildtools/pom.xml')
      } catch(e) {
        echo "Release notes creation for Adito core failed: " + e.getMessage();
      }
    }


    /**
     * Deploy the result on ADITO-Filer, if necessary.
     */
    stage('Deploy') {

      echo "Deploying the installation packages..."
      if(params.publishOnFiler == true)
      {
        // paths
        String sfxCreationDir = "target/installer"
        String tempFilerPath = "target/deploy/filer"
        def majorVersion = getAditoMajorVerson();
        def buildVersion = getAditoVersionReadable();
        def buildVersionWithHotfix = getVersionWithHotfixPostfix();

        String buildPathOnFiler = "${majorVersion}/" // will be like: "2020/2020.2.0/RC8" or "2020/2020.2.0"

        if (isReleaseCandiateOrTestVersion())
        {
          if (isHotfix()) {
            def split = buildVersion.split("_")
            buildPathOnFiler += split[0] + "." + getHotfixVersion() + "/" + split[1]
          } else {
            def split = buildVersion.split("_")
            buildPathOnFiler += split[0] + "/" + split[1]
          }
        }
        else {
          if (isHotfix()) {
            buildPathOnFiler += buildVersion + "." + getHotfixVersion()
          } else {
            buildPathOnFiler += buildVersion
          }
        }

        def fileNameWithVersion = buildVersion;
        if (isHotfix())
          fileNameWithVersion = buildVersionWithHotfix;

        // Move necessary files to temporary tempFilerPath-directory
        // cp statt mv wegen feed step
        sh """
        mkdir -p ${tempFilerPath}/${buildPathOnFiler}
        mv ${sfxCreationDir}/ADITO_macos.zip ${tempFilerPath}/${buildPathOnFiler}/ADITO_${fileNameWithVersion}_macos.zip
        mv ${sfxCreationDir}/ADITO_unix.tar.gz ${tempFilerPath}/${buildPathOnFiler}/ADITO_${fileNameWithVersion}_unix.tar.gz
        mv ${sfxCreationDir}/ADITO_windows-x64-sfx.exe ${tempFilerPath}/${buildPathOnFiler}/ADITO_${fileNameWithVersion}_windows-x64.exe
        cp addendum/buildtools/target/releasenotes*.pdf ${tempFilerPath}/${buildPathOnFiler}/ || :
        """

        // Remove installer
        sh "rm addendum/assembly/target/ADITO_unix.tar.gz"

        // Upload all in tempFilerPath to filer with the exact folder structure created in tempFilerPath
        cifsPublisher continueOnError: false, failOnError: true,
                publishers: [
                        [configName: 'Entwicklung-Releases', transfers: [
                                [remoteDirectory: '', sourceFiles: "${tempFilerPath}/**", removePrefix: "${tempFilerPath}",
                                 cleanRemote    : false, flatten: false, makeEmptyDirs: true]
                        ]]
                ]

        // Clean our tempFilerPath-Path, because it was uploaded correctly and not necessary anymore
        // Kann das weg?
        echo "NOT deleting tempFilterPath: ${tempFilerPath}"
        //sh "rm -r ${tempFilerPath}"
      } else {
        echo "Skipped!"
      }
    }

    /**
     * Create entry in atom feed file (feed.xml) and upload installers and release notes to webftp.
     */
    stage('Feed') {

      echo "Creating feed entry..."
      echo "env.WORKSPACE: ${env.WORKSPACE}"
      if (params.publishOnFiler == true) {
        // Maven options
        String tempFilerPath = "target/deploy/filer"
        def aditoMajorVersion = getAditoMajorVerson();
        def buildVersion = getAditoVersionReadable();
        def buildVersionWithHotfix = getVersionWithHotfixPostfix();
        String buildPathOnFiler = "${aditoMajorVersion}/" // will be: "2019/2020 or similar

        if (isReleaseCandiateOrTestVersion())
        {
          def split = buildVersion.split("_")

          if (isHotfix()) {
            buildPathOnFiler += split[0] + "." + getHotfixVersion() + "/" + split[1]
          } else {
            buildPathOnFiler += split[0] + "/" + split[1]
          }

        } else {

          if (isHotfix()) {
            buildPathOnFiler += buildVersion + "." + getHotfixVersion()
          } else {
            buildPathOnFiler += buildVersion
          }
        }

        String basePath = "${tempFilerPath}/${buildPathOnFiler}/" // will be: 2020/2020.0.4/ or similar

        String releaseNotes = "${basePath}releasenotes.pdf"
        String releaseNotesWithVersion = "${basePath}releasenotes_${buildVersionWithHotfix}.pdf"

        String macos = "${basePath}ADITO_${buildVersionWithHotfix}_macos.zip"
        String unix = "${basePath}ADITO_${buildVersionWithHotfix}_unix.tar.gz"
        String win64 = "${basePath}ADITO_${buildVersionWithHotfix}_windows-x64.exe"

        String fileName = "feed.xml"
        String filePath = "${env.WORKSPACE}/${basePath}${fileName}"
        echo "path of feed file: ${filePath}"

        String releaseNotesPathPrefix = "${basePath}" // eigentlich nur relevant für die dateigrößen
        echo "base path of release notes: ${releaseNotesPathPrefix}"

        def aditoVersion = getAditoVersion();

        // 2nd param: the exact version with hotfix included
        String execArgs = "${basePath} ${aditoVersion} ${buildVersion} ${fileName} ${releaseNotesPathPrefix}"
        maven('.', 'org.codehaus.mojo:exec-maven-plugin:1.5.0:java -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion().m2Folder + ' ' +
                '-Dexec.mainClass=de.adito.releasenotes.changelogs.feed.AtomFeedCreator ' +
                '-Dexec.args="' + execArgs + '" ' +
                '-f addendum/buildtools/pom.xml')

        // hier prüfen, ob die feed.xml/test_feed.xml existiert
        // das bedeutet, dass keine Abbruchbedingung erfüllt war (wie keine finale Version, oder Version schon im Feed vorhanden)
        // wenn nicht -> abbrechen, wenn schon -> hochladen
        def feedFile = new File(filePath)
        boolean feedCreated = feedFile.exists()

        if (params.publishOnFeed == true && feedCreated) {
          // release notes haben versionsnamen
          sh "mv ${releaseNotes} ${releaseNotesWithVersion}"

          sshPublisher(publishers: [
                  sshPublisherDesc(
                          configName: 'ADITO_WEBFTP',
                          transfers: [
                                  sshTransfer(
                                          execTimeout: 120000,
                                          sourceFiles: '**/feed.xml,**/releasenotes_*.pdf',
                                          excludes: '**/releasenotes_template.html',
                                          flatten: true),
                                  sshTransfer(
                                          execTimeout: 1800000,
                                          sourceFiles: "${macos},${unix},${win64},${releaseNotesWithVersion}",
                                          excludes: '**/releasenotes_template.html',
                                          flatten: true)
                          ],
                          sshRetry: [
                                  retries: 1
                          ],
                          usePromotionTimestamp: false,
                          useWorkspaceInPromotion: false,
                          verbose: true)
          ])
        } else {
          echo "Not deploying version on webftp."
        }
        // Clean our tempFilerPath-Path, because it was uploaded correctly and is not necessary anymore
        sh "rm -r ${tempFilerPath}"
      } else {
        echo "Skipped!"
      }

    }
  }
}

def prepareDesignerPluginsBuildStage(String name) {
  return {
    // start pipeline for designer plugins
    stage(name) {
      if(!params.skipDesignerPlugins)
      {
        try {
          callPluginPipeline();
        } catch(e) {
          echo "Designer plugin catalogue update failed: " + e.getMessage();
        }
      }
    }
  }
}

def deployJditoTypes(String name) {
  return {
    stage(name) {
      if(!isHotfix()) {
        withCredentials([
            sshUserPrivateKey(
                credentialsId: "4ab44e27-90b3-40a9-93b8-f7358e362031",
                keyFileVariable: 'keyFileVarJditoTypes')
        ]) {
          // version schema does not support _ in the tag -> replace it with -
          String versionString = getAditoVersionReadable().replace("_", "-")
          sh """
                  rm -rf jdito-types
                  export GIT_SSH_COMMAND="ssh -i ${keyFileVarJditoTypes}"
                  git clone ${env.JDITO_TYPES_REPO_URL_SSH} jdito-types
                  cd jdito-types
                  git config user.email "admin@adito.de"
                  git config user.name "jenkins"
                  rm -rf dist
                  rm -rf index.d.ts
                  cp -r ../library/server/target/generated-sources/annotations/jsdoc/index.d.ts index.d.ts
                  cp -r ../library/server/target/generated-sources/annotations/jsdoc/dist .
                  git add . && (git commit -m "chore: new version ${versionString}" && git push && git tag ${versionString} && git push origin ${versionString}) || (echo "nothing to commit")
                  rm -rf jdito-types
               """
        }
      } else {
        echo("Hotfix version detected, skipping stub deploy since the version for the stubs do not work with hotfixes")
      }
    }
  }
}

// return the latest adito.version on the current build-branch (4.6.110_5)
String getAditoVersion() {
  // If the build is not failed, we can read the build-properties
  def props = readProperties file: 'library/core/target/classes/de/adito/aditoweb/core/version/aditoVersion.properties'
  return props['adito.version']
}

def isReleaseCandiateOrTestVersion()
{
  def theVersion = getAditoVersion()
  return theVersion.contains("_")
}

def isHotfix()
{
  return getHotfixVersion() != "0"
}

def getHotfixVersion()
{
  def theVersion = getAditoVersion()
  def baseSplit = theVersion.split("_") // ignore additional version info
  def versionSplit = baseSplit[0].split("\\.")
  if (versionSplit.size() == 4)
    return versionSplit[3]
  return "0" // resilience
}

static def getVersionWithHotfixWithoutPostfix(String versionTag)
{
  def versionSplit = versionTag.split("_") // truncate the RC/TEST version after the _
  def finalVersion = versionSplit[0]
  def versionParts = finalVersion.split("/") // split the version tag on the slashes, the first split will be version, the other 4 splits make up the actual version number
  if(versionParts.size() == 5 && versionParts[4] == "0") // if the version is a not a hotfix version only use the first 3 version letters
  {
    return versionParts[1] + "." + versionParts[2] + "." + versionParts[3]
  }
  else
  {
    return versionParts[1] + "." + versionParts[2] + "." + versionParts[3] + "." + versionParts[4]
  }
}

// returns a version number in the form of 2019.3.2[.X][_TESTX|_RCX]
def getVersionWithHotfixPostfix()
{
  def readable = getAditoVersionReadable()
  if (isHotfix())
  {
    def splits = readable.split("_");
    readable = splits[0] + "." + getHotfixVersion();
    if (splits.size() > 1)
      readable = readable + "_" + splits[1]
  }
  return readable;
}

// returns the human readable version (e.g. "4.6.110_RC5") of ADITO
// example: changes "2019.3.2.1" to "2019.3.2", and "2019.3.2.0_RC1" to "2019.3.2-RC1"
def getAditoVersionReadable() {
  def theVersion = onlyTheFirstThreeFigures(getAditoVersion());

  if (theVersion.contains("_RC")) {
    def versionSplit = theVersion.split("_")
    def buildSuffix = "_" + versionSplit[1]
    return versionSplit[0] + buildSuffix
  } else if (theVersion.contains("_T")) {
    def versionSplit = theVersion.split("_T")
    def buildSuffix = "_TEST" + versionSplit[1]
    return versionSplit[0] + buildSuffix
  } else if (theVersion.contains("_")) {
    def versionSplit = theVersion.split("_")
    def buildSuffix = "_RC" + versionSplit[1]
    return versionSplit[0] + buildSuffix
  } else {
    return theVersion
  }
}

static def onlyTheFirstThreeFigures(String theVersion)
{
  def splits = theVersion.split("_");
  def main = splits[0];
  def parts = main.split("\\.");

  if (parts.length == 4)
  {
    if (theVersion.contains("_")) {
      return parts[0] + "." + parts[1] + "." + parts[2] + "_" + splits[1];
    } else {
      return parts[0] + "." + parts[1] + "." + parts[2];
    }
  } else {
    return theVersion;
  }
}

// Return the major version of ADITO ("4.6", "5.0", "2019, 2020")
def getAditoMajorVerson() {
  def mvnRootPom = readMavenPom file: ''
  def majorVersion = mvnRootPom.properties['adito.version.external']
  return majorVersion;
}

static def getPipelineVersion() {
  return [tagsPrefix: "version/2022/2/*", m2Folder: "2022_2", releaseNotesStart: "2022.2.0.0"]
}

// starts the pipeline for the designer plugins
def callPluginPipeline()
{
  def theVersion = onlyTheFirstThreeFigures(getAditoVersion());
  if (theVersion.contains("_"))
    theVersion = theVersion.split("_")[0];
  // Trigger updateCatalog-Job
  build job: 'NBPlugins/deploy', parameters: [
          [$class: 'StringParameterValue', name: 'addNewVersion', value: theVersion]
  ]
}

