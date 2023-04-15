module model.ApplicationState;

private import std.string;
private import std.typecons;
private import std.array;

private import controller.commands.Command;

/** 
 * Class that represents the state of the application. 
 * Holds user list, chat history, command history, current local command id, and drawing state
 */
class ApplicationState
{
private:
    static int clientId = -1;
    static string username = "";
    static string[int] connectedUsers;
    static Tuple!(string, int, long, string)[] chatHistory = [];
    static Tuple!(string, int, Command)[] commandHistory = [];
    static int curCmd = 0;

public:
    /** 
     * Gets the current clientId
     * 
     * Returns:
     *        - clientId : int : the current client id
     */
    static int getClientId() {
        return ApplicationState.clientId;
    }

    /**
     * Sets the current clientId
     * 
     * Params: 
     *       - clientId : int : the client id to set to
     */
    static void setClientId(int clientId) {
        ApplicationState.clientId = clientId;
    }

    /**
     * Gets the current username
     *
     * Returns:
     *        - username : string : the current username
     */
    static string getUsername() {
        return ApplicationState.username;
    }

    /**
     * Sets the current username
     *
     * Params: 
     *       - username : string : the desired username
     */
    static void setUsername(string username) {
        ApplicationState.username = username;
    }

    /**
     * Gets the current set of connected users
     *
     * Returns:
     *        - users : string[int] : a hashmap of user id to username
     */
    static string[int] getConnectedUsers() {
        return ApplicationState.connectedUsers;
    }

    /**
     * Adds a user to the set of connected users
     *
     * Params:
     *       - username : string : the username of the user to add
     *       - uid      : int : the user id of the user to add
     */
    static void addConnectedUser(string username, int uid) {
        ApplicationState.connectedUsers[uid] = username;
    }

    /**
     * Removes a user from the set of connected users
     *
     * Params:
     *       - uid : int : the user id of the user to remove
     */
    static void removeConnectedUser(int uid) {
        ApplicationState.connectedUsers.remove(uid);
    }

    /**
     * Gets the current chat history
     *
     * Returns:
     *        - chatHistory : Tuple!(string, int, long, string)[] : the current chat history
     */
    static Tuple!(string, int, long, string)[] getChatHistory() {
        return ApplicationState.chatHistory;
    }

    /**
     * Adds a chat to the chat history
     *
     * Params:
     *       - chatPackage : Tuple!(string, int, long, string) : a username, id, timestamp, message package
     */
    static void addChatPacket(Tuple!(string, int, long, string) chatPackage) {
        ApplicationState.chatHistory ~= chatPackage;
    }

    /**
     * Prepends the given command tuple to the command history
     * 
     * Params: 
     *        - cmd : Tuple!(string, int, Command) : a username, user id, Command tuple
     */
    static void addToCommandHistory(Tuple!(string, int, Command) cmd)
    {
        ApplicationState.commandHistory = [cmd] ~ ApplicationState.commandHistory;
    }

    /**
     * Pops the last command tuple off the front of the history array. 
     * 
     * Returns:
     *        - commandTuple : Tuple!(string, int, Command) : if len(history) > 0
     *        - null         : null : if len(history) == 0
     */
    static Tuple!(string, int, Command) popFromCommandHistory()
    {
        if (ApplicationState.commandHistory.length >= 1)
        {
            auto lastCommand = ApplicationState.commandHistory[0];
            ApplicationState.commandHistory = ApplicationState.commandHistory[1 .. $];
            return lastCommand;
        } else {
            Command badCmd = null;
            return tuple("", -1, badCmd);
        }
    }

    /**
     * Gets the current command tuple history.
     *
     * Returns:
     *        - commandHistory : Tuple!(string, int, Command)[] : the current command history
     */
    static Tuple!(string, int, Command)[] getCommandHistory()
    {
        return ApplicationState.commandHistory;
    }

    /**
     * Sets the current command tuple history.
     *
     * Params:
     *       - history : Tuple!(string, int, Command)[] : the history to set
     */
    static void setCommandHistory(Tuple!(string, int, Command)[] history) {
        ApplicationState.commandHistory = history;
    }

    /**
     * Gets the current command id
     * 
     * Returns:
     *        - cid : int : the current command id
     */
    static int getCurCommandId() {
        return ApplicationState.curCmd;
    }

    /**
     * Increments the current command id
     */
    static void goToNextCommandId() {
        ApplicationState.curCmd += 1;
    }
}
