# QtQuick3D Transform Gizmo

## 简介

本项目是一个基于 Qt Quick 3D 的 3D 变换控制器（Transform Gizmo），用于在 3D 场景中交互式地操作物体的位置、旋转和缩放。它提供了类似主流 3D 编辑软件（如 Blender、Unity 等）中的 Gizmo 控件，支持：

- **平移模式**：沿 X/Y/Z 轴或在 XY/XZ/YZ 平面上移动物体
- **旋转模式**：绕 X/Y/Z 轴旋转物体
- **缩放模式**：沿 X/Y/Z 轴缩放物体

## 原作者与来源

本项目基于 GitHub 仓库 [fferri/qt3d-transform-gizmo](https://github.com/fferri/qt3d-transform-gizmo) 改写，从 Qt3D 移植到 Qt Quick 3D。

原作者：
- **Federico Ferri** ([fferri](https://github.com/fferri))
- **Justin Weber** ([onlyjus](https://github.com/onlyjus))

## 构建 (CMake)

### 前置要求

- Qt 6.x（需要 Qt Quick 3D 模块）
- CMake 3.16+
- C++17 编译器

### 构建步骤

```shell
cmake -B build -S .
cmake --build build
./build/qtquick3d-transform-gizmo
```

> 注意：可能需要根据本地 Qt 安装路径修改 `CMakeLists.txt` 中的 `CMAKE_PREFIX_PATH`。

## 操作说明

| 操作 | 功能 |
|------|------|
| 左键点击方块 | 挂载 Gizmo 到该物体 |
| 右键 | 卸载 Gizmo |
| 左键拖拽 Gizmo 轴/面 | 平移 / 旋转 / 缩放物体 |
| 点击 Gizmo 中心球 | 切换模式（平移 → 旋转 → 缩放） |
| 左键拖拽空白处 | 旋转相机 |
| 右键拖拽空白处 | 平移相机 |
| 滚轮 | 缩放相机 |

## 版权声明

本项目继承原项目的许可证，采用 **GNU General Public License v3.0 (GPLv3)** 许可证。

详见 [LICENSE](./LICENSE) 文件。

```
Copyright (C) 2020 Federico Ferri

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
```