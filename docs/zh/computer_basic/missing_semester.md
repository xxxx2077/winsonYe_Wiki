# Before Coding

本章节源自MIT课程Missing  semester，该课程介绍了很多提高编程效率的工具（例如Vim）

在课程的基础上，我添加了一些我认为很重要的工具

我认为这些工具是程序员必备知识（比编程语言还重要），因此将本章节取名为Before Coding

## shell

环境变量：运行shell前设定好的变量

$PATH是路径变量

> 路径是计算机描述文件的方式

查看$PATH的方式：

```shell
echo $PATH
```

路径以冒号隔开

打印当前路径

```shell
pwd
```

绝对路径：完整的文件路径，从根路径/开始

相对路径：相对于当前工作目录而言的路径

> Windows中，首先是分区，分为C盘和D盘等，然后每个分区拥有一个根路径
>
> 因此有 C: / 和 D: /
>
> Linux和MacOS中，一切均从根路径/开始



更改工作目录cd (change directory)

.表示当前目录

..表示父目录

~表示主目录 (home directory)

`cd -` 回到上次工作目录

运行程序：从$PATH记录的目录中遍历找到对应名字的程序

`which [程序名]可获得程序的路径` 

```shell
which echo
```

要么给定程序名称，让shell从$PATH中检索

要么给出绝对路径



查看当前目录所有文件ls

d表示目录

之后的字母表示该文件设置的权限

- 第一组前三个字母为文件所有者设置的权限
- 第二组三个字母为拥有该文件的组设置的权限
- 最后一组三个字母为不是文件或目录所有者或组所有者的人的权限

r为read，w为write，x为execute，-表示没有这个权限

文件和目录对于这三个权限的解释不同

- 文件：read为读取文件，write为写入文件（对文件修改），execute为执行文件
- 目录：read为“是否能查看目录内的文件，是否允许查看文件列表”，write为“是否允许在目录中重命名、创建或删除文件”，execute是搜索权限，“你是否被允许进入该目录”，如果没有搜索权限，无法对当前目录使用cd
  - 如果对文件有w权限，但是对目录没有w权限，那么不能删除这个文件

![image-20241219160808987](/Users/t/Desktop/xxxx2077.github.io/docs/computer_basic/missing_semester.assets/image-20241219160808987.png)



mv可以用于移动文件或重命名文件

mv [oldpath] [newpath]

```
mv oldname.md newname.md
```



cp可以用于复制文件

cp [srcpath] [dstpath]

srapath和dstpath都需要是完整路径（相对或绝对路径都可以）



rm可以用于删除文件

rm [filepath]

Linux默认不允许递归删除

```shell
rmdir 删除空目录
rm -r 递归删除（可用于删除目录）
rm -f 强制删除
```



mkdir创建一个新目录

创建多个目录

```
mkdir "My photo"
```



操作手册

man [program name]



Ctrl + L 清除终端并回到顶部

 

shell拥有输入流和输出流

输入流默认为键盘，输出流默认为shell

通过重定向可以改变输入输出方向

```shell
 echo hello > hello.txt #将输出流方向更改为文件hello.txt
```



cat打印文件内容

```
cat < hello.txt
```

支持输入和输出连在一起，实现cp的功能

```
cat < hello.txt > hello2.txt
```

`>>`表示追加

```
cat < hello.txt >> hello2.txt
```



tail打印文件最后几行

```
tail -n [linenumber]
```

管道符 | 

将管道左边的输出作为管道右边的输入

```
ls -l | tail -n 1
```



tee

T型管的意思，一个进，两个出

tee命令能够将输入写入文件，同时将其输出到屏幕



find

在当前目录寻找名字对应的文件



xdg=open

Open



chmod 更改文件模式或访问控制列表

```
chmod [-fhv] [-R [-H | -L | -P]] mode file ...

mode         ::= clause [, clause ...]
clause       ::= [who ...] [action ...] action
action       ::= op [perm ...]
who          ::= a | u | g | o
op           ::= + | - | =
perm         ::= r | s | t | w | x | X | u | g | o
```



grep

基本语法

```
grep [选项] 模式 [文件...]
```

示例

1. **在文件中查找固定字符串：**

   ```
   grep "hello" filename.txt
   ```

2. **递归查找目录中的所有文件：**

   ```
   grep -r "hello" /path/to/directory
   ```

3. **显示行号：**

   ```
   grep -n "hello" filename.txt
   ```

