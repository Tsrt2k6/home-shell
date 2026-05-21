pragma Singleton

import Quickshell
import QtQuick

Singleton {
	id: root

	property alias date: clock.date //to expose raw date/time
	SystemClock {
		id: clock
		precision: SystemClock.Seconds
	}

	function format(fmt) {
		return Qt.formatDateTime(clock.date, fmt)
	}
}
