/*
qt3d-transform-gizmo
Copyright (C) 2020  Federico Ferri

Adapted to QtQuick3D.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick
import QtQuick3D

Node {
    id: root
    property real thickness: 0.1
    property real tileSize: 0.5
    property int rows: 16
    property int columns: 16
    property color color1: "#ddd"
    property color color2: "#eee"

    Repeater3D {
        model: root.columns
        delegate: Node {
            id: columnDelegate
            required property int index
            readonly property int columnIndex: index

            Repeater3D {
                model: root.rows
                delegate: Model {
                    required property int index
                    readonly property int rowIndex: index
                    readonly property bool evenRow: rowIndex % 2 === 0
                    readonly property bool evenColumn: columnDelegate.columnIndex % 2 === 0

                    source: "#Cube"
                    position: Qt.vector3d(
                        (rowIndex - root.rows / 2) * root.tileSize,
                        -0.5,
                        (columnDelegate.columnIndex - root.columns / 2) * root.tileSize
                    )
                    scale: Qt.vector3d(0.01 * root.tileSize, 0.01* root.thickness, 0.01 * root.tileSize)
                    materials: [
                        PrincipledMaterial {
                            baseColor: evenRow !== evenColumn ? root.color1 : root.color2
                            metalness: 0.0
                            roughness: 1.0
                        }
                    ]
                }
            }
        }
    }
}
