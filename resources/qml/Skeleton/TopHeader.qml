// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import UM 1.4 as UM
import Cura 1.0 as Cura

import "../Accounts"

Rectangle
{
    id: base

    height: UM.Theme.getSize("topheader").height
    color: UM.Theme.getColor("topheader_background")

    Image
    {
        id: logo
        anchors.left: parent.left
        anchors.leftMargin: UM.Theme.getSize("default_margin").width
        anchors.verticalCenter: parent.verticalCenter

        source: UM.Theme.getImage("logo")
        width: UM.Theme.getSize("logo").width
        height: UM.Theme.getSize("logo").height

        sourceSize.width: width
        sourceSize.height: height
    }

    Row
    {
        id: stagesListContainer

        anchors
        {
            horizontalCenter: parent.horizontalCenter
            leftMargin: UM.Theme.getSize("default_margin").width
        }
        spacing: UM.Theme.getSize("default_margin").width

        // The topheader is dynamically filled with all available stages
        Repeater
        {
            id: stagesHeader

            model: UM.StageModel { }

            delegate: Button
            {
                text: model.name
                checkable: true
                checked: model.active
                exclusiveGroup: topheaderMenuGroup
                style: UM.Theme.styles.topheader_tab
                height: UM.Theme.getSize("topheader").height
                onClicked: UM.Controller.setActiveStage(model.id)
                iconSource: model.stage.iconSource

                property color overlayColor: "transparent"
                property string overlayIconSource: ""
            }
        }

        ExclusiveGroup { id: topheaderMenuGroup }
    }

    // Shortcut button to quick access the Toolbox
    Button
    {
        id: toolboxShortcutButton
        text: catalog.i18nc("@action:button", "Toolbox")
        anchors
        {
            right: accountWidget.left
            rightMargin: UM.Theme.getSize("default_margin").width
        }
        style: UM.Theme.styles.topheader_tab
        action: Cura.Actions.browsePackages
    }

    AccountWidget
    {
        id: accountWidget
        anchors
        {
            right: parent.right
            rightMargin: UM.Theme.getSize("default_margin").width
        }
    }
}
