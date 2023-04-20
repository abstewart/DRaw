"use strict";
var items = [
{"util.Validator" : "util/Validator.html"},
{"controller.DRawApp" : "controller/DRawApp.html"},
{"controller.DRawApp.DRawApp" : "controller/DRawApp/DRawApp.html"},
{"controller.DRawApp.DRawApp.this" : "controller/DRawApp/DRawApp.html#this"},
{"controller.DRawApp.DRawApp.runMainApplication" : "controller/DRawApp/DRawApp.html#runMainApplication"},
{"controller.commands.Command" : "controller/commands/Command.html"},
{"controller.commands.Command.Command" : "controller/commands/Command/Command.html"},
{"controller.commands.Command.Command.this" : "controller/commands/Command/Command.html#this"},
{"controller.commands.Command.Command.getCmdId" : "controller/commands/Command/Command.html#getCmdId"},
{"controller.commands.Command.Command.execute" : "controller/commands/Command/Command.html#execute"},
{"controller.commands.Command.Command.undo" : "controller/commands/Command/Command.html#undo"},
{"controller.commands.Command.Command.saveOldRect" : "controller/commands/Command/Command.html#saveOldRect"},
{"controller.commands.DrawFilledArcCommand" : "controller/commands/DrawFilledArcCommand.html"},
{"controller.commands.DrawFilledArcCommand.DrawFilledArcCommand" : "controller/commands/DrawFilledArcCommand/DrawFilledArcCommand.html"},
{"controller.commands.DrawFilledArcCommand.DrawFilledArcCommand.this" : "controller/commands/DrawFilledArcCommand/DrawFilledArcCommand.html#this"},
{"controller.commands.DrawFilledArcCommand.DrawFilledArcCommand.execute" : "controller/commands/DrawFilledArcCommand/DrawFilledArcCommand.html#execute"},
{"controller.commands.DrawFilledArcCommand.DrawFilledArcCommand.encode" : "controller/commands/DrawFilledArcCommand/DrawFilledArcCommand.html#encode"},
{"controller.commands.DrawRectangleCommand" : "controller/commands/DrawRectangleCommand.html"},
{"controller.commands.DrawRectangleCommand.DrawRectangleCommand" : "controller/commands/DrawRectangleCommand/DrawRectangleCommand.html"},
{"controller.commands.DrawRectangleCommand.DrawRectangleCommand.this" : "controller/commands/DrawRectangleCommand/DrawRectangleCommand.html#this"},
{"controller.commands.DrawRectangleCommand.DrawRectangleCommand.execute" : "controller/commands/DrawRectangleCommand/DrawRectangleCommand.html#execute"},
{"controller.commands.DrawRectangleCommand.DrawRectangleCommand.encode" : "controller/commands/DrawRectangleCommand/DrawRectangleCommand.html#encode"},
{"controller.commands.DrawPointCommand" : "controller/commands/DrawPointCommand.html"},
{"controller.commands.DrawPointCommand.DrawPointCommand" : "controller/commands/DrawPointCommand/DrawPointCommand.html"},
{"controller.commands.DrawPointCommand.DrawPointCommand.this" : "controller/commands/DrawPointCommand/DrawPointCommand.html#this"},
{"controller.commands.DrawPointCommand.DrawPointCommand.execute" : "controller/commands/DrawPointCommand/DrawPointCommand.html#execute"},
{"controller.commands.DrawPointCommand.DrawPointCommand.encode" : "controller/commands/DrawPointCommand/DrawPointCommand.html#encode"},
{"controller.commands.CommandBuilder" : "controller/commands/CommandBuilder.html"},
{"controller.commands.CommandBuilder.commandMux" : "controller/commands/CommandBuilder.html#commandMux"},
{"controller.commands.DrawLineCommand" : "controller/commands/DrawLineCommand.html"},
{"controller.commands.DrawLineCommand.DrawLineCommand" : "controller/commands/DrawLineCommand/DrawLineCommand.html"},
{"controller.commands.DrawLineCommand.DrawLineCommand.this" : "controller/commands/DrawLineCommand/DrawLineCommand.html#this"},
{"controller.commands.DrawLineCommand.DrawLineCommand.execute" : "controller/commands/DrawLineCommand/DrawLineCommand.html#execute"},
{"controller.commands.DrawLineCommand.DrawLineCommand.encode" : "controller/commands/DrawLineCommand/DrawLineCommand.html#encode"},
{"controller.commands.DrawArcCommand" : "controller/commands/DrawArcCommand.html"},
{"controller.commands.DrawArcCommand.DrawArcCommand" : "controller/commands/DrawArcCommand/DrawArcCommand.html"},
{"controller.commands.DrawArcCommand.DrawArcCommand.this" : "controller/commands/DrawArcCommand/DrawArcCommand.html#this"},
{"controller.commands.DrawArcCommand.DrawArcCommand.execute" : "controller/commands/DrawArcCommand/DrawArcCommand.html#execute"},
{"controller.commands.DrawArcCommand.DrawArcCommand.encode" : "controller/commands/DrawArcCommand/DrawArcCommand.html#encode"},
{"controller.commands.DrawFilledRectangleCommand" : "controller/commands/DrawFilledRectangleCommand.html"},
{"controller.commands.DrawFilledRectangleCommand.DrawFilledRectangleCommand" : "controller/commands/DrawFilledRectangleCommand/DrawFilledRectangleCommand.html"},
{"controller.commands.DrawFilledRectangleCommand.DrawFilledRectangleCommand.this" : "controller/commands/DrawFilledRectangleCommand/DrawFilledRectangleCommand.html#this"},
{"controller.commands.DrawFilledRectangleCommand.DrawFilledRectangleCommand.execute" : "controller/commands/DrawFilledRectangleCommand/DrawFilledRectangleCommand.html#execute"},
{"controller.commands.DrawFilledRectangleCommand.DrawFilledRectangleCommand.encode" : "controller/commands/DrawFilledRectangleCommand/DrawFilledRectangleCommand.html#encode"},
{"model.Communicator" : "model/Communicator.html"},
{"model.Communicator.Communicator" : "model/Communicator/Communicator.html"},
{"model.Communicator.Communicator.this" : "model/Communicator/Communicator.html#this"},
{"model.network.thread_entry" : "model/network/thread_entry.html"},
{"model.network.thread_entry.handleNetworking" : "model/network/thread_entry.html#handleNetworking"},
{"model.network.client" : "model/network/client.html"},
{"model.network.client.Client" : "model/network/client/Client.html"},
{"model.network.client.Client.this" : "model/network/client/Client.html#this"},
{"model.packets.packet" : "model/packets/packet.html"},
{"model.packets.packet.resolveRemotePackets" : "model/packets/packet.html#resolveRemotePackets"},
{"model.packets.packet.parseAndExecuteUserConnPacket" : "model/packets/packet.html#parseAndExecuteUserConnPacket"},
{"model.ApplicationState" : "model/ApplicationState.html"},
{"model.ApplicationState.ApplicationState" : "model/ApplicationState/ApplicationState.html"},
{"model.ApplicationState.ApplicationState.getClientId" : "model/ApplicationState/ApplicationState.html#getClientId"},
{"model.ApplicationState.ApplicationState.setClientId" : "model/ApplicationState/ApplicationState.html#setClientId"},
{"view.MyWindow" : "view/MyWindow.html"},
{"view.MyWindow.MyWindow" : "view/MyWindow/MyWindow.html"},
{"view.MyWindow.MyWindow.this" : "view/MyWindow/MyWindow.html#this"},
{"view.AppBox" : "view/AppBox.html"},
{"view.AppBox.AppBox" : "view/AppBox/AppBox.html"},
{"view.AppBox.AppBox.this" : "view/AppBox/AppBox.html#this"},
{"view.AppBox.AppBox.getMyDrawingBox" : "view/AppBox/AppBox.html#getMyDrawingBox"},
{"view.components.MyChatBox" : "view/components/MyChatBox.html"},
{"view.components.MyChatBox.MyChatBox" : "view/components/MyChatBox/MyChatBox.html"},
{"view.components.MyChatBox.MyChatBox.this" : "view/components/MyChatBox/MyChatBox.html#this"},
{"view.components.PadLabel" : "view/components/PadLabel.html"},
{"view.components.PadLabel.PadLabel" : "view/components/PadLabel/PadLabel.html"},
{"view.components.PadLabel.PadLabel.this" : "view/components/PadLabel/PadLabel.html#this"},
{"view.components.MyDrawingBox" : "view/components/MyDrawingBox.html"},
{"view.components.MyDrawingBox.MyDrawingBox" : "view/components/MyDrawingBox/MyDrawingBox.html"},
{"view.components.MyDrawingBox.MyDrawingBox.this" : "view/components/MyDrawingBox/MyDrawingBox.html#this"},
{"view.components.MyDrawingBox.MyDrawingBox.showColor" : "view/components/MyDrawingBox/MyDrawingBox.html#showColor"},
{"view.components.PadEntry" : "view/components/PadEntry.html"},
{"view.components.PadEntry.PadEntry" : "view/components/PadEntry/PadEntry.html"},
{"view.components.PadEntry.PadEntry.this" : "view/components/PadEntry/PadEntry.html#this"},
{"view.components.PadEntry.PadEntry.setVisibility" : "view/components/PadEntry/PadEntry.html#setVisibility"},
{"view.components.PadEntry.PadEntry.setWidthInCharacters" : "view/components/PadEntry/PadEntry.html#setWidthInCharacters"},
{"view.components.PadEntry.PadEntry.getText" : "view/components/PadEntry/PadEntry.html#getText"},
{"view.components.ConnectGrid" : "view/components/ConnectGrid.html"},
{"view.components.ConnectGrid.ConnectGrid" : "view/components/ConnectGrid/ConnectGrid.html"},
{"view.components.ConnectGrid.ConnectGrid.this" : "view/components/ConnectGrid/ConnectGrid.html#this"},
{"view.components.ConnectGrid.ConnectGrid.getData" : "view/components/ConnectGrid/ConnectGrid.html#getData"},
{"view.components.DRawAbout" : "view/components/DRawAbout.html"},
{"view.components.DRawAbout.DRawAbout" : "view/components/DRawAbout/DRawAbout.html"},
{"view.components.DRawAbout.DRawAbout.this" : "view/components/DRawAbout/DRawAbout.html#this"},
{"view.components.ChatBox" : "view/components/ChatBox.html"},
{"view.components.ChatBox.ChatBox" : "view/components/ChatBox/ChatBox.html"},
{"view.components.ChatBox.ChatBox.this" : "view/components/ChatBox/ChatBox.html#this"},
{"view.components.AreaContent" : "view/components/AreaContent.html"},
{"view.components.AreaContent.AreaContent" : "view/components/AreaContent/AreaContent.html"},
{"view.components.AreaContent.AreaContent.this" : "view/components/AreaContent/AreaContent.html#this"},
{"view.components.MyColorChooserDialog" : "view/components/MyColorChooserDialog.html"},
{"view.components.MyColorChooserDialog.MyColorChooserDialog" : "view/components/MyColorChooserDialog/MyColorChooserDialog.html"},
{"view.components.MyColorChooserDialog.MyColorChooserDialog.this" : "view/components/MyColorChooserDialog/MyColorChooserDialog.html#this"},
{"view.components.DisconnectDialog" : "view/components/DisconnectDialog.html"},
{"view.components.DisconnectDialog.DisconnectDialog" : "view/components/DisconnectDialog/DisconnectDialog.html"},
{"view.components.DisconnectDialog.DisconnectDialog.this" : "view/components/DisconnectDialog/DisconnectDialog.html#this"},
{"view.components.HPadBox" : "view/components/HPadBox.html"},
{"view.components.HPadBox.HPadBox" : "view/components/HPadBox/HPadBox.html"},
{"view.components.HPadBox.HPadBox.this" : "view/components/HPadBox/HPadBox.html#this"},
{"view.components.BrushTypeComboBoxText" : "view/components/BrushTypeComboBoxText.html"},
{"view.components.BrushTypeComboBoxText.BrushTypeComboBoxText" : "view/components/BrushTypeComboBoxText/BrushTypeComboBoxText.html"},
{"view.components.BrushTypeComboBoxText.BrushTypeComboBoxText.this" : "view/components/BrushTypeComboBoxText/BrushTypeComboBoxText.html#this"},
{"view.components.BoxJustify" : "view/components/BoxJustify.html"},
{"view.components.BoxJustify.BoxJustify" : "view/components/BoxJustify/BoxJustify.html"},
{"view.components.MyDrawing" : "view/components/MyDrawing.html"},
{"view.components.MyDrawing.MyDrawing" : "view/components/MyDrawing/MyDrawing.html"},
{"view.components.MyDrawing.MyDrawing.this" : "view/components/MyDrawing/MyDrawing.html#this"},
{"view.components.MyDrawing.MyDrawing.getSpin" : "view/components/MyDrawing/MyDrawing.html#getSpin"},
{"view.components.MyDrawing.MyDrawing.getImageSurface" : "view/components/MyDrawing/MyDrawing.html#getImageSurface"},
{"view.components.MyDrawing.MyDrawing.updateBrushColor" : "view/components/MyDrawing/MyDrawing.html#updateBrushColor"},
{"view.components.ConnectDialog" : "view/components/ConnectDialog.html"},
{"view.components.ConnectDialog.ConnectDialog" : "view/components/ConnectDialog/ConnectDialog.html"},
{"view.components.ConnectDialog.ConnectDialog.this" : "view/components/ConnectDialog/ConnectDialog.html#this"},
{"model.server_network" : "model/server_network.html"},
{"model.server_network.serverResolveRemotePacket" : "model/server_network.html#serverResolveRemotePacket"},
{"model.ServerState" : "model/ServerState.html"},
{"model.ServerState.ServerState" : "model/ServerState/ServerState.html"},
{"model.ServerState.ServerState.getConnectedUsers" : "model/ServerState/ServerState.html#getConnectedUsers"},
{"model.ServerState.ServerState.wipeConnectedUsers" : "model/ServerState/ServerState.html#wipeConnectedUsers"},
{"model.ServerState.ServerState.addConnectedUser" : "model/ServerState/ServerState.html#addConnectedUser"},
];
function search(str) {
	var re = new RegExp(str.toLowerCase());
	var ret = {};
	for (var i = 0; i < items.length; i++) {
		var k = Object.keys(items[i])[0];
		if (re.test(k.toLowerCase()))
			ret[k] = items[i][k];
	}
	return ret;
}

function searchSubmit(value, event) {
	console.log("searchSubmit");
	var resultTable = document.getElementById("results");
	while (resultTable.firstChild)
		resultTable.removeChild(resultTable.firstChild);
	if (value === "" || event.keyCode == 27) {
		resultTable.style.display = "none";
		return;
	}
	resultTable.style.display = "block";
	var results = search(value);
	var keys = Object.keys(results);
	if (keys.length === 0) {
		var row = resultTable.insertRow();
		var td = document.createElement("td");
		var node = document.createTextNode("No results");
		td.appendChild(node);
		row.appendChild(td);
		return;
	}
	for (var i = 0; i < keys.length; i++) {
		var k = keys[i];
		var v = results[keys[i]];
		var link = document.createElement("a");
		link.href = v;
		link.textContent = k;
		link.attributes.id = "link" + i;
		var row = resultTable.insertRow();
		row.appendChild(link);
	}
}

function hideSearchResults(event) {
	if (event.keyCode != 27)
		return;
	var resultTable = document.getElementById("results");
	while (resultTable.firstChild)
		resultTable.removeChild(resultTable.firstChild);
	resultTable.style.display = "none";
}

