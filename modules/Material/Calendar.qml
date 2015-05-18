/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2014 Bogdan Cuza <bogdan.cuza@hotmail.com>
 *               2015 Ricardo Vieira <ricardo.vieira@tecnico.ulisboa.pt>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import QtQuick.Controls 1.3 as Controls
import QtQuick.Controls.Styles.Material 0.1 as MaterialStyle
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls.Private 1.0
import Material 0.1

/*!
   \qmltype Calendar
   \inqmlmodule Material 0.1

   \brief TODO
 */
Controls.Calendar {
	frameVisible: false
	style: CalendarStyle {
		gridVisible: false

		property int calendarWidth: Units.dp(280)
		property int calendarHeight: Units.dp(460)

		background: Rectangle {
			color: "transparent"
			implicitWidth: calendarWidth
			implicitHeight: calendarHeight
		}

		navigationBar: Rectangle {
			height: Units.dp(180)
			color: Theme.dark.accentColor

			Rectangle {
				id: topOfHeader
				color: Qt.rgba(0, 0, 0, 0.2)
				height: Units.dp(36)
				width: parent.width

				Label {
					text: control.selectedDate.toLocaleString(control.__locale, "dddd")
					anchors.centerIn: parent
					font.weight: Font.Normal
					font.pixelSize: Units.dp(16)
					color: Theme.dark.textColor
				}
			}

			Rectangle {
				anchors.top: topOfHeader.bottom
				anchors.bottom: parent.bottom
				width: parent.width
				color: "transparent"

				Label {
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.bottom: dayTitle.top
					anchors.bottomMargin: -Units.dp(8)
					font.weight: Font.Normal
					font.pixelSize: Units.dp(26)
					color: Theme.dark.textColor
					text: control.selectedDate.toLocaleString(control.__locale, "MMM").toUpperCase()
				}

				Label {
					id: dayTitle
					anchors.centerIn: parent
					font.weight: Font.DemiBold
					font.pixelSize: Units.dp(60)
					color: Theme.dark.textColor
					text: control.selectedDate.toLocaleString(control.__locale, "d")
				}

				Label {
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.top: dayTitle.bottom
					anchors.topMargin: -Units.dp(4)
					font.weight: Font.Normal
					font.pixelSize: Units.dp(26)
					color: Qt.rgba(1, 1, 1, 0.7)
					text: control.selectedDate.toLocaleString(control.__locale, "yyyy")
				}

				IconButton {
					iconName: "navigation/chevron_left"
					id: previousMonth
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(8)
					onClicked: control.showPreviousMonth()
				}

				IconButton {
					iconName: "navigation/chevron_right"
					id: nextMonth
					anchors.verticalCenter: parent.verticalCenter
					anchors.right: parent.right
					anchors.rightMargin: Units.dp(8)
					onClicked: control.showNextMonth()
				}
			}
		}

		dayOfWeekDelegate: Rectangle {
			color: "transparent"
			implicitHeight: Units.dp(30)
			Label {
				text: control.__locale.dayName(styleData.dayOfWeek, Locale.NarrowFormat).substring(0, 1)
				color: Theme.light.subTextColor
				anchors.centerIn: parent
			}
		}

		dayDelegate: Item {

			visible: styleData.visibleMonth

			Rectangle {
				anchors.centerIn: parent
				width: 1 * Math.min(parent.width, parent.height)
				height: width

				color: styleData.selected ? Theme.accentColor : "transparent"
				radius: height/2
			}

			Label {
				text: styleData.date.getDate()
				anchors.centerIn: parent
				color: styleData.selected
						? "white" : styleData.today
							? Theme.accentColor : Theme.light.textColor
			}
		}

		panel: Item {
			id: panelItem

			implicitWidth: backgroundLoader.implicitWidth
			implicitHeight: backgroundLoader.implicitHeight

			property alias navigationBarItem: navigationBarLoader.item

			property alias dayOfWeekHeaderRow: dayOfWeekHeaderRow

			readonly property int weeksToShow: 6
			readonly property int rows: weeksToShow
			readonly property int columns: CalendarUtils.daysInAWeek

			// The combined available width and height to be shared amongst each cell.
			readonly property real availableWidth: viewContainer.width
			readonly property real availableHeight: viewContainer.height

			property int hoveredCellIndex: -1
			property int pressedCellIndex: -1
			property int pressCellIndex: -1

			Rectangle {
				anchors.fill: parent
				color: "transparent"
				border.color: gridColor
				visible: control.frameVisible
			}

			Item {
				id: container
				anchors.fill: parent
				anchors.margins: control.frameVisible ? 1 : 0

				Loader {
					id: backgroundLoader
					anchors.fill: parent
					sourceComponent: background
				}

				Loader {
					id: navigationBarLoader
					anchors.left: parent.left
					anchors.right: parent.right
					anchors.top: parent.top
					sourceComponent: navigationBar
					active: control.navigationBarVisible

					property QtObject styleData: QtObject {
						readonly property string title: control.__locale.standaloneMonthName(control.visibleMonth)
							+ new Date(control.visibleYear, control.visibleMonth, 1).toLocaleDateString(control.__locale, " yyyy")
					}
				}

				Rectangle {
					id: dayOfWeekHeaderRow
					anchors.top: navigationBarLoader.bottom
					anchors.left: parent.left
					anchors.right: parent.right
					height: Units.dp(64)

					Label {
						anchors.bottom: calenderHeader.top
						anchors.horizontalCenter: parent.horizontalCenter
						font.weight: Font.Black
						style: "subheading"
						text: control.__locale.standaloneMonthName(control.visibleMonth) + " " + control.visibleYear
					}

					Row {
						id: calenderHeader
						anchors.bottom: parent.bottom
						anchors.left: parent.left
						anchors.leftMargin: Units.dp(16)//(control.weekNumbersVisible ? weekNumbersItem.width : 0)
						anchors.right: parent.right
						anchors.rightMargin: Units.dp(16)

						spacing: gridVisible ? __gridLineWidth : 0

						Repeater {
							id: repeater
							model: CalendarHeaderModel {
								locale: control.__locale
							}
							Loader {
								id: dayOfWeekDelegateLoader
								sourceComponent: dayOfWeekDelegate
								width: __cellRectAt(index).width

								readonly property int __index: index
								readonly property var __dayOfWeek: dayOfWeek

								property QtObject styleData: QtObject {
									readonly property alias index: dayOfWeekDelegateLoader.__index
									readonly property alias dayOfWeek: dayOfWeekDelegateLoader.__dayOfWeek
								}
							}
						}
					}
				}
				Rectangle {
					id: topGridLine
					color: __horizontalSeparatorColor
					width: parent.width
					height: __gridLineWidth
					visible: gridVisible
					anchors.top: dayOfWeekHeaderRow.bottom
				}

				Row {
					id: gridRow
					width: weekNumbersItem.width + viewContainer.width - Units.dp(32)
					height: viewContainer.height
					anchors.top: topGridLine.bottom
					anchors.left: parent.left
					anchors.leftMargin: Units.dp(16)

					Column {
						id: weekNumbersItem
						visible: control.weekNumbersVisible
						height: viewContainer.height
						spacing: gridVisible ? __gridLineWidth : 0
						Repeater {
							id: weekNumberRepeater
							model: panelItem.weeksToShow

							Loader {
								id: weekNumberDelegateLoader
								height: __cellRectAt(index * panelItem.columns).height
								sourceComponent: weekNumberDelegate

								readonly property int __index: index
								property int __weekNumber: control.__model.weekNumberAt(index)

								Connections {
									target: control
									onVisibleMonthChanged: __weekNumber = control.__model.weekNumberAt(index)
									onVisibleYearChanged: __weekNumber = control.__model.weekNumberAt(index)
								}

								Connections {
									target: control.__model
									onCountChanged: __weekNumber = control.__model.weekNumberAt(index)
								}

								property QtObject styleData: QtObject {
									readonly property alias index: weekNumberDelegateLoader.__index
									readonly property int weekNumber: weekNumberDelegateLoader.__weekNumber
								}
							}
						}
					}

					Rectangle {
						id: separator
						anchors.topMargin: - dayOfWeekHeaderRow.height - 1
						anchors.top: weekNumbersItem.top
						anchors.bottom: weekNumbersItem.bottom

						width: __gridLineWidth
						color: __verticalSeparatorColor
						visible: control.weekNumbersVisible
					}

					// Contains the grid lines and the grid itself.
					Item {
						id: viewContainer
						width: container.width - (control.weekNumbersVisible ? weekNumbersItem.width + separator.width : 0) - Units.dp(32)
						height: container.height - navigationBarLoader.height - dayOfWeekHeaderRow.height - topGridLine.height

						Repeater {
							id: verticalGridLineRepeater
							model: panelItem.columns - 1
							delegate: Rectangle {
								x: __cellRectAt(index + 1).x - __gridLineWidth
								y: 0
								width: __gridLineWidth
								height: viewContainer.height
								color: gridColor
								visible: gridVisible
							}
						}

						Repeater {
							id: horizontalGridLineRepeater
							model: panelItem.rows - 1
							delegate: Rectangle {
								x: 0
								y: __cellRectAt((index + 1) * panelItem.columns).y - __gridLineWidth
								width: viewContainer.width
								height: __gridLineWidth
								color: gridColor
								visible: gridVisible
							}
						}

						MouseArea {
							id: mouseArea
							anchors.fill: parent

							hoverEnabled: true

							function cellIndexAt(mouseX, mouseY) {
								var viewContainerPos = viewContainer.mapFromItem(mouseArea, mouseX, mouseY);
								var child = viewContainer.childAt(viewContainerPos.x, viewContainerPos.y);
								// In the tests, the mouseArea sometimes gets picked instead of the cells,
								// probably because stuff is still loading. To be safe, we check for that here.
								return child && child !== mouseArea ? child.__index : -1;
							}

							onEntered: {
								hoveredCellIndex = cellIndexAt(mouseX, mouseY);
								if (hoveredCellIndex === undefined) {
									hoveredCellIndex = cellIndexAt(mouseX, mouseY);
								}

								var date = view.model.dateAt(hoveredCellIndex);
								if (__isValidDate(date)) {
									control.hovered(date);
								}
							}

							onExited: {
								hoveredCellIndex = -1;
							}

							onPositionChanged: {
								var indexOfCell = cellIndexAt(mouse.x, mouse.y);
								var previousHoveredCellIndex = hoveredCellIndex;
								hoveredCellIndex = indexOfCell;
								if (indexOfCell !== -1) {
									var date = view.model.dateAt(indexOfCell);
									if (__isValidDate(date)) {
										if (hoveredCellIndex !== previousHoveredCellIndex)
											control.hovered(date);

										// The date must be different for the pressed signal to be emitted.
										if (pressed && date.getTime() !== control.selectedDate.getTime()) {
											control.pressed(date);

											// You can't select dates in a different month while dragging.
											if (date.getMonth() === control.selectedDate.getMonth()) {
												control.selectedDate = date;
												pressedCellIndex = indexOfCell;
											}
										}
									}
								}
							}

							onPressed: {
								pressCellIndex = cellIndexAt(mouse.x, mouse.y);
								if (pressCellIndex !== -1) {
									var date = view.model.dateAt(pressCellIndex);
									pressedCellIndex = pressCellIndex;
									//if (__isValidDate(date)) {   // ORIGINAL
									if (__isValidDate(date) && (date.getMonth() === control.visibleMonth && date.getFullYear() === control.visibleYear)) {       //  MODIFICATION
										control.selectedDate = date;
										control.pressed(date);
									}
								}
							}

							onReleased: {
								var indexOfCell = cellIndexAt(mouse.x, mouse.y);
								if (indexOfCell !== -1) {
									// The cell index might be valid, but the date has to be too. We could let the
									// selected date validation take care of this, but then the selected date would
									// change to the earliest day if a day before the minimum date is clicked, for example.
									var date = view.model.dateAt(indexOfCell);
									if (__isValidDate(date)) {
										control.released(date);
									}
								}
								pressedCellIndex = -1;
							}

							onClicked: {
								var indexOfCell = cellIndexAt(mouse.x, mouse.y);
								if (indexOfCell !== -1 && indexOfCell === pressCellIndex) {
									var date = view.model.dateAt(indexOfCell);
									if (__isValidDate(date))
										control.clicked(date);
								}
							}

							onDoubleClicked: {
								var indexOfCell = cellIndexAt(mouse.x, mouse.y);
								if (indexOfCell !== -1) {
									var date = view.model.dateAt(indexOfCell);
									if (__isValidDate(date))
										control.doubleClicked(date);
								}
							}

							onPressAndHold: {
								var indexOfCell = cellIndexAt(mouse.x, mouse.y);
								if (indexOfCell !== -1 && indexOfCell === pressCellIndex) {
									var date = view.model.dateAt(indexOfCell);
									if (__isValidDate(date))
										control.pressAndHold(date);
								}
							}
						}

						Connections {
							target: control
							onSelectedDateChanged: view.selectedDateChanged()
						}

						Repeater {
							id: view

							property int currentIndex: -1

							model: control.__model

							Component.onCompleted: selectedDateChanged()

							function selectedDateChanged() {
								if (model !== undefined && model.locale !== undefined) {
									currentIndex = model.indexAt(control.selectedDate);
								}
							}

							delegate: Loader {
								id: delegateLoader

								x: __cellRectAt(index).x
								y: __cellRectAt(index).y
								width: __cellRectAt(index).width
								height: __cellRectAt(index).height
								sourceComponent: dayDelegate

								readonly property int __index: index
								readonly property date __date: date
								// We rely on the fact that an invalid QDate will be converted to a Date
								// whose year is -4713, which is always an invalid date since our
								// earliest minimum date is the year 1.
								readonly property bool valid: __isValidDate(date)

								property QtObject styleData: QtObject {
									readonly property alias index: delegateLoader.__index
									readonly property bool selected: control.selectedDate.getTime() === date.getTime()
									readonly property alias date: delegateLoader.__date
									readonly property bool valid: delegateLoader.valid
									// TODO: this will not be correct if the app is running when a new day begins.
									readonly property bool today: date.getTime() === new Date().setHours(0, 0, 0, 0)
									readonly property bool visibleMonth: date.getMonth() === control.visibleMonth
									readonly property bool hovered: panelItem.hoveredCellIndex == index
									readonly property bool pressed: panelItem.pressedCellIndex == index
									// todo: pressed property here, clicked and doubleClicked in the control itself
								}
							}
						}
					}
				}
			}
		}
	}
}
