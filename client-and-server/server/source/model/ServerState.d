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
    static string[int] connectedUsers;
    static string[] chatHistory = [];
    static string[] commandHistory = [];

public:
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
     * Wipes the current set of connected users.
     */
    static void wipeConnectedUsers()
    {
        string[int] emptySet;
        connectedUsers = emptySet;
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
     *        - chatHistory : string[] : the history of chat packets
     */
    static string[] getChatHistory()
    {
        return ServerState.chatHistory;
    }

    /**
     * Adds a chat to the chat history.
     *
     * Params:
     *       - chatPacket : string : a chat packet
     */
    static void addChatPacket(string chatPacket)
    {
        ServerState.chatHistory ~= chatPacket;
    }

    /**
     * Wipes the chat history.
     */
    static void wipeChatHistory()
    {
        ServerState.chatHistory = [];
    }

    /**
     * Prepends the given command tuple to the command history after executing it.
     *
     * Params:
     *        - cmd : string : a command packet
     */
    static void addToCommandHistory(string cmd)
    {
        ServerState.commandHistory = [cmd] ~ ServerState.commandHistory;
    }

    /**
     * Gets the current command tuple history.
     *
     * Returns:
     *        - commandHistory : string[] : the current command history
     */
    static string[] getCommandHistory()
    {
        return ServerState.commandHistory;
    }

    /**
     * Sets the current command tuple history.
     *
     * Params:
     *       - history : string[] : the history to set
     */
    static void setCommandHistory(string[] history)
    {
        ServerState.commandHistory = history;
    }
}