4. **忽略大小写：**

   ```
   grep -i "HELLO" filename.txt
   ```

5. **只输出匹配的文件名（如果有多个文件）：**

   ```
   grep -l "hello" file1.txt file2.txt
   ```

6. **反向匹配（显示不包含模式的行）：**

   ```
   grep -v "hello" filename.txt
   ```

7. **显示匹配前后的上下文行数：**

   ```
   grep -C 2 "hello" filename.txt  # 显示匹配行及其前后各2行
   ```

8. **结合正则表达式进行复杂匹配：**

   ```
   grep "he.llo\?" filename.txt  # 使用正则表达式匹配
   ```

9. **统计每个文件中匹配的行数：**

   ```
   grep -c "hello" filename.txt
   ```

10. **多模式匹配：**

    ```
    grep -e "pattern1" -e "pattern2" filename.txt  # 或者使用 egrep "pattern1|pattern2"
    ```

11. **静默模式，仅报告是否找到匹配：**

    ```
    grep -q "hello" filename.txt
    ```

12. **只打印匹配部分的颜色高亮：**

    ```
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

  ```
  cat filename.txt | grep "hello"
  ```



root用户

超级用户，可以做任何事情

`sudo`指令赋予root权限



shell对空格非常敏感，空格用于隔开参数

有时候，参数会含有空格，为了完整表述参数含义，可以使用字符串 



字符串

双引号字符串包含替换字符

单引号字符串为原生字符串

例如

![image-20241224115910952](/Users/t/Desktop/xxxx2077.github.io/docs/computer_basic/missing_semester.assets/image-20241224115910952.png)

得到不同结果



source命令

`source` 命令用于读取并执行当前 Shell 环境中的指定文件中的命令，就像你在命令行中逐个输入这些命令一样。

当你使用 `source` 命令时，它会将文件中的所有命令在当前的 shell 会话环境中执行。这意味着如果文件中包含修改环境变量（例如 PATH）、定义别名或函数等命令，那么这些改变将会立即影响到当前的 shell 会话。

使用方法如下：

```bash
source 文件名
```

或者你也可以使用点号 (`.`) 来代替 `source`，效果是一样的：

```bash
. 文件名
```

举个例子，如果你有一个名为 `myenvsetup.sh` 的脚本文件，里面包含设置一些环境变量的命令，你可以通过以下命令来应用这些设置：

```bash
source myenvsetup.sh
```

或者

```bash
. myenvsetup.sh
```

这通常被用来在不退出当前 shell 的情况下应用新的配置，比如更新 `.bashrc` 或 `.bash_profile` 文件后，就可以用 `source` 命令让新的设置生效。



`diff` 命令是 Unix、Linux 和 macOS 等操作系统中用于比较文件差异的工具。它可以逐行比较文本文件，并指出它们之间的不同之处。`diff` 也可以用来比较两个目录，显示哪些文件在两个目录之间存在差异。

以下是 `diff` 命令的一些基本用法和选项：

**比较两个文件**

```bash
diff 文件1 文件2
```

这将输出文件1和文件2之间的区别。如果没有任何输出，说明两个文件相同。

**使用上下文格式（context format）**

```bash
diff -C 行数 文件1 文件2
```

这里 `-C` 后面跟的是上下文的行数，它会显示指定数量的上下文，帮助理解差异所在。

**统一差异格式（unified format）**

```bash
diff -U 行数 文件1 文件2
```

与 `-C` 类似，但使用更紧凑的统一格式来显示差异。

**忽略空白符差异**

```bash
diff -w 文件1 文件2
```

忽略所有空白字符的不同，包括空格和制表符。

**忽略大小写**

```bash
diff -i 文件1 文件2
```

忽略大小写的区别。

**递归比较目录**

```bash
diff -r 目录1 目录2
```

递归地比较两个目录下的所有文件。

**只报告是否不同**

```bash
diff -q 文件1 文件2
```

只报告文件是否不同，不显示具体差异。

**输出到文件**

```bash
diff 文件1 文件2 > 差异文件
```

将差异结果重定向到一个文件中。

**使用 `patch` 应用差异**

当使用 `-u` 或 `-c` 生成补丁时，可以使用 `patch` 命令来应用这些补丁。

```bash
patch < 补丁文件
```

以上只是 `diff` 的一些基础用法。`diff` 还有许多其他选项，可以通过查阅手册页 (`man diff`) 来获取更多详细信息。

### shell脚本

第一行表示执行这段程序的编译期/解释器所在位置

**Shebang 行**：`env python` 经常出现在 Python 脚本的第一行，也就是所谓的 Shebang 行（#!），用于告诉操作系统该用什么解释器来执行这个脚本。例如：

```python
#!/usr/bin/env python3
print("Hello, world!")
```

这样做可以让脚本适应不同的系统配置，并且可以确保使用的是用户环境中的正确 Python 版本。



$0指代脚本名称

\$1到\$9指代bash脚本接收的第二到第九个参数

\$?获取上个指令的错误代码

\$_获取上个指令的最后一个参数

!!可以替换为上一次的命令

```shell
mkdir /mnt/new #没有权限
sudo ！！ #等价于sudo mkdir /mnt/new
```



将一个命令的输出存储到一个变量中

![image-20241228152048650](/Users/t/Desktop/xxxx2077.github.io/docs/computer_basic/missing_semester.assets/image-20241228152048650.png)

<(command)

将命令结果输出到临时文件

![image-20241228200027669](/Users/t/Desktop/xxxx2077.github.io/docs/computer_basic/missing_semester.assets/image-20241228200027669.png)



```shell
#!/bin/bash

