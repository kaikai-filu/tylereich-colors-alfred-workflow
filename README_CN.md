# Colors — Alfred 工作流

> **原始项目：** [Tyler Eich / Alfred-Extras](https://github.com/TylerEich/Alfred-Extras)  
> **版权：** © 2013 Tyler Eich. 保留所有权利。  
> **修改：** [kaikai-filu](https://github.com/kaikai-filu) 使用 [Claude Code CLI](https://claude.com/claude-code)（基于 DeepSeek-V4）进行跨架构（Intel + Apple Silicon）适配与修复。

---

## 简介

这是一个面向开发者的 [Alfred](https://www.alfredapp.com/) 颜色转换工作流。支持 hex、RGB、HSL、NSColor、UIColor、Swift Color 及 148 种 CSS 命名颜色之间的相互转换，全部在 Alfred 内完成。

原始工作流由 **Tyler Eich** 于 2013 年创建（当时 Apple Silicon 尚未诞生），其中的二进制文件仅支持 x86_64 架构，在 Apple M 系列芯片的 Mac 上会出现 `Bad CPU type in executable` 错误。本项目将二进制文件重新编译为 **universal（x86_64 + arm64）** 格式，修复了在现代编译过程中发现的若干 bug，并使项目可从源码构建。

## 关键词

| 关键词    | 输入格式               | 示例                                              |
|-----------|------------------------|---------------------------------------------------|
| `#`       | 十六进制颜色            | `#ff0000`                                         |
| `rgb`     | CSS RGB               | `rgb(255, 0, 0)`                                  |
| `hsl`     | CSS HSL               | `hsl(180, 100%, 50%)`                              |
| `c`       | CSS 命名颜色            | `c red`                                           |
| `[ns`     | NSColor（Objective-C） | `[ns colorWithRed:1 green:0 blue:0 alpha:1]`      |
| `[ui`     | UIColor（Objective-C） | `[ui colorWithRed:1 green:0 blue:0 alpha:1]`      |
| `NSColor` | NSColor（Swift）       | `NSColor(calibratedRed:1, green:0, blue:0, alpha:1)` |
| `UIColor` | UIColor（Swift）       | `UIColor(red:1, green:0, blue:0, alpha:1)`        |

### 输出格式

CSS Hex、CSS RGBA、CSS RGB%、CSS HSLA、CSS 命名颜色、32-Bit Hex、NSColor（calibrated/device RGB、HSB、White）、UIColor（RGB、HSB、White）、Swift NSColor、Swift UIColor。

### 修饰键

| 按键      | 功能                     |
|-----------|--------------------------|
| ⌥ Option  | 切换 alpha 通道后复制      |
| ⌘ Command | 在 macOS 颜色面板中打开     |

## 相对原始版本的修改

原始工作流（v2.0.0）于 2013 年构建，仅支持 Intel Mac。本版本：

- **将两个二进制文件**（`colors` 和 `Colors.app`）重新编译为 **universal Mach-O**（x86_64 + arm64）
- **修复了 4 个 bug**（在现代编译过程中发现）：

  1. **缺少 ObjC 内存属性** — `AWFeedbackItem.h` 中的 `@property` 声明缺少 `(copy)`/`(strong)`，默认采用了不安全的 `assign`，导致野指针崩溃。
  2. **未初始化的变量** — `AWFeedbackItem.m:125` 中的 `NSString *av` 未初始化为 nil，导致 XML 生成时解引用随机指针。
  3. **缺少内存属性** — `AWWorkflow.h` 和 `AWPreferences.h` 存在同样的问题（同 #1）。
  4. **nil 格式崩溃** — `colors.m` 中的 `preferredFormatForKey:` 未对非 `ns` 键的 nil `format` 做防护。

- **新增 `build.sh`**：支持从源码可复现编译
- **最低部署目标**：macOS 10.13

## 构建

```bash
./build.sh
```

需要 Xcode Command Line Tools。生成 `Colors.alfredworkflow`。

## 项目结构

```
Colors/
├── Colors.alfredworkflow   ← 最终工作流包
├── build.sh                ← 构建脚本
├── README.md
├── README_CN.md
└── src/
    ├── colors/
    │   ├── Alfred/         ← Alfred 框架（8 个头文件 + 8 个实现文件）
    │   └── colors/         ← colors 命令行工具（colors.h、colors.m、main.m）
    └── ColorsApp/          ← macOS 取色器应用（5 个文件）
```

## 致谢与贡献者

| 角色                     | 姓名             | 联系方式                                                   |
|--------------------------|------------------|------------------------------------------------------------|
| **原作者**               | **Tyler Eich**   | [GitHub](https://github.com/TylerEich) · eichtyler@gmail.com |
| **修改与维护**           | **kaikai-filu**  | [GitHub](https://github.com/kaikai-filu)                    |
| **AI 辅助开发**          | **Claude Code**（Anthropic） | 基于 DeepSeek-V4                                             |

本项目未经原作者背书或关联。原始源码见 [TylerEich/Alfred-Extras](https://github.com/TylerEich/Alfred-Extras)。

## 许可证

详见原始仓库的许可证信息。
