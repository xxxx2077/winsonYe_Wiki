# Shell

## 什么是Shell

- Shell是一门命令语言，这意味着Shell拥有变量、函数等概念，Shell可以递归使用（即Shell命令可以混合使用。例如： ls -al ）

- Shell提供了界面，使用户能够与操作系统内核打交道，是用户与操作系统之间的桥梁/工具。

!!! tip

    业界说的Shell通常指的是Shell脚本。

    Shell编程指的是使用Shell编程，而非开发Shell。

    **平常我们所写的shell本质上就是shell脚本(shell script)，当脚本比较复杂的时候，我们将其存储在.sh文件中**

Shell的种类有很多，常见的有：

- Bourne Shell（/usr/bin/sh或/bin/sh）
- Bourne Again Shell（/bin/bash）
- C Shell（/usr/bin/csh）
- K Shell（/usr/bin/ksh）
- Shell for Root（/sbin/sh）

其中bash是Linux默认的Shell

在一般情况下，人们并不区分 Bourne Shell 和 Bourne Again Shell，所以，像 `#!/bin/sh`，它同样也可以改为 `#!/bin/bash`。

`#!` 告诉系统其后路径所指定的程序即是解释此脚本文件的 Shell 程序。

## Shell的用法

我不会非常细致的去介绍shell的各个命令，而是在此处整理一些常用的命令和概念。

