import QtQuick 2.0
import io.thp.pyotherside 1.4

import "../scripts/download.js" as Utils

Python {
	property string base
	property var locator
	property string url
	property bool redownload

	property bool autostart

	signal finished (bool success, string filename, string absoluteFile)

	function activate() {
        addImportPath(Qt.resolvedUrl('../python'));
		importModule('followme', function () {
            url = url.replace(/\n/g, '');
			console.log("url to download is: '" + url + "'");
			var suffix = Utils.getSuffix(url);
			console.log('suffix for file is: ' + suffix);
            console.log(JSON.stringify(locator), locator[0]['label']);
            if(locator[0]['label'] != 'MangaTown') suffix = '.'
			console.log("base filename to be stored is: '" + locator[locator.length - 1]['id'] + "'");
			call('followme.downloadData', [base, locator, suffix, url, redownload], function (result) {
               // console.log(chapter)
				console.log("filename should now be: " + result[0] + " with absoluteFile: " + result[1]);
				if (result[2] !== true) {
					console.error(result[2]);
				}
				finished(result[2] === true, result[0], result[1]);
			});
		});
	}

	onError: finished(false, '', '');

	Component.onCompleted: {
		if (autostart) {
			activate();
		}
	}
}
