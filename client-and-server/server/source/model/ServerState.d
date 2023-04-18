module model.ServerState;

private import std.string;
private import std.typecons;
private import std.array;

private import controller.commands.Command;

/**
 * Class that represents the state of the application.
 * Holds user list, chat history, command history, current local command id, and drawing state.
 */
class ServerState
{
private:
    static int clientId = -1;
    static string username = "";
    static string[int] connectedUsers;
    static string[] chatHistory = [];
    static string[] commandHistory = [];
    static int curCmd = 0;

public:
    /**
     * Gets the current clientId.
     *
     * Returns:
     *        - clientId : int : the current client id
     */
    static int getClientId()
    {
        return ServerState.clientId;
    }

    /**
     * Sets the current clientId.
     *
     * Params:
     *       - clientId : int : the client id to set to
     */
    static void setClientId(int clientId)
    {
        ServerState.clientId = clientId;
    }

    @("Testing appplication state client id")
    unittest
    {
        setClientId(3);
        assert(getClientId() == 3);
    }

    /**
     * Gets the current username.
     *
     * Returns:
     *        - username : string : the current username
     */
    static string getUsername()
    {
        return ServerState.username;
    }

    /**
     * Sets the current username.
     *
     * Params:
     *       - username : string : the desired username
     */
    static void setUsername(string username)
    {
        ServerState.username = username;
    }

    @("Testing appplication state client id")
    unittest
    {
        setUsername("Mike Shah");

        import std.algorithm.comparison : equal;

        assert(getUsername().equal("Mike Shah"));
    }

    /**
     * Gets the current set of connected users.
     *
     * Returns:
     *        - users : string[int] : a hashmap of user id to username
     */
    static string[int] getConnectedUsers()
    {
        return ServerState.connectedUsers;
    }

    /**
     * Adds a user to the set of connected users.
     *
     * Params:
     *       - username : string : the username of the user to add
     *       - uid      : int : the user id of the user to add
     */
    static void addConnectedUser(string username, int uid)
    {
        ServerState.connectedUsers[uid] = username;
    }

    @("Testing addConnectedUser and getConnectedUsers")
    unittest
    {
        addConnectedUser("User 1", 1);
        addConnectedUser("User 2", 2);
        addConnectedUser("User 3", 3);

        string[int] users = [1: "User 1", 2: "User 2", 3: "User 3"];
        assert(getConnectedUsers == users);
    }

    /**
     * Removes a user from the set of connected users.
     *
     * Params:
     *       - uid : int : the user id of the user to remove
     */
    static void removeConnectedUser(int uid)
    {
        ServerState.connectedUsers.remove(uid);
    }

    @("Testing addConnectedUser, getConnectedUsers, and removeConnectedUser")
    unittest
    {
        addConnectedUser("User 1", 1);
        addConnectedUser("User 2", 2);
        addConnectedUser("User 3", 3);

        string[int] users1 = [1: "User 1", 2: "User 2", 3: "User 3"];
        assert(getConnectedUsers == users1);

        removeConnectedUser(2);
        addConnectedUser("User 4", 4);
        addConnectedUser("User 5", 5);
        removeConnectedUser(3);

        string[int] users2 = [1: "User 1", 4: "User 4", 5: "User 5"];
        assert(getConnectedUsers == users2);
    }

    /**
     * Gets the current chat history.
     *
     * Returns:
     *        - chatHistory : Tuple!(string, int, long, string)[] : the current chat history
     */
    static string[] getChatHistory()
    {
        return ServerState.chatHistory;
    }

    /**
     * Adds a chat to the chat history.
     *
     * Params:
     *       - chatPackage : Tuple!(string, int, long, string) : a username, id, timestamp, message package
     */
    static void addChatPacket(string chatPackage)
    {
        ServerState.chatHistory ~= chatPackage;
    }

    @("Testing addChatPacket and getChatHistory")
    unittest
    {
        Tuple!(string, int, long, string) testChatPacket1;
        testChatPacket1[0] = "Bob";
        testChatPacket1[1] = 1;
        testChatPacket1[2] = 1253;
        testChatPacket1[3] = "This is a test message!!!";
        addChatPacket(testChatPacket1);

        Tuple!(string, int, long, string)[] chatHistory1 = [testChatPacket1];
        assert(getChatHistory() == chatHistory1);

        Tuple!(string, int, long, string) testChatPacket2;
        testChatPacket2[0] = "Sam";
        testChatPacket2[1] = 1;
        testChatPacket2[2] = 1300;
        testChatPacket2[3] = "Testing testing. This is a message for a unittest.";
        addChatPacket(testChatPacket2);

        Tuple!(string, int, long, string)[] chatHistory2 = [
            testChatPacket1, testChatPacket2
        ];
        assert(getChatHistory() == chatHistory2);
    }

    /**
     * Prepends the given command tuple to the command history after executing it.
     *
     * Params:
     *        - cmd : Tuple!(string, int, Command) : a username, user id, Command tuple
     */
    static void addToCommandHistory(string cmd)
    {
        ServerState.commandHistory = [cmd] ~ ServerState.commandHistory;
    }

    /**
     * Gets the current command tuple history.
     *
     * Returns:
     *        - commandHistory : Tuple!(string, int, Command)[] : the current command history
     */
    static string[] getCommandHistory()
    {
        return ServerState.commandHistory;
    }

    /**
     * Sets the current command tuple history.
     *
     * Params:
     *       - history : Tuple!(string, int, Command)[] : the history to set
     */
    static void setCommandHistory(string[] history)
    {
        ServerState.commandHistory = history;
    }

    /**
     * Gets the current command id
     *
     * Returns:
     *        - cid : int : the current command id
     */
    static int getCurCommandId()
    {
        return ServerState.curCmd;
    }

    /**
     * Increments the current command id.
     */
    static void goToNextCommandId()
    {
        ServerState.curCmd += 1;
    }
}
