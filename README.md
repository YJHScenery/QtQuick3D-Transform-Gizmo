# QtQuick3D Transform Gizmo

QtQuick3D 重写版本的 3D Transform Gizmo — 交互式（鼠标）平移和旋转 3D 场景物体。

原始 Qt3D 版本作者：Federico Ferri (2020)
QtQuick3D 移植版。

![screenshot](screenshot.png)

## 与原版差异

| 方面 | Qt3D 原版 | QtQuick3D 新版 |
|------|----------|---------------|
| 3D 引擎 | Qt3D (ECS) | QtQuick3D (继承式) |
| 拾取 | ObjectPicker | View3D.pick() |
| 相机控制 | 自定义 SOrbitCameraController | MouseArea 统一处理 |
| 材质 | PhongMaterial | PrincipledMaterial (PBR) |
| 渲染管线 | 手动 FrameGraph | 自动 (SceneEnvironment) |

## 构建 (CMake)

```shell
cmake -B build -S .
cmake --build build
./build/qtquick3d-transform-gizmo
```

## 运行 (Python)

```shell
pip install pyside6
python main.py
```

## 操作

- **左键点击方块**：挂载 Gizmo
- **右键**：卸载 Gizmo
- **左键拖拽 Gizmo 轴/面**：平移 / 旋转 / 缩放
- **点击 Gizmo 中心球**：切换模式（平移 ⇄ 旋转 ⇄ 缩放）
- **左键拖拽空白处**：旋转相机
- **右键拖拽空白处**：平移相机
- **滚轮**：缩放
