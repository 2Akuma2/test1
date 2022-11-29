const core = require('@actions/core');
const github = require('@actions/github');
const { spawn } = require('node:child_process');

try 
{
  // `who-to-greet` input defined in action metadata file
  const nameToGreet = core.getInput('who-to-greet');
  console.log(`Hello ${nameToGreet}!`);
  
  const paramTag = core.getInput('paramTag');
  console.log(`Nice ${paramTag}!`);
  const resolvedParamTag = getVersionWithHotfixWithoutPostfix(paramTag);
  core.setOutput("resolvedParamTag", resolvedParamTag);
  
  //////////////////////////////////////////////////////////////////////////
  const test1 = spawn('echo', ["This is test1."]);
  test1.stdout.on('data', output => {
    // the output data is captured and printed in the callback
    console.log("Output: ", output.toString())
  })
  
  const test2 = spawn('echo', ["This is test2 with paramTag: " + $paramTag);
  test2.stdout.on('data', output => {
    // the output data is captured and printed in the callback
    console.log("Output: ", output.toString())
  })
//////////////////////////////////////////////////////////////////////////
  
  const time = (new Date()).toTimeString();
  core.setOutput("timee", time);
  // Get the JSON webhook payload for the event that triggered the workflow
  const payload = JSON.stringify(github.context.payload, undefined, 2)
  console.log(`The event payload: ${payload}`);
} catch (error) {
  core.setFailed(error.message);
}

/*

// missing: adito.complete.final.version, fullVersion, maven(), process.env.sshUserPrivateKey, params.tag, process.env.ADITO_DESIGNER_REPO_URL_SSH, currentBuild.displayName

function stageBuild()
{
  const paramTag = core.getInput('paramTag');
  console.log(`Nice ${paramTag}!`);
  const resolvedParamTag = getVersionWithHotfixWithoutPostfix(paramTag);
  core.setOutput("resolvedParamTag", resolvedParamTag);
  const { spawn } = require('node:child_process');
  
  try
  {
    const replace = spawn('sed', ["-i 's/\${adito.complete.final.version}/${fullVersion}/' addendum/assemblydesigner/buildresources/ADITOdesigner.conf"]);
  }
  catch(e)
  {
    const caught = spawn('echo', ["Designer version replacement in ADITOdesigner.conf failed."]);
  }
  
  
  
  
  try
  {
    const buildSuffix = "";
    maven('.', 'clean install -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion().m2Folder + ' -T 1C -e ' +
                  '-P adito.maven.resources,adito.maven.javadoc,adito.production ' +
                  '-DJOB_NAME=${JOB_NAME} ' +
                  '-Dadito.build.version=\"' + getAditoMajorVerson() + '\" -Dadito.build.suffix=\"' + buildSuffix + '\"');
    
    const remove = spawn('rm', ["-rf adito-designer"]);
    const exportGitCmd = spawn('export', ["GIT_SSH_COMMAND=\"ssh -i ${process.env.sshUserPrivateKey}\""]);
    const gitCloneDesigner = spawn('git clone', ["-b "${params.tag}" ${process.env.ADITO_DESIGNER_REPO_URL_SSH}"]);
    
    maven('adito-designer', 'clean install -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion().m2Folder + ' -T 1C -e -DskipTests');
    const remove2 = spawn('rm', ["-rf adito-designer"]);
    
    maven('addendum', 'clean install -Dmaven.repo.local=$HOME/.m2_builds/' + getPipelineVersion().m2Folder + ' -e ' +
            '-P adito.maven.assembly,adito.maven.resources,adito.maven.installer,adito.maven.javadoc,adito.production ' +
            '-DJOB_NAME=${JOB_NAME} ' +
            '-Dadito.build.version=\"' + getAditoMajorVerson() + '\" -Dadito.build.suffix=\"' + buildSuffix + '\"');
    
    currentBuild.displayName = getVersionWithHotfixPostfix();    
  }
  catch(pErr)
  {
    // 130
  }
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function maven(pWorkingDir, pParams)
{
  const { spawn } = require('node:child_process');
  const os = require('os');
  if(os.platform == "win32")
  {
    const winmvn = spawn('mvn', ["-s ${MAVEN_SETTINGS} -t ${MAVEN_TOOLCHAINS} ${pParams}"]);
  }
  else
  {
    const linuxcd = spawn('cd', ["${pWorkingDir}"]);
    const linuxmvn = spawn('mvn', ["-s ${MAVEN_SETTINGS} -t ${MAVEN_TOOLCHAINS} ${pParams}"]);
  }
}


// return the latest adito.version on the current build-branch (4.6.110_5)
function getAditoVersion() {
  // If the build is not failed, we can read the build-properties
  var props = readProperties file: 'library/core/target/classes/de/adito/aditoweb/core/version/aditoVersion.properties';
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
    return versionSplit[3];
  return "0" // resilience
}
*/

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

/*
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


// Return the major version of ADITO ("4.6", "5.0", "2019, 2020")
function getAditoMajorVerson()
{
  var mvnRootPom = readMavenPom file: '';
  var majorVersion = mvnRootPom.properties['adito.version.external'];
  return majorVersion;
}


function getPipelineVersion() // was static?
{
  return [tagsPrefix: "version/2022/2/*", m2Folder: "2022_2", releaseNotesStart: "2022.2.0.0"];
}



*/


