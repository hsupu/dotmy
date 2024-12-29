
## natvis

官方文档：

- https://devblogs.microsoft.com/visualstudio/customize-object-displays-in-the-visual-studio-debugger-your-way/
- https://learn.microsoft.com/en-us/visualstudio/debugger/create-custom-views-of-native-objects?view=vs-2022

可参考的模板：

- C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Packages\Debugger\Visualizers
- https://github.com/microsoft/STL/blob/main/stl/debugger/STL.natvis
- https://github.com/KindDragon/CPPDebuggerVisualizers/blob/master/VS2019/Visualizers/boost.natvis

### 重新加载 natvis

在 Immediate Window 里输入：

```
.natvisreload
```
