/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2015 Jordan Neidlinger <JNeidlinger@gmail.com>
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
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.3 as Controls
import QtQuick.Controls.Styles.Material 0.1 as MaterialStyle
import QtQuick.Controls.Styles 1.2
import QtQuick.Controls.Private 1.0
import Material 0.1

/*!
   \qmltype DatePickerDialog
   \inqmlmodule Material 0.1

   \brief Date Picker provides a simple way to select a valid, formatted date
   presented in a dialog container
 */
Dialog {
    id: datePickerDialog
    hasActions: true
    contentMargins: 0
    floatingActions: true

    property alias datePicker: datePicker

    DatePicker {
        id: datePicker
        frameVisible: false
        dayAreaBottomMargin : Units.dp(48)
    }

}