echo "Starting program at $(date)"

echo "Running program at $0 with $# arguments with pid $$"

for file in "$@"; do
  grep foobar "$file" > /dev/null 2> /dev/null

  if [[ "$?" -ne 0 ]]; then
    echo "File $file does not have any foobar, adding one"
    echo "# foobar" >> "$file"
  fi
done
```



*表示任意且若干个字符

?表示任意一个字符

{}表示共有前缀

![image-20241228200950520](/Users/t/Desktop/xxxx2077.github.io/docs/computer_basic/missing_semester.assets/image-20241228200950520.png)

多个{}产生笛卡尔积

![image-20241228200828557](/Users/t/Desktop/xxxx2077.github.io/docs/computer_basic/missing_semester.assets/image-20241228200828557.png)



寻找文件

如果知道文件夹/文件名， find

替代命令fd

locate通过建立索引，使用索引查找文件



grep -R "string" directionally

rg

如何找到你使用过的命令

- 向上键
- history
  - history 1
- ctrl + R 反向搜索
- fzf：fuzzing finder



历史子字符串提示：动态地前缀搜索历史命令行记录

### 工具

Tldr

fzf

历史子字符串提示：动态地前缀搜索历史命令行记录



ls -R 递归列出目录

tree打印目录



## Vim

Vim拥有不同操作模式，不同操作模式应对不同场景





### normal



### insert

### 高阶使用

#### 在同一文件中替换

如果你只想在当前文件中进行替换，可以使用以下命令：

```shell
:%s/this->start/start/g
```

- `%` 表示对整个文件的所有行进行操作。
- `s` 是替换命令。
- `/this->start/start/` 指定了要查找的文本 (`this->start`) 和要替换成的文本 (`start`)。
- `g` 标志表示全局替换（即替换每一行中的所有匹配项）。

如果你想逐个确认每个替换，可以添加 `c` 标志：

```shell
:%s/this->start/start/gc
```

这将在每次替换前提示你确认。

#### 交换上下两行

使用 `:move` 命令

**交换当前行与下一行**

1. **进入 Normal 模式**：按 `Esc` 确保你在 Normal 模式下。

2. **将光标放在要移动的行上**：确保光标位于你想交换的那一行。

3. **输入 `:move` 命令**：

   - 对于交换当前行与下一行，你可以使用以下命令：

     vim

     深色版本

     

     ```
     :.+1m-1<Enter>
     ```

   解释：

   - `.` 表示当前行。
   - `+1` 表示相对于当前行的下一行。
   - `m` 是 `move` 命令。
   - `-1` 表示目标位置为当前行的前一行（即上一行）。

   这个命令的意思是将当前行（`.`）移动到下一行（`+1`）的位置，即交换当前行和下一行。

4. **执行命令**：按 `Enter` 键执行命令，Vim 将交换这两行。

## 数据整理

less是分页器

sed流编辑器

正则表达式

正则表达式调试器

通常正则表达式只会匹配一行





命令wc

awk



shell命令末尾加&表示程序在后台运行

nohup 忽视hangup

bg

fg



Jobs

终端复用器tmux

tee

scp ssh复制

rsync

config为配置文件

## Git



## Markdown  
