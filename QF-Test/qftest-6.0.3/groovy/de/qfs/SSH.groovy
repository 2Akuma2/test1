package de.qfs
/**
 * Convenience class for managing an ssh session vie JSch, encapsulating both
 * JSch session and channel to reduce complexity.
 */
class SSH{
    //  redirected constants
    class Session{
        //  redirected constants
        //  redirected methods
        private final de.qfs.apps.qftest.shared.script.modules.SSH.Session __wrappedInstanceSession
        /**
         * Creata a new Session.
         * 
         * @param username
         * The username to use.
         * @param server
         * The remote server to connect to.
         * @param port
         * The port to use for ssh login (optional, default 22).
         * @param password
         * The password to use (optional).
         * @param keyfile
         * The name of the file containing the key for public key
         * authentication. Used only if no password is specified
         * (optional, default is <user_home>/.ssh/id_rsa).
         * @param checkKnownHost
         * Whether to check the fingerprint of the remote server. For
         * security reasons this should be enabled (optional, default
         * true).
         * @param knownHostFile
         * A file containing the fingerprint for the remote server
         * (optional, default is <user_home>/.ssh/known_hosts).
         * @param connectTimeout
         * Time in ms to wait for a connection. -1 to wait forever
         * (optional, default is 5000).
         * @param command
         * The command to execute on the remote server (optional,
         * default is 'bash').
         * @param input
         * Text to be bassed to the stdin of the executing program.
         * Ignored if inputFile is specified.
         * @param inputFile
         * The path to a local file or nothing. If a file is
         * specified, the content of this file is passed to the stdin
         * of the executing program.
         * @param mixOut
         * If true, stdout and stderr of the executing program are
         * captured together in the stdout stream with stderr
         * remaining empty (optional, default false).
         * @throws NoSuchAlgorithmException
         * @throws JSchException
         * @throws FileNotFoundException
         */
        public Session(String username, String server, int port=22, String password=null, String keyfile=null, boolean checkKnownHosts=true, String knownHostsFile=null, int connectTimeout=5000, String command="bash", String input=null, String inputFile=null, boolean mixOut=false, boolean strong=false){
            __wrappedInstanceSession = de.qfs.apps.qftest.shared.script.modules.SSH.Session.instance(username, server, port, password, keyfile, checkKnownHosts, knownHostsFile, connectTimeout, command, input, inputFile, mixOut, strong)
        }
        /**
         * Creata a new Session.
         * 
         * @param username
         * The username to use.
         * @param server
         * The remote server to connect to.
         * @param port
         * The port to use for ssh login (optional, default 22).
         * @param password
         * The password to use (optional).
         * @param keyfile
         * The name of the file containing the key for public key
         * authentication. Used only if no password is specified
         * (optional, default is <user_home>/.ssh/id_rsa).
         * @param checkKnownHost
         * Whether to check the fingerprint of the remote server. For
         * security reasons this should be enabled (optional, default
         * true).
         * @param knownHostFile
         * A file containing the fingerprint for the remote server
         * (optional, default is <user_home>/.ssh/known_hosts).
         * @param connectTimeout
         * Time in ms to wait for a connection. -1 to wait forever
         * (optional, default is 5000).
         * @param command
         * The command to execute on the remote server (optional,
         * default is 'bash').
         * @param input
         * Text to be bassed to the stdin of the executing program.
         * Ignored if inputFile is specified.
         * @param inputFile
         * The path to a local file or nothing. If a file is
         * specified, the content of this file is passed to the stdin
         * of the executing program.
         * @param mixOut
         * If true, stdout and stderr of the executing program are
         * captured together in the stdout stream with stderr
         * remaining empty (optional, default false).
         * @throws NoSuchAlgorithmException
         * @throws JSchException
         * @throws FileNotFoundException
         */
        public Session instance(Map mappedParams, String username, String server){
            def port = 22
            if(mappedParams.containsKey("port")){
                port = mappedParams.port
            }
            def password = null
            if(mappedParams.containsKey("password")){
                password = mappedParams.password
            }
            def keyfile = null
            if(mappedParams.containsKey("keyfile")){
                keyfile = mappedParams.keyfile
            }
            def checkKnownHosts = true
            if(mappedParams.containsKey("checkKnownHosts")){
                checkKnownHosts = mappedParams.checkKnownHosts
            }
            def knownHostsFile = null
            if(mappedParams.containsKey("knownHostsFile")){
                knownHostsFile = mappedParams.knownHostsFile
            }
            def connectTimeout = 5000
            if(mappedParams.containsKey("connectTimeout")){
                connectTimeout = mappedParams.connectTimeout
            }
            def command = "bash"
            if(mappedParams.containsKey("command")){
                command = mappedParams.command
            }
            def input = null
            if(mappedParams.containsKey("input")){
                input = mappedParams.input
            }
            def inputFile = null
            if(mappedParams.containsKey("inputFile")){
                inputFile = mappedParams.inputFile
            }
            def mixOut = false
            if(mappedParams.containsKey("mixOut")){
                mixOut = mappedParams.mixOut
            }
            def strong = false
            if(mappedParams.containsKey("strong")){
                strong = mappedParams.strong
            }
            return __wrappedInstanceSession.instance(username, server, port, password, keyfile, checkKnownHosts, knownHostsFile, connectTimeout, command, input, inputFile, mixOut, strong)
        }
        /**
         * Define whether host key checking should take place.
         * 
         * @param check
         * Whether to check the fingerprint of the remote server.
         * @param knownHostFile
         * A file containing the fingerprint for the remote server
         * (optional, default is <user_home>/.ssh/known_hosts).
         * @throws JSchException
         */
        public void setHostKeyChecking(boolean check, String knownHostsFile=null){
            __wrappedInstanceSession.setHostKeyChecking(check, knownHostsFile)
        }
        /**
         * Define whether host key checking should take place.
         * 
         * @param check
         * Whether to check the fingerprint of the remote server.
         * @param knownHostFile
         * A file containing the fingerprint for the remote server
         * (optional, default is <user_home>/.ssh/known_hosts).
         * @throws JSchException
         */
        public void setHostKeyChecking(Map mappedParams, boolean check){
            if(mappedParams == null){
                __wrappedInstanceSession.setHostKeyChecking(mappedParams, check)
            }
            def knownHostsFile = null
            if(mappedParams.containsKey("knownHostsFile")){
                knownHostsFile = mappedParams.knownHostsFile
            }
            __wrappedInstanceSession.setHostKeyChecking(check, knownHostsFile)
        }
        /**
         * Set the connection timeout for the session.
         * 
         * @param timeout
         * Time in ms to wait for a connection. -1 to wait forever.
         */
        public void setConnectTimeout(int timeout){
            __wrappedInstanceSession.setConnectTimeout(timeout)
        }
        /**
         * Set the command to execute.
         * 
         * @param command
         * The command to execute.
         */
        public void setCommand(String command){
            __wrappedInstanceSession.setCommand(command)
        }
        /**
         * Set the text to be passed to the stdin of the executing program.
         * 
         * @param input
         * Text to be bassed to the stdin of the executing program.
         * Ignored if inputFile is also specified for this Session.
         */
        public void setInput(String input){
            __wrappedInstanceSession.setInput(input)
        }
        /**
         * Set the file with the text to be passed to the stdin of the executing
         * program.
         * 
         * @param inputFile
         * The path to a local file. If a file is specified, the
         * content of this file is passed to the stdin of the
         * executing program.
         * @throws FileNotFoundException
         */
        public void setInputFile(String inputFile){
            __wrappedInstanceSession.setInputFile(inputFile)
        }
        /**
         * Set the encoding for the stdout and stderr streams. Default is UTF-8.
         * 
         * @param encoding
         * The encoding to set. Must be a valid encoding name for the
         * running JRE.
         */
        public void setEncoding(String encoding){
            __wrappedInstanceSession.setEncoding(encoding)
        }
        /**
         * Open the session.
         * 
         * @throws JSchException
         * @throws IOException
         */
        public void open(){
            __wrappedInstanceSession.open()
        }
        /**
         * Send some input to the session.
         * 
         * @param input
         * The text to send.
         * @param addNewline
         * Whether to append a newline character if not already
         * present (optional, default true).
         * @throws IOException
         */
        public void send(String input, boolean addNewline=true){
            __wrappedInstanceSession.send(input, addNewline)
        }
        /**
         * Send some input to the session.
         * 
         * @param input
         * The text to send.
         * @param addNewline
         * Whether to append a newline character if not already
         * present (optional, default true).
         * @throws IOException
         */
        public void send(Map mappedParams, String input){
            if(mappedParams == null){
                __wrappedInstanceSession.send(mappedParams, input)
            }
            def addNewline = true
            if(mappedParams.containsKey("addNewline")){
                addNewline = mappedParams.addNewline
            }
            __wrappedInstanceSession.send(input, addNewline)
        }
        /**
         * Wait for some output from the session. Only output after the last
         * match for this method is taken into account.
         * 
         * @param regexp
         * A regular expression matching the text to wait for.
         * @param timeout
         * The maximum time to wait in ms. -1 to wait forever
         * (optional, default 1000).
         * 
         * @return The output from the process between the end of the previous
         * match and the end of this match. null if no matchin output
         * was received within the given time.
         * @throws UnsupportedEncodingException
         * @throws InterruptedException
         */
        public String expect(String regexp, int timeout=1000){
            return __wrappedInstanceSession.expect(regexp, timeout)
        }
        /**
         * Wait for some output from the session. Only output after the last
         * match for this method is taken into account.
         * 
         * @param regexp
         * A regular expression matching the text to wait for.
         * @param timeout
         * The maximum time to wait in ms. -1 to wait forever
         * (optional, default 1000).
         * 
         * @return The output from the process between the end of the previous
         * match and the end of this match. null if no matchin output
         * was received within the given time.
         * @throws UnsupportedEncodingException
         * @throws InterruptedException
         */
        public String expect(Map mappedParams, String regexp){
            if(mappedParams == null){
                return __wrappedInstanceSession.expect(mappedParams, regexp)
            }
            def timeout = 1000
            if(mappedParams.containsKey("timeout")){
                timeout = mappedParams.timeout
            }
            return __wrappedInstanceSession.expect(regexp, timeout)
        }
        /**
         * Wait for the executing command to finish.
         * 
         * @param timeout
         * The maximum time to wait in ms. -1 to wait forever
         * (optional, default 1000).
         * @return
         * @return
         * 
         * @return true if the command did finish, false if it is still running.
         * @throws InterruptedException
         */
        public boolean waitTime(int timeout=1000){
            return __wrappedInstanceSession.waitTime(timeout)
        }
        /**
         * Wait for the executing command to finish.
         * 
         * @param timeout
         * The maximum time to wait in ms. -1 to wait forever
         * (optional, default 1000).
         * @return
         * @return
         * 
         * @return true if the command did finish, false if it is still running.
         * @throws InterruptedException
         */
        public boolean waitTime(Map mappedParams){
            if(mappedParams == null){
                return __wrappedInstanceSession.waitTime(mappedParams, timeout)
            }
            def timeout = 1000
            if(mappedParams.containsKey("timeout")){
                timeout = mappedParams.timeout
            }
            return __wrappedInstanceSession.waitTime(timeout)
        }
        /**
         * Close the session.
         * 
         * @throws IOException
         */
        public void close(){
            __wrappedInstanceSession.close()
        }
        /**
         * Get the exit code of the command.
         * 
         * @return The exit code of the command.
         */
        public int getExitCode(){
            return __wrappedInstanceSession.getExitCode()
        }
        /**
         * Get the output from the command to stdout.
         * 
         * @return The output from the command to stdout. Inclues output to
         * stderr if mixOut was set to true for this Session.
         * @throws UnsupportedEncodingException
         */
        public String getStdout(){
            return __wrappedInstanceSession.getStdout()
        }
        /**
         * Get the output from the command to stderr.
         * 
         * @return The output from the command to stderr. Empty if mixOut was
         * set to private Object stderr; true for this Session.
         * @throws UnsupportedEncodingException
         */
        public String getStderr(){
            return __wrappedInstanceSession.getStderr()
        }
    }
}
