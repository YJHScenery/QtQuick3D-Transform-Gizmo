#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# qt3d-transform-gizmo
# Copyright (C) 2020  Federico Ferri
#
# Adapted to QtQuick3D / PySide6.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import os, sys
from PySide6.QtCore import Qt
from PySide6.QtGui import QSurfaceFormat
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication


def main():
    # ── CRITICAL: SurfaceFormat MUST be set before QApplication ──
    fmt = QSurfaceFormat()
    fmt.setDepthBufferSize(24)
    fmt.setStencilBufferSize(8)
    QSurfaceFormat.setDefaultFormat(fmt)

    app = QApplication(sys.argv)

    engine = QQmlApplicationEngine()
    engine.load("main.qml")

    if not engine.rootObjects():
        print("Failed to load QML")
        sys.exit(1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
