package de.qfs
class RunEngine{
    //  redirected methods
    public  static Object runAndroid(String languageName, Object cmd, int timeout=5000){
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runAndroid(languageName, cmd, timeout)
    }
    public  static Object runAndroid(Map mappedParams, String languageName, Object cmd){
        if(mappedParams == null){
            return de.qfs.apps.qftest.client.script.modules.RunEngine.runAndroid(mappedParams, languageName)
        }
        def timeout = 5000
        if(mappedParams.containsKey("timeout")){
            timeout = mappedParams.timeout
        }
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runAndroid(languageName, cmd, timeout)
    }
    public  static Object runAWT(String languageName, Object cmd, int timeout=5000){
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runAWT(languageName, cmd, timeout)
    }
    public  static Object runAWT(Map mappedParams, String languageName, Object cmd){
        if(mappedParams == null){
            return de.qfs.apps.qftest.client.script.modules.RunEngine.runAWT(mappedParams, languageName)
        }
        def timeout = 5000
        if(mappedParams.containsKey("timeout")){
            timeout = mappedParams.timeout
        }
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runAWT(languageName, cmd, timeout)
    }
    public  static Object runSWT(String languageName, Object cmd, int timeout=5000){
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runSWT(languageName, cmd, timeout)
    }
    public  static Object runSWT(Map mappedParams, String languageName, Object cmd){
        if(mappedParams == null){
            return de.qfs.apps.qftest.client.script.modules.RunEngine.runSWT(mappedParams, languageName)
        }
        def timeout = 5000
        if(mappedParams.containsKey("timeout")){
            timeout = mappedParams.timeout
        }
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runSWT(languageName, cmd, timeout)
    }
    public  static Object runWeb(String languageName, Object cmd, int timeout=5000){
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runWeb(languageName, cmd, timeout)
    }
    public  static Object runWeb(Map mappedParams, String languageName, Object cmd){
        if(mappedParams == null){
            return de.qfs.apps.qftest.client.script.modules.RunEngine.runWeb(mappedParams, languageName)
        }
        def timeout = 5000
        if(mappedParams.containsKey("timeout")){
            timeout = mappedParams.timeout
        }
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runWeb(languageName, cmd, timeout)
    }
    public  static Object runFX(String languageName, Object cmd, int timeout=5000){
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runFX(languageName, cmd, timeout)
    }
    public  static Object runFX(Map mappedParams, String languageName, Object cmd){
        if(mappedParams == null){
            return de.qfs.apps.qftest.client.script.modules.RunEngine.runFX(mappedParams, languageName)
        }
        def timeout = 5000
        if(mappedParams.containsKey("timeout")){
            timeout = mappedParams.timeout
        }
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runFX(languageName, cmd, timeout)
    }
    public  static Object runWin(String languageName, Object cmd, int timeout=5000){
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runWin(languageName, cmd, timeout)
    }
    public  static Object runWin(Map mappedParams, String languageName, Object cmd){
        if(mappedParams == null){
            return de.qfs.apps.qftest.client.script.modules.RunEngine.runWin(mappedParams, languageName)
        }
        def timeout = 5000
        if(mappedParams.containsKey("timeout")){
            timeout = mappedParams.timeout
        }
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runWin(languageName, cmd, timeout)
    }
    public  static Object runCmd(String languageName, Object cmd){
        return de.qfs.apps.qftest.client.script.modules.RunEngine.runCmd(languageName, cmd)
    }
}
