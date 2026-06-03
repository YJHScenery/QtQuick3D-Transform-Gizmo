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
import QtQuick.Controls
import QtQuick.Window
import QtQuick3D

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 500
    height: 500
    title: "QtQuick3D Transform Gizmo"

    // ══════════════════════════════════════════════════════════════════
    // Camera orbit state — the camera always looks at orbitTarget.
    // Orbit rotates around it; zoom changes distance to it; pan moves it.
    // ══════════════════════════════════════════════════════════════════

    property vector3d orbitTarget: Qt.vector3d(0, 0.5, 0)
    property real orbitDistance: 6.51
    property real orbitYaw: -137.5   // degrees, azimuth
    property real orbitPitch: 37.8   // degrees, elevation

    function updateCamera() {
        var yawRad = orbitYaw * Math.PI / 180.0
        var pitchRad = orbitPitch * Math.PI / 180.0
        var cosPitch = Math.cos(pitchRad)
        var x = orbitTarget.x + orbitDistance * cosPitch * Math.sin(yawRad)
        var y = orbitTarget.y + orbitDistance * Math.sin(pitchRad)
        var z = orbitTarget.z + orbitDistance * cosPitch * Math.cos(yawRad)
        mainCamera.position = Qt.vector3d(x, y, z)
        mainCamera.lookAt(orbitTarget)
    }

    // Extract camera-local axes for pan
    function cameraRight() {
        var m = mainCamera.sceneTransform
        return Qt.vector3d(m.m11, m.m21, m.m31)
    }
    function cameraUp() {
        var m = mainCamera.sceneTransform
        return Qt.vector3d(m.m12, m.m22, m.m32)
    }

    Component.onCompleted: updateCamera()

    // ══════════════════════════════════════════════════════════════════
    // 3D View
    // ══════════════════════════════════════════════════════════════════

    View3D {
        id: view3d
        anchors.fill: parent
        camera: mainCamera

        environment: SceneEnvironment {
            clearColor: "#ddd"
            backgroundMode: SceneEnvironment.Color
        }

        // ── Camera ──────────────────────────────────────────────────

        PerspectiveCamera {
            id: mainCamera
            clipNear: 0.1
            clipFar: 1000.0
            fieldOfView: 45
        }

        // ── Lighting ────────────────────────────────────────────────

        PointLight {
            position: Qt.vector3d(1.0, 3.0, -2.0)
            color: "white"
            brightness: 0.9
            constantFade: 1.0
            linearFade: 0.0
            quadraticFade: 0.0025
        }

        // ── Scene content ───────────────────────────────────────────

        Node {
            id: sceneRoot

            // Checkerboard floor
            Floor { }

            // Cube 1 – grey, rotated
            Model {
                id: cube1
                objectName: "cube1"
                source: "#Cube"
                pickable: true
                scale: Qt.vector3d(0.01, 0.01, 0.01)
                position: Qt.vector3d(0.5, 0.5, 0.5)
                eulerRotation: Qt.vector3d(-45, 45, 0)
                materials: [
                    PrincipledMaterial {
                        baseColor: "#aaa"
                        metalness: 0.0
                        roughness: 0.4
                    }
                ]
            }

            // Cube 2 – teal, with child cube3
            Model {
                id: cube2
                objectName: "cube2"
                source: "#Cube"
                scale: Qt.vector3d(0.01, 0.01, 0.01)
                position: Qt.vector3d(-0.5, 0, 0.5)
                pickable: true

                materials: [
                    PrincipledMaterial {
                        baseColor: "#6cc"
                        metalness: 0.0
                        roughness: 0.4
                    }
                ]

                // Cube 3 – magenta, child of cube2
                Model {
                    id: cube3
                    objectName: "cube3"
                    source: "#Cube"
                    pickable: true

                    // scale: Qt.vector3d(0.01, 0.01, 0.01)
                    position: Qt.vector3d(-0.5, 0, 0.5)
                    scale: Qt.vector3d(0.005, 0.005, 0.005)
                    materials: [
                        PrincipledMaterial {
                            baseColor: "#c6c"
                            metalness: 0.0
                            roughness: 0.4
                        }
                    ]
                }
            }
        }

    }

    // ── Gizmo overlay view (always on top) ───────────────────────────

    View3D {
        id: gizmoView
        anchors.fill: parent
        renderMode: View3D.Overlay
        camera: gizmoCamera

        environment: SceneEnvironment {
            clearColor: "#00000000"
            backgroundMode: SceneEnvironment.Color
        }

        PerspectiveCamera {
            id: gizmoCamera
            position: mainCamera.position
            rotation: mainCamera.rotation
            clipNear: mainCamera.clipNear
            clipFar: mainCamera.clipFar
            fieldOfView: mainCamera.fieldOfView
        }

        TransformGizmo {
            id: tg
            view3d: gizmoView
            camera: gizmoCamera
            size: 0.125 * absolutePosition.minus(gizmoCamera.position).length()
        }
    }

    // ══════════════════════════════════════════════════════════════════
    // Unified mouse handler: camera orbit + gizmo + object picking
    // ══════════════════════════════════════════════════════════════════

    MouseArea {
        id: sceneMouse
        anchors.fill: parent
        hoverEnabled: true

        property point lastPos
        property bool rotating: false
        property bool panning: false

        onPressed: function(mouse) {
            lastPos = Qt.point(mouse.x, mouse.y)

            // Right-click: detach gizmo, or pan camera
            if (mouse.button === Qt.RightButton) {
                if (tg.visible) {
                    tg.detach()
                    return
                }
                panning = true
                return
            }

            // Left-click
            if (mouse.button === Qt.LeftButton) {
                var gizmoPick = gizmoView.pick(mouse.x, mouse.y)

                // Gizmo interaction
                if (tg.visible && gizmoPick.objectHit) {
                    tg.handlePress(gizmoPick)
                    if (tg.activeElement !== TransformGizmo.UIElement.None) {
                        return  // gizmo drag in progress
                    }
                }

                // Click on a cube → attach gizmo
                var pick = view3d.pick(mouse.x, mouse.y)
                if (pick.objectHit) {
                    var name = pick.objectHit.objectName
                    if (name === "cube1" || name === "cube2" || name === "cube3") {
                        tg.attachTo(pick.objectHit)
                        return
                    }
                }

                // Otherwise: camera orbit
                rotating = true
            }
        }

        onPositionChanged: function(mouse) {
            var dx = mouse.x - lastPos.x
            var dy = mouse.y - lastPos.y

            if (tg.activeElement !== TransformGizmo.UIElement.None) {
                // ── Gizmo drag ──────────────────────────────────
                tg.handleDrag(dx, dy)

            } else if (rotating) {
                // ── Camera orbit (rotate around orbitTarget) ────
                orbitYaw -= dx * 0.3
                orbitPitch += dy * 0.3
                orbitPitch = Math.max(-89.0, Math.min(89.0, orbitPitch))
                updateCamera()

            } else if (panning) {
                // ── Camera pan (move orbitTarget + camera) ──────
                var speed = 0.005 * orbitDistance
                var r = cameraRight().times(-dx * speed)
                var u = cameraUp().times(dy * speed)
                orbitTarget = orbitTarget.plus(r).plus(u)
                updateCamera()
            }

            // Hover detection for gizmo highlighting
            if (tg.visible) {
                var gizmoPick = gizmoView.pick(mouse.x, mouse.y)
                tg.handleHover(gizmoPick)
            }

            lastPos = Qt.point(mouse.x, mouse.y)
        }

        onReleased: function(mouse) {
            if (tg.activeElement !== TransformGizmo.UIElement.None) {
                tg.handleRelease()
            }
            rotating = false
            panning = false
        }

        onWheel: function(wheel) {
            orbitDistance -= wheel.angleDelta.y * 0.01
            orbitDistance = Math.max(0.3, orbitDistance)
            updateCamera()
        }
    }
}
