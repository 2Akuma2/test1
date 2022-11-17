from de.qfs.apps.qftest.shared.script.modules import SSH as _WrappedSSH
#  redirected constants
class Session(object):
    #  redirected constants
    #  redirected methods
    def __init__(self, username, server, port=22, password=None, keyfile=None, checkKnownHosts=True, knownHostsFile=None, connectTimeout=5000, command="bash", input=None, inputFile=None, mixOut=False, strong=False):
        """
        Creata a new Session.
        
        @param username
        The username to use.
        @param server
        The remote server to connect to.
        @param port
        The port to use for ssh login (optional, default 22).
        @param password
        The password to use (optional).
        @param keyfile
        The name of the file containing the key for public key
        authentication. Used only if no password is specified
        (optional, default is <user_home>/.ssh/id_rsa).
        @param checkKnownHost
        Whether to check the fingerprint of the remote server. For
        security reasons this should be enabled (optional, default
        true).
        @param knownHostFile
        A file containing the fingerprint for the remote server
        (optional, default is <user_home>/.ssh/known_hosts).
        @param connectTimeout
        Time in ms to wait for a connection. -1 to wait forever
        (optional, default is 5000).
        @param command
        The command to execute on the remote server (optional,
        default is 'bash').
        @param input
        Text to be bassed to the stdin of the executing program.
        Ignored if inputFile is specified.
        @param inputFile
        The path to a local file or nothing. If a file is
        specified, the content of this file is passed to the stdin
        of the executing program.
        @param mixOut
        If true, stdout and stderr of the executing program are
        captured together in the stdout stream with stderr
        remaining empty (optional, default false).
        @throws NoSuchAlgorithmException
        @throws JSchException
        @throws FileNotFoundException
        """
        self.__wrappedInstanceSession = _WrappedSSH.Session.instance(username, server, port, password, keyfile, checkKnownHosts, knownHostsFile, connectTimeout, command, input, inputFile, mixOut, strong)
    
    def setHostKeyChecking(self, check, knownHostsFile=None):
        """
        Define whether host key checking should take place.
        
        @param check
        Whether to check the fingerprint of the remote server.
        @param knownHostFile
        A file containing the fingerprint for the remote server
        (optional, default is <user_home>/.ssh/known_hosts).
        @throws JSchException
        """
        if check:
            check = True
        
        else:
            check = False
        
        self.__wrappedInstanceSession.setHostKeyChecking(check, knownHostsFile)
    
    def setConnectTimeout(self, timeout):
        """
        Set the connection timeout for the session.
        
        @param timeout
        Time in ms to wait for a connection. -1 to wait forever.
        """
        self.__wrappedInstanceSession.setConnectTimeout(timeout)
    
    def setCommand(self, command):
        """
        Set the command to execute.
        
        @param command
        The command to execute.
        """
        self.__wrappedInstanceSession.setCommand(command)
    
    def setInput(self, input):
        """
        Set the text to be passed to the stdin of the executing program.
        
        @param input
        Text to be bassed to the stdin of the executing program.
        Ignored if inputFile is also specified for this Session.
        """
        self.__wrappedInstanceSession.setInput(input)
    
    def setInputFile(self, inputFile):
        """
        Set the file with the text to be passed to the stdin of the executing
        program.
        
        @param inputFile
        The path to a local file. If a file is specified, the
        content of this file is passed to the stdin of the
        executing program.
        @throws FileNotFoundException
        """
        self.__wrappedInstanceSession.setInputFile(inputFile)
    
    def setEncoding(self, encoding):
        """
        Set the encoding for the stdout and stderr streams. Default is UTF-8.
        
        @param encoding
        The encoding to set. Must be a valid encoding name for the
        running JRE.
        """
        self.__wrappedInstanceSession.setEncoding(encoding)
    
    def open(self):
        """
        Open the session.
        
        @throws JSchException
        @throws IOException
        """
        self.__wrappedInstanceSession.open()
    
    def send(self, input, addNewline=True):
        """
        Send some input to the session.
        
        @param input
        The text to send.
        @param addNewline
        Whether to append a newline character if not already
        present (optional, default true).
        @throws IOException
        """
        if addNewline:
            addNewline = True
        
        else:
            addNewline = False
        
        self.__wrappedInstanceSession.send(input, addNewline)
    
    def expect(self, regexp, timeout=1000):
        """
        Wait for some output from the session. Only output after the last
        match for this method is taken into account.
        
        @param regexp
        A regular expression matching the text to wait for.
        @param timeout
        The maximum time to wait in ms. -1 to wait forever
        (optional, default 1000).
        
        @return The output from the process between the end of the previous
        match and the end of this match. null if no matchin output
        was received within the given time.
        @throws UnsupportedEncodingException
        @throws InterruptedException
        """
        return self.__wrappedInstanceSession.expect(regexp, timeout)
    
    def wait(self, timeout=1000):
        """
        Wait for the executing command to finish.
        
        @param timeout
        The maximum time to wait in ms. -1 to wait forever
        (optional, default 1000).
        @return
        @return
        
        @return true if the command did finish, false if it is still running.
        @throws InterruptedException
        """
        return self.__wrappedInstanceSession.waitTime(timeout)
    
    def waitTime(self, timeout=1000):
        """
        Wait for the executing command to finish.
        
        @param timeout
        The maximum time to wait in ms. -1 to wait forever
        (optional, default 1000).
        @return
        @return
        
        @return true if the command did finish, false if it is still running.
        @throws InterruptedException
        """
        return self.__wrappedInstanceSession.waitTime(timeout)
    
    def close(self):
        """
        Close the session.
        
        @throws IOException
        """
        self.__wrappedInstanceSession.close()
    
    def getExitCode(self):
        """
        Get the exit code of the command.
        
        @return The exit code of the command.
        """
        return self.__wrappedInstanceSession.getExitCode()
    
    def getStdout(self):
        """
        Get the output from the command to stdout.
        
        @return The output from the command to stdout. Inclues output to
        stderr if mixOut was set to true for this Session.
        @throws UnsupportedEncodingException
        """
        return self.__wrappedInstanceSession.getStdout()
    
    def getStderr(self):
        """
        Get the output from the command to stderr.
        
        @return The output from the command to stderr. Empty if mixOut was
        set to private Object stderr; true for this Session.
        @throws UnsupportedEncodingException
        """
        return self.__wrappedInstanceSession.getStderr()
    

