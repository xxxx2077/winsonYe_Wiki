# WebAssembly

## 什么是WebAssembly

**WebAssembly（缩写wasm）是能够运行在浏览器的「中间形式」**

浏览器引擎实现了 WebAssembly 虚拟机，这使得用户能够与 JavaScript 一起运行 wasm 代码。

> 我：WebAssembly不是编程语言，它是一种中间格式，叫字节码，可以作为其他语言的编译目标。
>
> 《精通Rust》：WebAssembly 是一套技术和规范，它允许用户将原生代码编译为名为 wasm 的低级语 言在 Web 上运行。从可用性的角度来看，它是一组技术，允许你使用其他非 Web 编程语言 编写的程序在 Web 浏览器上运行。从技术的角度来看，WebAssembly 是一种虚拟机规范， 具有二进制、加载期效率指令集架构(Instruction Set Architecture，ISA)。

通过高级语言C/Rust编写之后的代码，可以编译为wasm进入浏览器，从而使其能够在我们的CPU上以接近原生的速度运行

**WebAssembly不能替代 Javascript**，相反，这两种技术是**相辅相成的**。

通过 JavaScript API，你可以将 WebAssembly模块加载到你的页面中。也就是说，你可以通过 WebAssembly来充分利用编译代码的性能，同时保持 JavaScript 的灵活性。

> 由于 JavaScript高度抽象性，在浏览器上运行 JavaScript的性能并不是很理想， WebAssembly的出现使其能够优化 JavaScript的性能（具体来说，就是通过用 WebAssembly编写某些模块，提高程序的性能）