如果你想简单入门，建议点击此链接[Introduction of Shell](https://missing-semester-cn.github.io/2020/course-shell/)

### 当你打开shell

```shell
missing:~$
```

打开shell你会发现出现以上样子，`missing`代表为当前用户名，`~`为当前的工作目录，`$`表示当前用户是普通用户

### 运行第一个shell程序

```shell
missing:~$ date
2025年 1月11日 星期六 17时55分33秒 CST
```

`date`是系统内置的shell程序名，输入`date`我们获取了当前的日期和时间。


```shell
missing:~$ echo "hello"
hello
```

`echo`是系统内置的shell程序名，`"hello"`是我们传给shell的参数，通过`echo`我们在终端打印了hello字符串。

!!! question

    shell如何通过程序名寻找对应的程序执行？如何知道去哪里执行该程序？

解答这个问题，我们需要引入一个概念：环境变量。

!!! info "环境变量"

    每个用户登录系统后，Linux 都会为其建立一个默认的工作环境，由一组环境变量定义，用户可以通过修改这些环境变量，来定制自己工作环境。在 Bash 中，可用 `env` 命令列出所有已定义的环境变量。通常，用户最关注的几个变量是：

    - `HOME`：用户主目录，一般情况下为 /home/用户名。

    - `LOGNAME`：登录用户名。

    - `PATH`：命令搜索路径，路径以冒号分割。当我们输入命令名时，系统会在 PATH 变量中从前往后逐个搜索对应的程序是否在目录中。

    - `PWD`：用户当前工作目录路径。

    - `SHELL`：默认 shell 的路径名。

    - `TERM`：使用的终端名。

    想要了解更多，可以点击以下链接：
    - [环境变量详解](https://chihokyo.com/post/6/)
    - [环境变量简介](https://101.lug.ustc.edu.cn/Ch06/#bash-user-variables)

当你在 shell 中执行命令时，您实际上是在执行一段 shell 可以解释执行的简短代码。如果你要求 shell 执行某个指令，但是该指令并不是 shell 所了解的编程关键字，那么它会去咨询 环境变量 $PATH。

我们前面所使用的

```shell
missing:~$ echo "hello"
hello
```
等价于

```shell
missing:~$ which echo # shell通过$PATH寻找该程序所在位置
/bin/echo # (1)
missing:~$ /bin/echo "hello" # 找到位置之后，执行程序
hello
```

1. `$PATH`打印结果为`/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin`，`$PATH`用冒号分割目录，shell发现`/bin`内有程序`echo`，于是引用该程序

当我们执行 `echo` 命令时，shell 了解到需要执行 `echo` 这个程序，随后它便会在 `$PATH` 中搜索由 `:` 所分割的一系列目录，基于名字搜索该程序。当找到该程序时便执行（假定该文件是「可执行程序」）。

确定某个程序名代表的是哪个具体的程序，可以使用 `which` 程序。我们也可以绕过 `$PATH`，通过直接指定需要执行的程序的路径来执行该程序

### 路径和目录

Linux和MacOS为类Unix系统，核心思想为“所见皆为文件”，设备也被视作一种文件。

所有文件以树状结构管理，也就是“文件树”。在这颗“文件树”中，树节点为“目录”，子节点为文件。文件树父子节点的表示关系我们使用`/`表示。

有了以上概念，我们可以得出：

- 文件树的根节点，也就是根目录，由于它没有根节点，所以在类Unix中以`/`表示。
- 目录也被当作是文件，就如同某个节点可以是A节点的子节点，也可以是B节点的父节点。

以`/usr/bin`举例

- 第一个`/`前面为空，就是表示这已经是整个文件树的根节点。
- `usr`是`bin`的父节点，也就是父目录

在Windows，没有类Unix的“所见皆为文件”思想，因此会发生分盘的操作，分为C和D盘等。在C盘内才会有类Unix的文件树结构，父子节点通过`\`表示，例如`C: \`为C盘的根目录。

这里提到的文件路径，本质上就是文件树的路径，有相对路径和绝对路径：

- 绝对路径：从文件树根节点到目标节点的全路径
- 相对路径：从文件树某个节点到目标节点的全路径

因此，类Unix系统（如MacOS和Linux）的路径使用`/`隔开，而Windos使用`\`隔开。

### 程序之间创建连接

在shell中，程序有两个流：“输入流”和“输出流”。

“流”的概念非常抽象，简单来说，流是一个接口，包含输入和输出的方法，通过流，我们能够与外部设备进行交互（无论是输入设备还是输出设备）

“流”表示的就是外部与计算机之间流通的数据。“输入流”就是输入设备数据流通到计算机，“输出流”就是计算机数据流通到输出设备。

shell的标准输入输出流都是终端，这意味着，我们可以在终端输入数据，输出的数据也会呈现在终端上。更具体地说，标准输入流的输入设备是键盘，标准输出流的输出设备是屏幕，流是终端。

重定向允许我们能够改变输入输出的方向，不再指向键盘或屏幕。

最简单的重定向是` < file `和` > file`。这两个命令可以将程序的输入输出流分别重定向到文件：
```bash
missing:~$ echo hello > hello.txt
missing:~$ cat hello.txt
hello
missing:~$ cat < hello.txt
hello
missing:~$ cat < hello.txt > hello2.txt
missing:~$ cat hello2.txt
hello
```
高级一点的重定向有：
- `>>`：可以使用 >> 来向一个文件追加内容。
- 管道（pipes）`|`：允许我们将一个程序的输出和另外一个程序的输入连接起来：

```bash
missing:~$ ls -l / | tail -n1
drwxr-xr-x 1 root  root  4096 Jun 20  2019 var
missing:~$ curl --head --silent google.com | grep --ignore-case content-length | cut --delimiter=' ' -f2
219
```

!!! info

    关于重定向，你可能会看到有`2>`等指令，这涉及到文件描述符和重定向的联系，这里提供一个链接供了解[文件描述符与重定向](https://blog.csdn.net/mocas_wang/article/details/127272407)

### 特权用户和普通用户

根用户（用户名为root）几乎不受任何限制，他可以创建、读取、更新和删除系统中的任何文件。

默认情况下，我们是普通用户。然而当我们遇到拒绝访问（permission denied）的错误时，通常是因为此时我们必须是根用户才能操作。

为此我们可以使用 `sudo` 命令。顾名思义，它的作用是让我们可以以 su（super user 或 root 的简写）的身份执行一些操作。 

!!! tip "非常容易犯的错误"

    有一件事情是我们必须作为根用户才能做的，那就是向 sysfs 文件写入内容。系统被挂载在 /sys 下，sysfs 文件则暴露了一些内核（kernel）参数。 因此，我们不需要借助任何专用的工具，就可以轻松地在运行期间配置系统内核。**注意 Windows 和 macOS 没有这个文件**

    例如，我们笔记本电脑的屏幕亮度写在 brightness 文件中，它位于

    ```bash
    /sys/class/backlight
    ```

    通过将数值写入该文件，我们可以改变屏幕的亮度。现在，蹦到您脑袋里的第一个想法可能是：

    ```bash
    $ sudo find -L /sys/class/backlight -maxdepth 2 -name '*brightness*'
    /sys/class/backlight/thinkpad_screen/brightness
    $ cd /sys/class/backlight/thinkpad_screen
    $ sudo echo 3 > brightness
    An error occurred while redirecting file 'brightness'
    open: Permission denied
    ```

    出乎意料的是，我们还是得到了一个错误信息。毕竟，我们已经使用了 sudo 命令！关于 shell，有件事我们必须要知道。`|`、`>`、和 `<` 是通过 shell 执行的，而不是被各个程序单独执行。 因此，echo 等程序并不知道 `|` 的存在，它们只知道从自己的输入输出流中进行读写。
    
    也就是说，在shell的角度，`sudo echo`和`|`是分别执行的，`sudo echo`只知道自己需要切换为root用户，然后执行`echo`，这一个过程都在标准输入输出流进行。而`|`只知道自己需要从上一个程序输出流获取数据，将其转为本程序的输入流，`|`视角里自己一直是一个普通用户。
    
    回到上面更改屏幕亮度命令执行的报错，为了能让 `sudo echo` 命令输出的亮度值写入 brightness 文件， shell (权限为当前用户) 会先尝试打开 brightness 文件，但此时操作 shell 的不是根（root）用户，所以系统拒绝了这个打开操作，提示无权限。

    明白这一点后，我们可以这样操作：

    ```bash
    $ echo 3 | sudo tee brightness
    ```

    此时打开 /sys 文件的是 tee 这个程序，并且该程序以 root 权限在运行，因此操作可以进行。 这样您就可以在 /sys 中愉快地玩耍了，例如修改系统中各种 LED 的状态（路径可能会有所不同）：

    ```bash
    $ echo 1 | sudo tee /sys/class/leds/input6::scrolllock/brightness
    ```

    关于tee用法，见[tee使用详解](#tee)

## 操作大全

写在前面，操作众多，不可能记住所有的命令。

请善用手册工具：
-  gpt工具
-  自带手册：`man` 
   它会接受一个程序名作为参数，展示这个程序的文档（用户手册）。注意，使用 q 可以退出该程序。
   ```shell
   man <command_name>
   ```
-  命令行手册工具`tldr`
    `man`虽然详细，但是有时略显冗杂。工具`tldr`能够直接给出命令的常用例子。
    ```shell
    tldr <command_name>
    ```
    需要额外下载，mac下载方式（使用homebrew）为：
    ```shell
    brew install tldr
    ```

接下来，将记录我的一些常用指令

### 目录操作

`ls` 展示指定目录下包含哪些文件

- `ls`参数：
  - `-a`展示所有文件（包括dotfile）
  - `-l`展示文件详细信息

`cd` 将工作目录切换至指定目录

- `ls`和`cd`公共参数：
  - `.` 当前工作目录
  - `..` 当前工作目录的父目录
  - `-` 上一个工作目录

`mkdir`：新建文件夹

`rmdir`：删除空目录

`rm -r`：删除目录

`pwd`：显示当前工作目录（绝对地址）

`tree`：展示树状目录结构

!!! tip "关于`ls -l`"

    在使用`ls -l`时，会出现`drwxr-xr-x`这一串信息
    ```shell
    missing:~$ ls -l
    drwxr-xr-x 1 missing  users  4096 Jun 15  2019 missing
    ```
      - 第一个字母：`d`表示该“文件”为目录，`-`表示该“文件”为文件
      - 之后的信息每三个分为一组：
        - 前三个表示**文件所有者**对当前“文件”权限。
        - 中间三个表示**用户组**对当前“文件”权限。
        - 后面三个表示**其他人**对当前“文件”权限。
      - `r`为read，`w`为write，`x`为execute，`-`表示没有这个权限。
        - 文件：
          - `read`为读取文件 
          - `write`为写入文件（对文件修改）
          - `execute`为执行文件
        - 目录
          - `read`为“是否能查看目录内的文件，是否允许查看文件列表”
          - `write`为“是否允许在目录中重命名、创建或删除文件”
          - `execute`是搜索权限，即“你是否被允许进入该目录”。如果没有搜索权限，无法对当前目录使用cd
        - 如果对文件有w权限，但是对目录没有w权限，那么不能删除这个文件

    如果要更改文件/目录的权限，使用`chmod`命令

### 文件操作

`cp`：拷贝文件

`mv`：重命名或移动文件

`touch`：创建文件

`rm`：删除文件（不支持删除目录，需要加参数`-r`支持递归删除）

`chmod`：更改文件/目录权限 [chmod使用详解](#chmod)

`cat`：打印文件内容（标准输出）

`head`：显示文件的开头部分。默认情况下，head 会显示文件的前 10 行，但可以通过选项（`-n`）自定义显示的行数。

`tail`：显示文件的结尾部分。默认情况下，tail 会显示文件的最后 10 行，也可以通过选项（`-n`）自定义显示的行数。

### 输出

`echo`：打印参数内容

`tee`：对执行其他命令打印出来的内容进行分流，一边存储到文件，一边标准输出 [tee使用详解](#tee)

## 命令解释

对于一些比较难的命令，将在此处进行简单解释

### `chmod`

`chmod` 用于修改文件或目录的权限。`chmod` 是 "change mode"（改变模式）的缩写，主要作用是设置谁可以访问特定的文件或目录以及可以执行哪些操作（如读取、写入、执行）。

**基本语法：**

```bash
chmod [选项] 权限 文件/目录
```

- **权限**：定义谁可以对文件或目录执行哪些操作。权限有三种基本类型：
  1. **r** (read)：读取权限。
  2. **w** (write)：写入权限。
  3. **x** (execute)：执行权限。
  
  权限可以分别给不同的用户类别设置：
  - **u** (user)：文件的所有者。
  - **g** (group)：文件的所属用户组。
  - **o** (others)：其他所有用户。
  - **a** (all)：所有用户（默认）。

- **文件/目录**：你要更改权限的文件或目录。

**权限表示：**

权限有两种表示方式：符号模式和数字模式。

1. 符号模式：
    符号模式使用字母表示权限和用户类别。例如：
    ```bash
    chmod u+x file.txt
    ```
    这条命令给文件 `file.txt` 的所有者（user）添加执行权限。

    一些常用的符号模式操作：
    - `+`：添加权限。
    - `-`：移除权限。
    - `=`：设置权限（覆盖现有权限）。

    举例：
    - `chmod u+x file.txt`：给文件的所有者添加执行权限。
    - `chmod go-rwx file.txt`：移除文件对组用户和其他用户的所有权限。

2. 数字模式：
    数字模式使用三位数来表示权限，每位数字代表一种用户类别（所有者、用户组、其他用户）。每个权限类型有一个对应的数字值：
    - `r` (read) = 4
    - `w` (write) = 2
    - `x` (execute) = 1

    通过将这些数字相加来设置权限。例如：
    - `chmod 755 file.txt`：给所有者赋予 `rwx`（读、写、执行）权限，给组和其他用户赋予 `rx`（读、执行）权限。
    - `7`（所有者权限，4+2+1）
    - `5`（组权限，4+1）
    - `5`（其他用户权限，4+1）

    常见的数字模式示例：
    - `chmod 777 file.txt`：所有用户都具有读、写、执行权限。
    - `chmod 644 file.txt`：所有者具有读、写权限，组和其他用户具有读权限。

**示例：**

1. **给文件所有者增加执行权限**：
   ```bash
   chmod u+x myscript.sh
   ```
2. **将文件的权限设置为所有者读写、组读、其他人只读**：
   ```bash
   chmod 644 myfile.txt
   ```
3. **给文件所有者、组用户和其他用户都赋予读写执行权限**：
   ```bash
   chmod 777 myfile.txt
   ```
### `tee`

> tee是T型管的意思，一个进，两个出

`tee` 用于将命令的标准输出同时发送到多个地方：既可以显示在终端（标准输出），也可以将其保存到一个或多个文件中。`tee` 命令就像一个“分流器”，将输入流复制并分别传递给多个目标。

**基本语法：**

```bash
command | tee [选项] 文件...
```

- `command`：要执行的命令。
- `|`：管道符，将命令的标准输出传递给 `tee`。
- `tee`：命令本身。
- `文件`：保存输出内容的目标文件。

**功能：**
`tee` 命令接收来自标准输入的数据，先显示到终端，再将数据写入指定文件中。你可以指定一个或多个文件。如果文件不存在，`tee` 会创建文件；如果文件已存在，默认会覆盖文件的内容（除非使用特定选项）。

**常用选项：**

- `-a`：追加模式。默认情况下，`tee` 会覆盖文件内容。使用 `-a` 选项时，`tee` 会将输出追加到文件末尾，而不是覆盖。
- `-i`：忽略中断信号。在某些情况下，`tee` 可能会被信号中断，使用 `-i` 选项可以让它忽略这些中断。

**示例：**

1. **将命令输出同时显示在屏幕和文件中**：
   假设你执行 `ls` 命令并希望将输出保存到 `file.txt` 文件，同时仍然在终端显示出来：
   ```bash
   ls | tee file.txt
   ```
   这条命令会列出当前目录的文件，输出会显示在屏幕上，同时被保存到 `file.txt` 中。

2. **将命令输出追加到文件中**：
   如果你希望将输出追加到文件末尾而不是覆盖文件内容，可以使用 `-a` 选项：
   ```bash
   ls | tee -a file.txt
   ```
   这条命令会将 `ls` 的输出追加到 `file.txt` 文件末尾，而不是覆盖原文件。

3. **将命令输出同时保存到多个文件**：
   你可以将输出同时保存到多个文件：
   ```bash
   ls | tee file1.txt file2.txt
   ```
   这条命令会将 `ls` 的输出同时保存到 `file1.txt` 和 `file2.txt` 文件中，同时显示在终端。

4. **忽略中断信号**：
   如果你想让 `tee` 忽略中断信号，可以使用 `-i` 选项：
   ```bash
   ls | tee -i file.txt
   ```
   如果 `ls` 命令在执行过程中接收到中断信号，`tee` 会继续处理输入，而不会被中断。

**典型用法：**

- **日志记录**：你可以使用 `tee` 来记录命令输出到日志文件，同时继续在屏幕上查看输出。比如：
  ```bash
  some_command | tee output.log
  ```
- **调试或查看中间输出**：当你调试一个脚本或命令时，可以使用 `tee` 将中间输出记录下来，以便分析。
  ```bash
  ./myscript.sh | tee debug.log
  ```

### `grep`

基本语法

```bash
grep [选项] 模式 [文件...]
```

示例

1. **在文件中查找固定字符串：**

   ```bash
   grep "hello" filename.txt
   ```

2. **递归查找目录中的所有文件：**

   ```bash
   grep -r "hello" /path/to/directory
   ```

3. **显示行号：**

   ```bash
   grep -n "hello" filename.txt
   ```

4. **忽略大小写：**

   ```bash
   grep -i "HELLO" filename.txt
   ```

5. **只输出匹配的文件名（如果有多个文件）：**

   ```bash
   grep -l "hello" file1.txt file2.txt
   ```

6. **反向匹配（显示不包含模式的行）：**

   ```bash
   grep -v "hello" filename.txt
   ```

7. **显示匹配前后的上下文行数：**

   ```bash
   grep -C 2 "hello" filename.txt  # 显示匹配行及其前后各2行
   ```

8. **结合正则表达式进行复杂匹配：**

   ```bash
   grep "he.llo\?" filename.txt  # 使用正则表达式匹配
   ```

9. **统计每个文件中匹配的行数：**

   ```bash
   grep -c "hello" filename.txt
   ```

10. **多模式匹配：**

    ```bash
    grep -e "pattern1" -e "pattern2" filename.txt  # 或者使用 egrep "pattern1|pattern2"
    ```

11. **静默模式，仅报告是否找到匹配：**

    ```bash
    grep -q "hello" filename.txt
    ```

12. **只打印匹配部分的颜色高亮：**

    ```bash
    grep --color=always "hello" filename.txt
    ```

常见选项

- `-r, --recursive`: 递归地读取所有指定目录下的文件。
- `-n, --line-number`: 在每行之前输出行号。
- `-i, --ignore-case`: 忽略大小写差异。
- `-l, --files-with-matches`: 只打印包含匹配行的文件名。
- `-L, --files-without-match`: 只打印不包含匹配行的文件名。
- `-v, --invert-match`: 反转匹配，选择不包含匹配的行。
- `-C NUM, --context=NUM`: 打印匹配行以及上下文的行数。
- `-A NUM, --after-context=NUM`: 打印匹配行之后的行数。
- `-B NUM, --before-context=NUM`: 打印匹配行之前的行数。
- `-c, --count`: 统计并打印每个文件中匹配的行数。
- `-E, --extended-regexp`: 将模式解释为扩展正则表达式（ERE）。
- `-F, --fixed-strings`: 将模式视为固定字符串而非正则表达式。
- `-w, --word-regexp`: 仅匹配整个单词。
- `-q, --quiet, --silent`: 静默模式，不输出任何信息到标准输出。

高级用法

- **与管道结合使用：** `grep` 常与其他命令通过管道组合使用，例如：

  ```bash
  cat filename.txt | grep "hello"
  ```

## Shell脚本编写

### 变量

变量赋值：`foo=bar`

访问变量：`$foo`

引用变量：Bash 中的字符串通过 `'` 和 `"` 分隔符来定义，但是它们的含义并不相同。以 `'` 定义的字符串为原义字符串，其中的变量不会被转义，而 `"` 定义的字符串会将变量值进行替换。

```bash
foo=bar
echo "$foo"
# 打印 bar
echo '$foo'
# 打印 $foo
```
### 控制结构

shell支持if,while等控制结构

Shell 的控制结构用于控制脚本的执行流程。它们可以根据条件决定是否执行某些命令，或在循环中反复执行命令。Shell 中的控制结构包括条件判断、循环结构、跳转语句等。以下是常见的 Shell 控制结构的介绍。

#### 条件判断 (`if` 语句)
`if` 语句用于根据给定条件执行不同的代码块。其基本结构如下：

```bash
if [ condition ]; then
    # 如果条件为真，执行的命令
elif [ another_condition ]; then
    # 如果第二个条件为真，执行的命令
else
    # 如果没有条件为真，执行的命令
fi
```

**例子：**

```bash
#!/bin/bash
if [ $1 -gt 10 ]; then
    echo "参数大于 10"
else
    echo "参数小于或等于 10"
fi
```

- `-gt`：大于（greater than）
- `-lt`：小于（less than）
- `-eq`：等于（equal）
- `-ne`：不等于（not equal）
- `-ge`：大于等于（greater than or equal）
- `-le`：小于等于（less than or equal）

#### `case` 语句

`case` 语句用于多个条件的匹配，类似于其他编程语言中的 `switch` 语句。

```bash
case "$variable" in
    pattern1)
        # 匹配 pattern1 执行的命令
        ;;
    pattern2)
        # 匹配 pattern2 执行的命令
        ;;
    *)
        # 默认情况
        ;;
esac
```

#### 例子：
```bash
#!/bin/bash
echo "请输入数字"
read num

case $num in
    1)
        echo "你选择了 1"
        ;;
    2)
        echo "你选择了 2"
        ;;
    *)
        echo "未知选择"
        ;;
esac
```

#### **循环结构**

##### `for` 循环
`for` 循环用于在固定范围内反复执行命令。其基本结构如下：

```bash
for variable in list; do
    # 对每个 list 中的元素执行的命令
done
```

**例子：**
```bash
#!/bin/bash
for i in 1 2 3 4 5; do
    echo "循环第 $i 次"
done
```

或者遍历文件目录：

```bash
for file in /path/to/directory/*; do
    echo "文件名: $file"
done
```

##### `for` 循环 (C 风格)
```bash
for (( i=0; i<10; i++ )); do
    echo "i 的值是: $i"
done
```

##### `while` 循环
`while` 循环在条件为真时反复执行命令。

```bash
while [ condition ]; do
    # 条件为真时执行的命令
done
```

**例子：**
```bash
#!/bin/bash
count=1
while [ $count -le 5 ]; do
    echo "这是第 $count 次循环"
    ((count++))
done
```

##### `until` 循环
`until` 循环与 `while` 循环相似，但是它在条件为假时执行。

```bash
until [ condition ]; do
    # 条件为假时执行的命令
done
```

**例子：**
```bash
#!/bin/bash
count=1
until [ $count -gt 5 ]; do
    echo "这是第 $count 次循环"
    ((count++))
done
```

#### 跳转控制 (`break` 和 `continue`)

- `break`：跳出当前的循环，停止执行。
- `continue`：跳过当前循环的剩余部分，直接进入下一次循环。

**`break` 示例：**
```bash
#!/bin/bash
for i in 1 2 3 4 5; do
    if [ $i -eq 3 ]; then
        break  # 跳出循环
    fi
    echo "第 $i 次循环"
done
```

**`continue` 示例：**
```bash
#!/bin/bash
for i in 1 2 3 4 5; do
    if [ $i -eq 3 ]; then
        continue  # 跳过当前循环
    fi
    echo "第 $i 次循环"
done
```

#### **逻辑运算符**
- `&&`：逻辑与（AND）。前一个命令成功时，才会执行下一个命令。
- `||`：逻辑或（OR）。前一个命令失败时，才会执行下一个命令。

**例子：**
```bash
#!/bin/bash
# 使用 &&，只有第一个命令成功，第二个才会执行
echo "开始测试" && echo "测试成功"

# 使用 ||，只有第一个命令失败，第二个才会执行
echo "开始测试" || echo "测试失败"
```

#### `exit` 语句
`exit` 语句用于退出脚本并返回一个状态码。状态码 `0` 通常表示成功，非 `0` 状态码表示错误。

```bash
exit 0  # 正常退出，状态码为 0
exit 1  # 异常退出，状态码为 1
```

**例子：**
```bash
#!/bin/bash
if [ $1 -lt 10 ]; then
    echo "输入参数小于 10"
    exit 1
fi
echo "输入参数大于或等于 10"
```

##### `test` 命令 / `[ ]` 
`test` 命令用于评估条件表达式，例如文件测试、字符串比较、数值比较等。

```bash
if test -f "file.txt"; then
    echo "file.txt 存在"
fi
```

等价于：

```bash
if [ -f "file.txt" ]; then
    echo "file.txt 存在"
fi
```

常见测试选项：
- `-f`：检查文件是否存在且是普通文件。
- `-d`：检查目录是否存在。
- `-e`：检查文件是否存在。
- `-z`：检查字符串是否为空。
- `-n`：检查字符串是否非空。

### 函数

shell也支持函数

