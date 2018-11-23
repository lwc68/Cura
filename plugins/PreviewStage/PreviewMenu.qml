// Copyright (c) 2018 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.7
import QtQuick.Controls 2.3

import UM 1.3 as UM
import Cura 1.1 as Cura

Item
{
    id: previewMenu
    // This widget doesn't show tooltips by itself. Instead it emits signals so others can do something with it.
    signal showTooltip(Item item, point location, string text)
    signal hideTooltip()

    property real itemHeight: height - 2 * UM.Theme.getSize("default_lining").width

    UM.I18nCatalog
    {
        id: catalog
        name: "cura"
    }


    Row
    {
        id: stageMenuRow
        anchors.centerIn: parent
        height: parent.height

        Cura.ExpandableComponent
        {
            id: viewSelector
            iconSource: expanded ? UM.Theme.getIcon("arrow_bottom") : UM.Theme.getIcon("arrow_left")
            height: parent.height
            width: UM.Theme.getSize("views_selector").width
            headerCornerSide: Cura.RoundedRectangle.Direction.Left

            property var viewModel: UM.ViewModel { }

            property var activeView:
            {
                for (var i = 0; i < viewModel.rowCount(); i++)
                {
                    if (viewModel.items[i].active)
                    {
                        return viewModel.items[i]
                    }
                }
                return null
            }

            Component.onCompleted:
            {
                // Nothing was active, so just return the first one (the list is sorted by priority, so the most
                // important one should be returned)
                if (activeView == null)
                {
                    UM.Controller.setActiveView(viewModel.getItem(0).id)
                }
            }

            headerItem: Label
            {
                text: viewSelector.activeView ? viewSelector.activeView.name : ""
                verticalAlignment: Text.AlignVCenter
                height: parent.height
                elide: Text.ElideRight
                font: UM.Theme.getFont("default")
                color: UM.Theme.getColor("text")
                renderType: Text.NativeRendering
            }

            popupItem: Column
            {
                id: viewSelectorPopup
                width: viewSelector.width - 2 * UM.Theme.getSize("default_margin").width

                // For some reason the height/width of the column gets set to 0 if this is not set...
                Component.onCompleted:
                {
                    height = implicitHeight
                    width = viewSelector.width - 2 * UM.Theme.getSize("default_margin").width
                }

                Repeater
                {
                    id: viewsList
                    model: viewSelector.viewModel
                    RoundButton
                    {
                        text: name
                        radius: UM.Theme.getSize("default_radius").width
                        checkable: true
                        checked: viewSelector.activeView != null ? viewSelector.activeView.id == id : false
                        onClicked:
                        {
                            viewSelector.togglePopup()
                            UM.Controller.setActiveView(id)
                        }
                    }
                }

            }
        }

        // Separator line
        Rectangle
        {
            height: parent.height
            // If there is no viewPanel, we only need a single spacer, so hide this one.
            visible: viewPanel.source != ""
            width: visible ? UM.Theme.getSize("default_lining").width : 0

            color: UM.Theme.getColor("lining")
        }

        Loader
        {
            id: viewPanel
            height: parent.height
            width: childrenRect.width
            source: UM.Controller.activeView != null && UM.Controller.activeView.stageMenuComponent != null ? UM.Controller.activeView.stageMenuComponent : ""
        }

        // Separator line
        Rectangle
        {
            height: parent.height
            width: UM.Theme.getSize("default_lining").width
            color: UM.Theme.getColor("lining")
        }

        Item
        {
            id: printSetupSelectorItem
            // This is a work around to prevent the printSetupSelector from having to be re-loaded every time
            // a stage switch is done.
            children: [printSetupSelector]
            height: childrenRect.height
            width: childrenRect.width
        }
    }
}