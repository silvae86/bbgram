import bb.cascades 1.2

import "../settings"
import "../contacts"

Sheet {
    id: me
    property int state : 0
    
    property int prev_filter : 3
    property NewGroupFinal finalStep : null
    
    onCreationCompleted: {
        prev_filter = _contacts.filter
        _contacts.setFilter(1)
        
        finalStep = newGroupFinalSheetDef.createObject();
        finalStep.selectionDataModel = selectionDataModel;
        
        finalStep.created.connect(creationCompleated);
    }
    
    function creationCompleated()
    {
        finalStep.created.disconnect(creationCompleated);
        _contacts.setFilter(prev_filter);
        me.close()
    }
    
    Page {
        titleBar: TitleBar {
            id: titleBar
            kind: TitleBarKind.Default
            title: "New Group"
            acceptAction: ActionItem {
                enabled: contactsList.selectedCount > 0
                title: "Next"
                
                onTriggered: {
                    finalStep.open();
                }
            }
            dismissAction: ActionItem {
                title: "Cancel"
                onTriggered:{
                    _contacts.setFilter(prev_filter);
                    me.close()
                }
            }
        }
        Container {
            ListView {
                id: contactsList
                dataModel: _contacts ? _contacts.model : null
                
                property int selectedCount : 0
                
                listItemComponents: [
                    ListItemComponent {
                        type: "header"
                        Header {
                            visible: ListItemData != "!"
                            title: ListItemData
                        }
                    },
                    ListItemComponent {
                        type: "item"
                        ContactItem { }
                    
                    }
                ]
                onTriggered: {
                    toggleSelection(indexPath)
                }
                
                onSelectionChanged: {
                    selected ? selectedCount++ : selectedCount--
                    
                    if (selected)
                        selectionDataModel.insert(dataModel.data(indexPath));
                    else
                        selectionDataModel.remove(dataModel.data(indexPath));
                }
            }
        }
        attachedObjects: [
            GroupDataModel {
                id: selectionDataModel
            },
            ComponentDefinition {
                id: newGroupFinalSheetDef
                source: "NewGroupFinal.qml"
            }
        ]
    }
}