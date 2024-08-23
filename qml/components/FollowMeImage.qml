import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    id: listItem

	property int partIndex
	property string partId
	property string file
	property string absoluteFile
	property var parentLocator

	signal imageError (var parentLocator, int partIndex, string partId)

	property alias imageSource: imageFile.source
	property bool ready: imageFile.status === Image.Ready

	height:   !horizon ? ready ? imageFile.sourceSize.height * imageFile.width / imageFile.sourceSize.width : busyFile.height + Theme.paddingLarge * 2 : entryPage.height

	Image {
        id: imageFile
		source: absoluteFile
		fillMode: Image.PreserveAspectFit
		width: !horizon ? parent.width - Theme.paddingSmall : entryPage.width
		anchors.rightMargin: !horizon ? Theme.paddingSmall : 0
		height:  !horizon ? ready ? imageFile.sourceSize.height * width / imageFile.sourceSize.width : 0 : entryPage.height

		Component.onCompleted: {
			if (imageFile.status === Image.Error || absoluteFile == '') {
				// fetch online
				console.log("error in image " + absoluteFile);
				imageError(listItem.parentLocator, listItem.partIndex, listItem.partId);
			}
                   
		}
Label {
        id: chapterno
        visible: showoverlay && horizon
        anchors.fill: parent
        color: Theme.highlightColor
        opacity: 0.9
            style: Text.Outline
            font.bold: true
        horizontalAlignment: Text.AlignHCenter
        text: parentEntry.label + ": " + qsTr("Chapter") + " " + (chapter != undefined && chapter.label != undefined ? chapter.label + ' (' +( partIndex+1) + '/' + (partModel.length ) + ')' : ( parentEntry.items[parentEntry.currentIndex].label != undefined ? parentEntry.items[parentEntry.currentIndex].label  : parentEntry.items[parentEntry.currentIndex].id ) )
        
        } 
	}
onClicked: {
        console.log('click', showoverlay, horizon)
                if(!showoverlay){
            showoverlay = true
            //    chapterno.visible = true
        } else {
            showoverlay = false
       //     chapterno.visible = false
        }
    }
	BusyIndicator {
		width: parent.width
        id: busyFile
		running: true
		size: BusyIndicatorSize.Small
		visible: !ready
		anchors.verticalCenter: parent.verticalCenter
	}
    
}
