"use strict";
var items = [
{"controller.EncodeDecode" : "controller/EncodeDecode.html"},
{"controller.DRawApp" : "controller/DRawApp.html"},
{"controller.DRawApp.DRawApp" : "controller/DRawApp/DRawApp.html"},
{"controller.DRawApp.DRawApp.this" : "controller/DRawApp/DRawApp.html#this"},
{"controller.DRawApp.DRawApp.runMainApplication" : "controller/DRawApp/DRawApp.html#runMainApplication"},
{"controller.DRawAbout" : "controller/DRawAbout.html"},
{"controller.DRawAbout.DRawAbout" : "controller/DRawAbout/DRawAbout.html"},
{"controller.DRawAbout.DRawAbout.this" : "controller/DRawAbout/DRawAbout.html#this"},
{"controller.commands.Command" : "controller/commands/Command.html"},
{"controller.commands.Command.Command" : "controller/commands/Command/Command.html"},
{"controller.commands.Command.Command.execute" : "controller/commands/Command/Command.html#execute"},
{"controller.commands.Command.Command.undo" : "controller/commands/Command/Command.html#undo"},
{"controller.commands.Command.Command.encode" : "controller/commands/Command/Command.html#encode"},
{"controller.commands.DrawFilledArcCommand" : "controller/commands/DrawFilledArcCommand.html"},
{"controller.commands.DrawFilledArcCommand.DrawFilledArcCommand" : "controller/commands/DrawFilledArcCommand/DrawFilledArcCommand.html"},
{"controller.commands.DrawFilledArcCommand.DrawFilledArcCommand.this" : "controller/commands/DrawFilledArcCommand/DrawFilledArcCommand.html#this"},
{"controller.commands.DrawFilledArcCommand.DrawFilledArcCommand.execute" : "controller/commands/DrawFilledArcCommand/DrawFilledArcCommand.html#execute"},
{"controller.commands.DrawFilledArcCommand.DrawFilledArcCommand.undo" : "controller/commands/DrawFilledArcCommand/DrawFilledArcCommand.html#undo"},
{"controller.commands.DrawRectangleCommand" : "controller/commands/DrawRectangleCommand.html"},
{"controller.commands.DrawRectangleCommand.DrawRectangleCommand" : "controller/commands/DrawRectangleCommand/DrawRectangleCommand.html"},
{"controller.commands.DrawRectangleCommand.DrawRectangleCommand.this" : "controller/commands/DrawRectangleCommand/DrawRectangleCommand.html#this"},
{"controller.commands.DrawRectangleCommand.DrawRectangleCommand.execute" : "controller/commands/DrawRectangleCommand/DrawRectangleCommand.html#execute"},
{"controller.commands.DrawRectangleCommand.DrawRectangleCommand.undo" : "controller/commands/DrawRectangleCommand/DrawRectangleCommand.html#undo"},
{"controller.commands.DrawPointCommand" : "controller/commands/DrawPointCommand.html"},
{"controller.commands.DrawPointCommand.DrawPointCommand" : "controller/commands/DrawPointCommand/DrawPointCommand.html"},
{"controller.commands.DrawPointCommand.DrawPointCommand.this" : "controller/commands/DrawPointCommand/DrawPointCommand.html#this"},
{"controller.commands.DrawPointCommand.DrawPointCommand.execute" : "controller/commands/DrawPointCommand/DrawPointCommand.html#execute"},
{"controller.commands.DrawPointCommand.DrawPointCommand.undo" : "controller/commands/DrawPointCommand/DrawPointCommand.html#undo"},
{"controller.commands.DrawLineCommand" : "controller/commands/DrawLineCommand.html"},
{"controller.commands.DrawLineCommand.DrawLineCommand" : "controller/commands/DrawLineCommand/DrawLineCommand.html"},
{"controller.commands.DrawLineCommand.DrawLineCommand.this" : "controller/commands/DrawLineCommand/DrawLineCommand.html#this"},
{"controller.commands.DrawLineCommand.DrawLineCommand.execute" : "controller/commands/DrawLineCommand/DrawLineCommand.html#execute"},
{"controller.commands.DrawLineCommand.DrawLineCommand.undo" : "controller/commands/DrawLineCommand/DrawLineCommand.html#undo"},
{"controller.commands.DrawArcCommand" : "controller/commands/DrawArcCommand.html"},
{"controller.commands.DrawArcCommand.DrawArcCommand" : "controller/commands/DrawArcCommand/DrawArcCommand.html"},
{"controller.commands.DrawArcCommand.DrawArcCommand.this" : "controller/commands/DrawArcCommand/DrawArcCommand.html#this"},
{"controller.commands.DrawArcCommand.DrawArcCommand.execute" : "controller/commands/DrawArcCommand/DrawArcCommand.html#execute"},
{"controller.commands.DrawArcCommand.DrawArcCommand.undo" : "controller/commands/DrawArcCommand/DrawArcCommand.html#undo"},
{"controller.commands.DrawFilledRectangleCommand" : "controller/commands/DrawFilledRectangleCommand.html"},
{"controller.commands.DrawFilledRectangleCommand.DrawFilledRectangleCommand" : "controller/commands/DrawFilledRectangleCommand/DrawFilledRectangleCommand.html"},
{"controller.commands.DrawFilledRectangleCommand.DrawFilledRectangleCommand.this" : "controller/commands/DrawFilledRectangleCommand/DrawFilledRectangleCommand.html#this"},
{"controller.commands.DrawFilledRectangleCommand.DrawFilledRectangleCommand.execute" : "controller/commands/DrawFilledRectangleCommand/DrawFilledRectangleCommand.html#execute"},
{"controller.commands.DrawFilledRectangleCommand.DrawFilledRectangleCommand.undo" : "controller/commands/DrawFilledRectangleCommand/DrawFilledRectangleCommand.html#undo"},
{"controller.BoxJustify" : "controller/BoxJustify.html"},
{"controller.BoxJustify.BoxJustify" : "controller/BoxJustify/BoxJustify.html"},
{"controller.Color" : "controller/Color.html"},
{"controller.Color.Color" : "controller/Color/Color.html"},
{"controller.Color.Color.this" : "controller/Color/Color.html#this"},
{"controller.Color.Color.this" : "controller/Color/Color.html#this"},
{"controller.Color.Color.this" : "controller/Color/Color.html#this"},
{"controller.Color.Color.getRed" : "controller/Color/Color.html#getRed"},
{"controller.Color.Color.getBlue" : "controller/Color/Color.html#getBlue"},
{"controller.Color.Color.getGreen" : "controller/Color/Color.html#getGreen"},
{"controller.Color.Color.isValidColor" : "controller/Color/Color.html#isValidColor"},
{"controller.Color.Color.toEncodedString" : "controller/Color/Color.html#toEncodedString"},
{"model.ApplicationState" : "model/ApplicationState.html"},
{"model.ApplicationState.ApplicationState" : "model/ApplicationState/ApplicationState.html"},
{"model.ApplicationState.ApplicationState.this" : "model/ApplicationState/ApplicationState.html#this"},
{"model.ApplicationState.ApplicationState.addToHistory" : "model/ApplicationState/ApplicationState.html#addToHistory"},
{"model.ApplicationState.ApplicationState.popHistory" : "model/ApplicationState/ApplicationState.html#popHistory"},
{"model.ApplicationState.ApplicationState.getHistory" : "model/ApplicationState/ApplicationState.html#getHistory"},
{"view.AppBox" : "view/AppBox.html"},
{"view.AppBox.AppBox" : "view/AppBox/AppBox.html"},
{"view.AppBox.AppBox.this" : "view/AppBox/AppBox.html#this"},
{"view.ApplicationWindow" : "view/ApplicationWindow.html"},
{"view.ApplicationWindow.MyWindow" : "view/ApplicationWindow/MyWindow.html"},
{"view.ApplicationWindow.MyWindow.this" : "view/ApplicationWindow/MyWindow.html#this"},
{"view.ApplicationWindow.MyWindow.getConnection" : "view/ApplicationWindow/MyWindow.html#getConnection"},
{"view.ApplicationWindow.MyWindow.setConnection" : "view/ApplicationWindow/MyWindow.html#setConnection"},
{"view.components.MyChatBox" : "view/components/MyChatBox.html"},
{"view.components.MyChatBox.MyChatBox" : "view/components/MyChatBox/MyChatBox.html"},
{"view.components.MyChatBox.MyChatBox.this" : "view/components/MyChatBox/MyChatBox.html#this"},
{"view.components.MyChatBox.MyChatBox.setUsername" : "view/components/MyChatBox/MyChatBox.html#setUsername"},
{"view.components.PadLabel" : "view/components/PadLabel.html"},
{"view.components.PadLabel.PadLabel" : "view/components/PadLabel/PadLabel.html"},
{"view.components.PadLabel.PadLabel.this" : "view/components/PadLabel/PadLabel.html#this"},
{"view.components.MyDrawingBox" : "view/components/MyDrawingBox.html"},
{"view.components.MyDrawingBox.MyDrawingBox" : "view/components/MyDrawingBox/MyDrawingBox.html"},
{"view.components.MyDrawingBox.MyDrawingBox.this" : "view/components/MyDrawingBox/MyDrawingBox.html#this"},
{"view.components.PadEntry" : "view/components/PadEntry.html"},
{"view.components.PadEntry.PadEntry" : "view/components/PadEntry/PadEntry.html"},
{"view.components.PadEntry.PadEntry.this" : "view/components/PadEntry/PadEntry.html#this"},
{"view.components.PadEntry.PadEntry.setWidthInCharacters" : "view/components/PadEntry/PadEntry.html#setWidthInCharacters"},
{"view.components.PadEntry.PadEntry.getText" : "view/components/PadEntry/PadEntry.html#getText"},
{"view.components.ConnectGrid" : "view/components/ConnectGrid.html"},
{"view.components.ConnectGrid.ConnectGrid" : "view/components/ConnectGrid/ConnectGrid.html"},
{"view.components.ConnectGrid.ConnectGrid.this" : "view/components/ConnectGrid/ConnectGrid.html#this"},
{"view.components.ConnectGrid.ConnectGrid.getData" : "view/components/ConnectGrid/ConnectGrid.html#getData"},
{"view.components.ChatBox" : "view/components/ChatBox.html"},
{"view.components.ChatBox.ChatBox" : "view/components/ChatBox/ChatBox.html"},
{"view.components.ChatBox.ChatBox.this" : "view/components/ChatBox/ChatBox.html#this"},
{"view.components.ChatBox.ChatBox.getMyChatBox" : "view/components/ChatBox/ChatBox.html#getMyChatBox"},
{"view.components.AreaContent" : "view/components/AreaContent.html"},
{"view.components.AreaContent.AreaContent" : "view/components/AreaContent/AreaContent.html"},
{"view.components.AreaContent.AreaContent.this" : "view/components/AreaContent/AreaContent.html#this"},
{"view.components.AreaContent.AreaContent.getConnectGrid" : "view/components/AreaContent/AreaContent.html#getConnectGrid"},
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
{"view.components.MyDrawing" : "view/components/MyDrawing.html"},
{"view.components.MyDrawing.MyDrawing" : "view/components/MyDrawing/MyDrawing.html"},
{"view.components.MyDrawing.MyDrawing.this" : "view/components/MyDrawing/MyDrawing.html#this"},
{"view.components.MyDrawing.MyDrawing.getSpin" : "view/components/MyDrawing/MyDrawing.html#getSpin"},
{"view.components.MyDrawing.MyDrawing.getImageSurface" : "view/components/MyDrawing/MyDrawing.html#getImageSurface"},
{"view.components.MyDrawing.MyDrawing.updateBrushColor" : "view/components/MyDrawing/MyDrawing.html#updateBrushColor"},
{"view.components.MyDrawing.MyDrawing.saveWhiteboard" : "view/components/MyDrawing/MyDrawing.html#saveWhiteboard"},
{"view.components.MyDrawing.MyDrawing.undoWhiteboard" : "view/components/MyDrawing/MyDrawing.html#undoWhiteboard"},
{"view.components.MyDrawing.MyDrawing.onBrushOptionChanged" : "view/components/MyDrawing/MyDrawing.html#onBrushOptionChanged"},
{"view.components.ConnectDialog" : "view/components/ConnectDialog.html"},
{"view.components.ConnectDialog.ConnectDialog" : "view/components/ConnectDialog/ConnectDialog.html"},
{"view.components.ConnectDialog.ConnectDialog.this" : "view/components/ConnectDialog/ConnectDialog.html#this"},
{"view.components.ConnectDialog.ConnectDialog.getUsername" : "view/components/ConnectDialog/ConnectDialog.html#getUsername"},
{"controller.Controller" : "controller/Controller.html"},
{"model.server_network" : "model/server_network.html"},
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

