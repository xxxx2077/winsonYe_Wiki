# 浏览器使用指南

## 开发者工具

!!! quote

    [开发者工具入门（上）](https://www.cnblogs.com/laixiangran/p/8777579.html)

    [开发者工具入门（下）](https://www.cnblogs.com/laixiangran/p/8834462.html)

    [开发者工具（官方文档）](https://developer.chrome.com/docs/devtools/overview?hl=zh-cn)

以上文档介绍了开发者工具的基本功能，以下是简单介绍：

### **1. Elements (元素) 面板**

*   **核心功能：** **查看、编辑和实时调试网页的 HTML 和 CSS。**
*   **主要用途：**
    *   **DOM 查看器：** 以树状结构显示当前页面的完整 HTML 结构（Document Object Model）。
    *   **实时编辑 HTML：** 双击 HTML 元素可以直接修改其标签、属性或文本内容，修改会立即在页面上生效（刷新后消失）。这对于快速测试布局或内容修改非常有用。
    *   **实时编辑 CSS：** 在右侧的“Styles”（样式）窗格中，可以查看应用到选中元素的所有 CSS 规则。你可以：
        *   修改现有 CSS 属性的值（如颜色、字体大小、边距）。
        *   添加新的 CSS 属性。
        *   启用/禁用某个 CSS 规则。
        *   查看 CSS 盒模型（Box Model）的可视化表示（`margin`, `border`, `padding`, `content`）。
    *   **元素选择：** 使用左上角的箭头图标（或 `Ctrl+Shift+C` / `Cmd+Shift+C`）可以在页面上直接点击选择元素，工具会自动定位到 Elements 面板中的对应 HTML 节点。
    *   **调试布局：** 检查元素的尺寸、位置、浮动、Flexbox/Grid 布局等是否符合预期。

### **2. Console (控制台) 面板**

*   **核心功能：** **查看 JavaScript 错误、日志信息，并与页面的 JavaScript 环境进行交互。**
*   **主要用途：**
    *   **错误和警告：** 显示 JavaScript 运行时错误（红色）、警告（黄色）、信息（蓝色）和调试信息（灰色）。这是定位代码问题的第一站。
    *   **日志输出：** 显示 `console.log()`, `console.error()`, `console.warn()`, `console.info()` 等函数的输出。
    *   **JavaScript 执行环境：** 一个交互式的 JavaScript 控制台。你可以：
        *   直接输入并执行 JavaScript 代码（例如，`document.title = "New Title"`）。
        *   调用页面上定义的函数。
        *   检查变量和对象的值。
        *   测试代码片段。
    *   **断点信息：** 当在 Sources 面板设置了断点并暂停执行时，Console 会显示当前的调用栈和变量信息。
    *   **过滤信息：** 可以按错误、警告、日志、调试信息等类型过滤输出。

### **3. Sources (源代码) 面板**

*   **核心功能：** **查看、调试和分析网页加载的 JavaScript、CSS、HTML 源代码，以及进行性能分析。**
*   **主要用途：**
    *   **源码查看：** 显示页面加载的所有资源文件（JS, CSS, HTML, 图片等）的树形结构。
    *   **JavaScript 调试：**
        *   **设置断点 (Breakpoints)：** 在代码行号上点击可以设置断点。当代码执行到断点时会暂停。
        *   **单步执行：** 暂停后，可以使用“单步跳过 (Step over)”、“单步进入 (Step into)”、“单步跳出 (Step out)”、“继续 (Resume)”等按钮控制代码执行。
        *   **查看调用栈 (Call Stack)：** 显示当前函数的调用路径。
        *   **查看作用域变量 (Scope)：** 显示当前执行上下文中的局部变量、闭包变量和全局变量。
        *   **监视表达式 (Watch)：** 可以添加需要持续监视的变量或表达式。
    *   **代码格式化：** 对压缩过的代码（minified）可以点击 `{}` 按钮进行格式化，便于阅读。
    *   **文件编辑与保存：** 可以直接在面板中编辑源代码（临时修改，刷新后消失），或保存到本地进行持久化修改（需配置 Workspaces）。
    *   **Snippets (代码片段)：** 可以创建、保存和运行小段 JavaScript 代码。
    *   **本地 Overrides (本地覆盖)：** 允许你将对源代码的修改保存到本地磁盘，并在每次访问页面时自动应用这些修改，非常方便调试。

### **4. Network (网络) 面板**

*   **核心功能：** **监控和分析网页加载过程中所有的网络请求和响应。**
*   **主要用途：**
    *   **请求列表：** 显示页面加载或用户操作期间发出的所有网络请求（HTML, CSS, JS, 图片, API 调用, 字体, WebSocket 等）。
    *   **性能分析：**
        *   **时间线 (Timeline)：** 显示每个请求的生命周期（从发起、DNS 查询、建立连接、发送请求、等待响应、接收数据到完成）的详细时间。
        *   **瀑布图 (Waterfall)：** 直观地展示请求的发起顺序和并行情况。
    *   **请求详情：** 点击一个请求，可以查看其详细信息：
        *   **Headers:** 请求头和响应头（如 `User-Agent`, `Content-Type`, `Status Code`, `Set-Cookie`）。
        *   **Preview:** 响应内容的预览（如 JSON 格式化显示、图片预览）。
        *   **Response:** 响应的原始内容（HTML, JSON, 文本等）。
        *   **Timing:** 请求各个阶段的精确耗时。
        *   **Cookies:** 请求和响应中包含的 Cookie。
    *   **性能优化：** 识别加载慢的资源、过大的文件、过多的请求、未压缩的资源等性能瓶颈。
    *   **调试 API：** 检查 AJAX/fetch 请求的 URL、参数、请求头、响应数据和状态码，是调试前后端交互的关键工具。
    *   **模拟网络环境：** 可以模拟慢速网络（如 3G）、离线状态，测试页面在不同网络条件下的表现。
    *   **过滤请求：** 可以按类型（XHR, JS, CSS, Img, Media, Font, Doc, WS 等）或关键词过滤请求。

### **5. Application (应用) 面板**

*   **核心功能：** **查看和管理网页使用的存储（Storage）、缓存、Service Workers 等客户端数据。**
*   **主要用途：**
    *   **Storage (存储)：**
        *   **Local Storage:** 查看、编辑、删除 `localStorage` 中存储的键值对。
        *   **Session Storage:** 查看、编辑、删除 `sessionStorage` 中存储的键值对。
        *   **Cookies:** 查看当前域名下的所有 Cookie，包括名称、值、域、路径、过期时间、安全标志等。可以编辑或删除。
        *   **IndexedDB:** 查看和浏览 IndexedDB 数据库及其对象仓库（Object Stores）中的数据。
        *   **Web SQL:** 查看 Web SQL 数据库（已废弃，但旧项目可能还在用）。
    *   **Cache Storage:** 查看由 Service Worker 缓存的资源。
    *   **Service Workers:** 查看已注册的 Service Worker 状态（是否激活、是否在运行），可以进行停止、卸载、更新等操作。
    *   **Manifest:** 如果网页是 PWA（渐进式 Web 应用），可以查看其 Web App Manifest 文件（定义应用名称、图标、启动方式等）。
    *   **Clear Storage:** 一键清除当前站点的所有存储数据（用于重置应用状态或测试）。

### **6. 其他重要面板**

*   **Performance (性能) 面板：** 记录和分析页面在一段时间内的性能表现，包括 CPU 占用、渲染帧率（FPS）、内存使用、JavaScript 执行、布局重排（Layout）、重绘（Paint）等。用于深度性能优化。
*   **Memory (内存) 面板：** 专门用于分析 JavaScript 内存使用情况，检测内存泄漏（Memory Leak）。可以进行堆快照（Heap Snapshot）分析。
*   **Lighthouse (灯塔) 面板：** 运行一个自动化审计工具，对网页的**性能、可访问性、最佳实践、SEO 和 PWA** 进行评分，并提供详细的优化建议报告。
*   **Security (安全) 面板：** 检查页面的安全性，包括 HTTPS 配置、证书有效性、混合内容（Mixed Content）警告、安全策略（CSP）等。
*   **Application Cache (应用缓存)：** （已废弃）用于管理旧的 Application Cache API。
