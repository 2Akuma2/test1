const core = require('@actions/core');
const github = require('@actions/github');
const { spawn, spawnSync } = require('node:child_process');
const propertiesToJson = require('properties-file');
const pomParser = require('pom-parser');

try 
{
  // `who-to-greet` input defined in action metadata file
  const nameToGreet = core.getInput('who-to-greet');
  console.log(`Hello ${nameToGreet}!`);
  
  const paramTag = core.getInput('paramTag');
  console.log(`Nice ${paramTag}!`);
  const fullVersion = getVersionWithHotfixWithoutPostfix(paramTag);
  core.setOutput("fullVersion", fullVersion);
  
  //////////////////////////////////////////////////////////////////////////
  const test1 = spawnSync('echo', [`This is test1.`, `This is test 1.1`], {shell: true, stdio: 'inherit'});
  
  const test2 = spawnSync('echo', [`This is test2 with paramTag: ${paramTag}`], {shell: true, stdio: 'inherit'});
  
  const test3 = spawnSync('echo', [`$(java -version)`], {shell: true, stdio: 'inherit'});
  
  console.log("Checkpoint 1");
  
  const test4 = spawnSync('sudo', [`pwd && cd '../' && pwd`], {shell: true, stdio: 'inherit'});
  
  console.log("Checkpoint 2");
  
  const test5 = spawnSync('sudo', [`pwd`], {shell: true, stdio: 'inherit'});
  
  console.log("Checkpoint 3");
  
  const test6 = spawnSync('sudo', [`echo ${paramTag} und '\${paramTag}'`], {shell: true, stdio: 'inherit'}); // ${paramTag} -> value, '\${paramTag}' -> ${paramTag}
  
  console.log("Checkpoint 4"); 
  
  const test7replace = spawnSync('sudo', [`echo sed -i s/'\${adito.complete.final.version}'/${fullVersion}/ addendum/assemblydesigner/buildresources/ADITOdesigner.conf`], {shell: true, stdio: 'inherit'});
  
  console.log("Checkpoint 5"); 
  
  const test8exportGitCmd = spawnSync('sudo', [`echo export GIT_SSH_COMMAND="ssh -i ${paramTag}"`], {shell: true, stdio: 'inherit'});
  
  console.log("Checkpoint 6"); 
  
  const test9gitCloneDesigner = spawnSync('sudo', [`echo git clone -b ${paramTag} ${fullVersion}`], {shell: true, stdio: 'inherit'});
  
  console.log("Checkpoint 7"); 
  
  const pWorkingDir = "workingdir";
  const MAVEN_SETTINGS = "settings";
  const MAVEN_TOOLCHAINS = "toolchains";
  const pParams = "params";
  
  const test10linuxmvn = spawnSync('sudo', [`echo cd '${pWorkingDir}' && echo mvn -s ${MAVEN_SETTINGS} -t ${MAVEN_TOOLCHAINS} ${pParams}`], {shell: true, stdio: 'inherit'});
  
  console.log("Checkpoint 8");
  
  const test11 = spawnSync('sudo', [`ls && cd '../' && ls`], {shell: true, stdio: 'inherit'});
  
  console.log("Checkpoint 9");
  
  console.log("getAditoMajorVersion: " + getAditoMajorVersion());
  
  console.log("Checkpoint 10");
  ////////////////////////////////////////////////////////////////////////
  
  const time = (new Date()).toTimeString();
  core.setOutput("timee", time);
  // Get the JSON webhook payload for the event that triggered the workflow
  const payload = JSON.stringify(github.context.payload, undefined, 2)
  console.log(`The event payload: ${payload}`);
} catch (error) {
  core.setFailed(error.message);
}



// missing: currentBuild.displayName

