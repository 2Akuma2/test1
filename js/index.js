const core = require('@actions/core');
const github = require('@actions/github');

try 
{
  // `who-to-greet` input defined in action metadata file
  const nameToGreet = core.getInput('who-to-greet');
  console.log(`Hello ${nameToGreet}!`);
  
  const paramTag = core.getInput('paramTag');
  console.log(`Nice ${paramTag}!`);
  const resolvedParamTag = getVersionWithHotfixWithoutPostfix(paramTag);
  core.setOutput("resolvedParamTag", resolvedParamTag);
  
  const time = (new Date()).toTimeString();
  core.setOutput("timee", time);
  // Get the JSON webhook payload for the event that triggered the workflow
  const payload = JSON.stringify(github.context.payload, undefined, 2)
  console.log(`The event payload: ${payload}`);
} catch (error) {
  core.setFailed(error.message);
}



// missing: adito.complete.final.version, fullVersion, maven(), getPipelineVersion(), getAditoMajorVersion(), process.env.sshUserPrivateKey, params.tag, process.env.ADITO_DESIGNER_REPO_URL_SSH, currentBuild.displayName, getVersionWithHotfixPostfix()

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
    const exportGitCmd = spawn('export', ["GIT_SSH_COMMAND="ssh -i ${process.env.sshUserPrivateKey}""]);
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