function stageBuild()
{
  const paramTag = core.getInput('paramTag');
  console.log(`Nice ${paramTag}!`);
  const fullVersion = getVersionWithHotfixWithoutPostfix(paramTag);
  core.setOutput("fullVersion", fullVersion);
  
  try // replace ${adito.complete.final.version} with ${fullVersion} in addendum/assemblydesigner/buildresources/ADITOdesigner.conf
  {
    //const replace = spawnSync('sed', [`-i 's/\${adito.complete.final.version}/${fullVersion}/' addendum/assemblydesigner/buildresources/ADITOdesigner.conf`]);
    const replace = spawnSync('sudo', [`sed -i s/'\${adito.complete.final.version}'/${fullVersion}/ addendum/assemblydesigner/buildresources/ADITOdesigner.conf`], {shell: true, stdio: 'inherit'});
  }
  catch(e)
  {
    const caught = spawnSync('echo', [`Designer version replacement in ADITOdesigner.conf failed.`], {shell: true, stdio: 'inherit'});
  }
  
  try
  {
    const buildSuffix = "";
    maven('.', 'clean install -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion("m2Folder") + ' -T 1C -e ' +
                  '-P adito.maven.resources,adito.maven.javadoc,adito.production ' +
                  '-DJOB_NAME=${JOB_NAME} ' +
                  '-Dadito.build.version=\"' + getAditoMajorVersion() + '\" -Dadito.build.suffix=\"' + buildSuffix + '\"');
    
    const remove = spawnSync('sudo', [`rm -rf adito-designer`], {shell: true, stdio: 'inherit'});
    const exportGitCmd = spawnSync('sudo', [`export GIT_SSH_COMMAND="ssh -i ${process.env.sshUserPrivateKey}"`], {shell: true, stdio: 'inherit'});
    const gitCloneDesigner = spawnSync('sudo', [`git clone -b ${paramTag} ${process.env.ADITO_DESIGNER_REPO_URL_SSH}`], {shell: true, stdio: 'inherit'});
    
    maven('adito-designer', 'clean install -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion("m2Folder") + ' -T 1C -e -DskipTests');
    const remove2 = spawnSync('sudo', [`rm -rf adito-designer`], {shell: true, stdio: 'inherit'});
    
    maven('addendum', 'clean install -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion("m2Folder") + ' -e ' +
            '-P adito.maven.assembly,adito.maven.resources,adito.maven.installer,adito.maven.javadoc,adito.production ' +
            '-DJOB_NAME=${JOB_NAME} ' +
            '-Dadito.build.version=\"' + getAditoMajorVersion() + '\" -Dadito.build.suffix=\"' + buildSuffix + '\"');
    
    currentBuild.displayName = getVersionWithHotfixPostfix();    
  }
  catch(pErr)
  {
    if (currentBuild.result == 'UNSTABLE')
    {
      currentBuild.result = 'FAILURE';
    }
    throw pErr;
  }
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function maven(pWorkingDir, pParams)
{
  const os = require('os');
  if(os.platform == "win32")
  {
    const winmvn = spawnSync('sudo', [`mvn -s ${process.env.MAVEN_SETTINGS} -t ${process.env.MAVEN_TOOLCHAINS} ${pParams}`], {shell: true, stdio: 'inherit'});
  }
  else
  {
    const linuxmvn = spawnSync('sudo', [`cd '${pWorkingDir}' && mvn -s ${process.env.MAVEN_SETTINGS} -t ${process.env.MAVEN_TOOLCHAINS} ${pParams}`], {shell: true, stdio: 'inherit'});
  }
}


// return the latest adito.version on the current build-branch (4.6.110_5)
function getAditoVersion() {
  // If the build is not failed, we can read the build-properties
  var props = propertiesToJson('library/core/target/classes/de/adito/aditoweb/core/version/aditoVersion.properties');
  return props['adito.version'];
}


function isHotfix()
{
  return getHotfixVersion() != "0";
}


function getHotfixVersion()
{
  var theVersion = getAditoVersion();
  var baseSplit = theVersion.split("_"); // ignore additional version info
  var versionSplit = baseSplit[0].split("\\.");
  if (versionSplit.size() == 4)
  {
    return versionSplit[3];
  }
  return "0" ; // resilience
}


function getVersionWithHotfixWithoutPostfix(versionTag)
{
  var versionSplit = versionTag.split("_"); // truncate the RC/TEST version after the _
  var finalVersion = versionSplit[0];
  var versionParts = finalVersion.split("/"); // split the version tag on the slashes, the first split will be version, the other 4 splits make up the actual version number
  if(versionParts.length == 5 && versionParts[4] == "0") // if the version is a not a hotfix version only use the first 3 version letters
  {
    return versionParts[1] + "." + versionParts[2] + "." + versionParts[3];
  }
  else
  {
    return versionParts[1] + "." + versionParts[2] + "." + versionParts[3] + "." + versionParts[4];
  }  
}


function getVersionWithHotfixPostfix()
{
  var readable = getAditoVersionReadable();
  if(isHotfix())
  {
    var splits = readable.split("_");
    readable = splits[0] + "." + getHotfixVersion();
    if(splits.length > 1)
    {
      readable = readable + "_" + splits[1];
    }
  }
  return readable;
}


// returns the human readable version (e.g. "4.6.110_RC5") of ADITO
// example: changes "2019.3.2.1" to "2019.3.2", and "2019.3.2.0_RC1" to "2019.3.2-RC1"
function getAditoVersionReadable() {
  var theVersion = onlyTheFirstThreeFigures(getAditoVersion());

  if (theVersion.contains("_RC")) 
  {
    var versionSplit = theVersion.split("_");
    var buildSuffix = "_" + versionSplit[1];
    return versionSplit[0] + buildSuffix;
  } 
  else if (theVersion.contains("_T")) 
  {
    var versionSplit = theVersion.split("_T");
    var buildSuffix = "_TEST" + versionSplit[1];
    return versionSplit[0] + buildSuffix;
  } 
  else if (theVersion.contains("_")) 
  {
    var versionSplit = theVersion.split("_");
    var buildSuffix = "_RC" + versionSplit[1];
    return versionSplit[0] + buildSuffix;
  } 
  else 
  {
    return theVersion;
  }
}


function onlyTheFirstThreeFigures(theVersion) // was static?
{
  var splits = theVersion.split("_");
  var main = splits[0];
  var parts = main.split("\\.");

  if (parts.length == 4)
  {
    if (theVersion.contains("_"))
    {
      return parts[0] + "." + parts[1] + "." + parts[2] + "_" + splits[1];
    }
    else
    {
      return parts[0] + "." + parts[1] + "." + parts[2];
    }
  }
  else
  {
    return theVersion;
  }
}

//////////////////////////////////////////////////////////////////////////////////////
// Return the major version of ADITO ("4.6", "5.0", "2019, 2020")
function getAditoMajorVersion()
{
  console.log("MajorVersionCheckpoint 1");
  var opts = {filePath: "ao/pom.xml"};
  console.log("MajorVersionCheckpoint 2: " + opts);
  pomParser.parse(opts, function(err, pomResponse) {
    if (err)
    {
      console.log("ERROR: " + err);
    }
    
    var majorVersion = pomResponse.pomObject['adito.version.external'];
    
    //var mvnRootPom = readMavenPom file: '';
    //var majorVersion = mvnRootPom.properties['adito.version.external'];
    
    return majorVersion + "1";
  });
}


function getPipelineVersion(type) // was static?
{
  if(type == "tagsPrefix")
  {
    return "version/2022/2/*";
  }
  else if (type == "m2Folder")
  {
    return "2022_2";
  }
  else
  {
    return "2022.2.0.0";
  }
}






