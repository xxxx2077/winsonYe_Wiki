# Git

本章节将介绍Git。

以本人的学习经验而言，如果不懂Git的原理而直接使用Git，Git就像老爹的魔法咒语，有时会在关键时候出差错。

而Git的使用我认为是程序员最应该掌握的技能，因此，与一些简单的Git使用教程不同，本章节试图讲清楚Git。

本章参考链接：

- [MIT Missing semester - Git](https://missing-semester-cn.github.io/2020/version-control/)
- [深入浅出Git系列](#shenruqianchu)
- [廖雪峰 - Git](https://liaoxuefeng.com/books/git/introduction/index.html)
- [菜鸟教程 - Git](https://www.runoob.com/git/git-tutorial.html)

## Git是什么

用官网的话来说，**Git是分布式版本控制系统** 

### 什么是版本控制？

版本控制，就是针对一个或若干个文件的变化，对其以版本的形式进行记录。

有个形象的说法就是“快照”（snapshot），也就是，当我们对一个或若干个文件做了更改后，在某个时刻，我们觉得需要记录当前的内容，因此给整个系统拍了一张“照片”，该“照片”不仅记录了当前文件的内容，而且记录了拍摄人、日期时间等信息。以后我们还会有无数次更改，拍无数张照片，以记录不同的时刻该系统的状态。当我们想回到过去的某个状态，我们找到那个时刻对应的状态，就可以回到过去。

**版本控制系统分为三种：**

（正常我们都说两种，指集中式和分布式）

- 本地版本控制
  - 由于只能在本地进行版本控制，不便于团队协作，很少用。
  - 例如RCS 
- **集中式版本控制（例如SVN）**
  - 维护一个中央服务器，所有版本库存放在中央服务器，用户想获取版本，需要从中央服务器获取，更改后再将版本更新到中央服务器
  - 优点：
    1. 学习简单，更容易操作
    2. 支持二进制文件，对大文件支持更好（游戏、美术团队青睐）
  - 缺点：
    1. 本地不支持版本管理，所有提交需要连接上服务器才能完成提交
    2. 分支上的支持不够好，对于大型团队，合作比较困难
    3. **用户本地不保存所有版本的代码，如果服务端故障容易导致历史版本的丢失（非分布式的通有弊端）**
- **分布式版本控制（例如Git）**
  - 每个用户维护一个完整的版本库，用户之间通过相互推送更新版本（为了方便，Git拥有中央服务器，方便用户之间交换推送）
  - 优点：
    1. 分布式开发，每个用户拥有一个完整的版本库，不怕服务器故障丢失版本信息
    2. 分支管理功能强大，方便团队协作
    3. 校验和机制保证完整性，Git系统基本只增不删数据，不容易导致代码丢失
  - 缺点：
    1. 与SVN相比，学习成本更高
    2. 对于大文件支持不够好（git-lfs工具可以弥补该缺点）

### 为什么需要版本控制

1. 了解每个版本的改动，方便进行code review
2. 方便版本之间的切换，**遇到问题可以及时回滚**

## Git的原理

与一般的教程略有不同，我选择将Git的原理提前，只有掌握Git的原理才能更好的使用Git。

相信我，花时间了解这部分内容一定值得。

### Git的数据模型

#### 数据模型三大元素：blob,tree和commit

我们知道，Git通过版本管理一系列“文件”（在Unix-like系统中，文件和目录都视作“文件”）。

具体而言，Git 将顶级目录中的文件和文件夹作为集合，并通过一系列快照来管理其历史记录。

我们知道，在Unix-like系统中，文件和目录都视作“文件”，以文件树的形式维护整个目录。

在此基础上，Git创建了三个数据模型，分别是**blob，tree和commit**

- **blob**：在Git中，文件被称作数据对象，存储一组数据，**对应“叶子节点”**
- **tree**：目录，**对应“父节点”**。与树定义类似，tree可以包含tree和blob
- **commit**：快照，对当前顶级目录中的所有文件和文件夹（也就是整棵文件树）拍一张快照

举个例子：

假设Git维护了一个目录，并在拍了一张快照，如下：

```code
<root> (tree)
|
+- foo (tree)
|  |
|  + bar.txt (blob, contents = "hello world")
|
+- baz.txt (blob, contents = "git is wonderful")
```

这个顶层的树包含了两个元素，一个名为 “foo” 的树（它本身包含了一个 blob 对象 “bar.txt”），以及一个 blob 对象 “baz.txt”。

读到这里，尽管你可能有点懵，但你应该对blob,tree和commit有个大概的印象了。

#### Git数据组织形式

你也许会想到，既然Git是版本控制，也就是拥有一系列快照，那么Git的数据组织形式就是：通过线性将快照串联起来，使其成为一个特殊的单链表（节点为commit）

恭喜你答对了，但又不完全答对。

Git在没有分支的情况下，是一条特殊的单链表。然而，分支是Git最有特色的功能之一，分支提供了并行开发的可能性，因此大多数情况下，Git是一个有向无环图。

- “有向”：表示了快照之间的因果关系，子commit一定包含父commit的所有提交记录（一个快照可能有多个父快照，这意味着多条分支）
- “无环”：Git规定每个commit都是历史确定的、独一无二的。如果有环，说明某个版本改着改着又改成之前的版本了，这就破坏了版本的唯一性和历史确定性。

**举个例子：**

在 Git 中，这些快照被称为“提交”。通过可视化的方式来表示这些历史提交记录时，看起来差不多是这样的：

```code
o <-- o <-- o <-- o
            ^
             \
              --- o <-- o
```

上面是一个 ASCII 码构成的简图，其中的 o 表示一次提交（快照）。

箭头指向了当前提交的父辈（这是一种“在…之前”，而不是“在…之后”的关系）。在第三次提交之后，历史记录分岔成了两条独立的分支。这可能因为此时需要同时开发两个不同的特性，它们之间是相互独立的。开发完成后，这些分支可能会被合并并创建一个新的提交，这个新的提交会同时包含这些特性。新的提交会创建一个新的历史记录，看上去像这样（最新的合并提交用粗体标记）：

```code
o <-- o <-- o <-- o <----  o 
            ^            /
             \          v
              --- o <-- o
```

Git 中的提交是不可改变的。但这并不代表错误不能被修改，只不过这种“修改”实际上是创建了一个全新的提交记录。而引用（参见下文）则被更新为指向这些新的提交。

#### 数据模型的伪代码表示

> "talk is cheap, show your code"

我们使用伪代码对以上概念进行解释

```code
// 文件就是一组数据
type blob = array<byte>

// 一个包含文件和目录的目录
type tree = map<string, tree | blob>

// 每个提交都包含一个父辈，元数据和顶层树
type commit = struct {
    parents: array<commit>
    author: string
    message: string
    snapshot: tree
}
```
#### 对象和内存寻址

Git从存储的角度来看，是一个简单的key-value仓库，key以SHA-1哈希值的形式存储，而value以object的形式存储

显然，object包含了我们前面提到的commit,tree可以包含tree和blob

```code
type object = blob | tree | commit

objects = map<string, object>

def store(object):
    id = sha1(object)
    objects[id] = object

def load(id):
    return objects[id]
```

Git系统仅维护一份全局的完整的key-value表。当我们想表示其他的object，使用key来指代对象。
需要用到object数据时，Git会查询这个key-value表，来获取真实的object数据。

#### 引用

使用key来指代对象尽管准确，但是人类无法记忆这么多字符（40位16进制字符）。
针对这一问题，Git 的解决方法是给这些哈希值赋予人类可读的名字，也就是引用（references）。
**引用是指向提交的指针**。与对象不同的是，它是可变的（引用可以被更新，指向新的提交）。
例如，master 引用通常会指向主分支的最新一次提交。

```code
references = map<string, string>

def update_reference(name, id):
    references[name] = id

def read_reference(name):
    return references[name]

def load_reference(name_or_id):
    if name_or_id in references:
        return load(references[name_or_id])
    else:
        return load(name_or_id)
```

这样，Git 就可以使用诸如 “master” 这样人类可读的名称来表示历史记录中某个特定的提交，而不需要在使用一长串十六进制字符了。

有一个细节需要我们注意， 通常情况下，我们会想要知道“我们当前所在位置”，并将其标记下来。这样当我们创建新的快照的时候，我们就可以知道它的相对位置（如何设置它的“父辈”）。在 Git 中，我们当前的位置有一个特殊的索引，它就是 “HEAD”。

#### 仓库

最后，我们可以粗略地给出 Git 仓库的定义了：`对象` 和 `引用`。

在硬盘上，Git 仅存储对象和引用：因为其数据模型仅包含这些东西。
所有的 git 命令都对应着对提交树的操作，例如增加对象，增加或删除引用。

### 暂存区、工作区和版本库

#### 暂存区

就上面介绍的快照系统来说，您也许会期望它的实现里包括一个 “创建快照” 的命令，该命令能够基于当前工作目录的当前状态创建一个全新的快照。
有些版本控制系统确实是这样工作的，但 Git 不是。我们希望简洁的快照，而且每次从当前状态创建快照可能效果并不理想。
例如，考虑如下场景，您开发了两个独立的特性，然后您希望创建两个独立的提交，其中第一个提交仅包含第一个特性，而第二个提交仅包含第二个特性。
或者，假设您在调试代码时添加了很多打印语句，然后您仅仅希望提交和修复 bug 相关的代码而丢弃所有的打印语句。

Git 处理这些场景的方法是使用一种叫做 “暂存区（staging area）”的机制，它允许您指定下次快照中要包括那些改动。

#### 暂存区、工作区和版本库的关系

![picture 1](https://www.runoob.com/wp-content/uploads/2015/02/1352126739_7909.jpg)

- 图中左侧为工作区，右侧为版本库。在版本库中标记为 "index" 的区域是暂存区（stage/index），标记为 "master" 的是 master 分支所代表的目录树。
- 图中我们可以看出此时 "HEAD" 实际是指向 master 分支的一个"游标"。所以图示的命令中出现 HEAD 的地方可以用 master 来替换。
- 图中的 objects 标识的区域为 Git 的对象库，实际位于 ".git/objects" 目录下，里面包含了创建的各种对象及内容。
- 当对工作区修改（或新增）的文件执行 **git add** 命令时，暂存区的目录树被更新，同时工作区修改（或新增）的文件内容被写入到对象库中的一个新的对象中，而该对象的ID被记录在暂存区的文件索引中。
- 当执行提交操作（git commit）时，暂存区的目录树写到版本库（对象库）中，master 分支会做相应的更新。即 master 指向的目录树就是提交时暂存区的目录树。
- 当执行 **git reset HEAD** 命令时，暂存区的目录树会被重写，被 master 分支指向的目录树所替换，但是工作区不受影响。
- 当执行 **git rm --cached <file>** 命令时，会直接从暂存区删除文件，工作区则不做出改变。
- 当执行 **git checkout .** 或者 **git checkout -- <file>** 命令时，会用暂存区全部或指定的文件替换工作区的文件。这个操作很危险，会清除工作区中未添加到暂存区中的改动。
- 当执行 **git checkout HEAD .** 或者 **git checkout HEAD <file>** 命令时，会用 HEAD 指向的 master 分支中的全部或者部分文件替换暂存区和以及工作区中的文件。这个命令也是极具危险性的，因为不但会清除工作区中未提交的改动，也会清除暂存区中未提交的改动。

## Git实践

### 了解.git

我们首先要在自己的工作目录下初始化一个空的 git 仓库

```bash
git init
```

git 会告知我们已经在当前的目录下创建了一个.git 目录，我们来看看这个.git 长什么样子.

```bash
$ tree .git/
.git
├── HEAD
├── config
├── description
├── hooks
│   ├── applypatch-msg.sample
│   ├── commit-msg.sample
│   ├── fsmonitor-watchman.sample
│   ├── post-update.sample
│   ├── pre-applypatch.sample
│   ├── pre-commit.sample
│   ├── pre-merge-commit.sample
│   ├── pre-push.sample
│   ├── pre-rebase.sample
│   ├── pre-receive.sample
│   ├── prepare-commit-msg.sample
│   ├── push-to-checkout.sample
│   └── update.sample
├── info
│   └── exclude
├── objects
│   ├── info
│   └── pack
└── refs
    ├── heads
    └── tags

9 directories, 17 files
```

使用`ls -al`继续研究一下文件结构，我们会获得：

```bash
$ ls -al 
total 24
drwxr-xr-x   9 t  staff  288  1 17 20:01 .
drwxr-xr-x   3 t  staff   96  1 17 19:52 ..
-rw-r--r--   1 t  staff   21  1 17 19:52 HEAD
-rw-r--r--   1 t  staff  137  1 17 20:01 config
-rw-r--r--   1 t  staff   73  1 17 19:52 description
drwxr-xr-x  15 t  staff  480  1 17 19:52 hooks
drwxr-xr-x   3 t  staff   96  1 17 19:52 info
drwxr-xr-x   4 t  staff  128  1 17 19:52 objects
drwxr-xr-x   4 t  staff  128  1 17 19:52 refs
```

接下来，我们对各个部分进行解释：

- 文件：
  - `HEAD`：指针，指针指向当前commit节点
  - `config`：git的配置文件
  - `description`：用于为裸仓库（bare repository）提供一个描述。裸仓库通常没有工作区，只包含 .git 目录。description 文件包含仓库的简短描述，通常用于展示在 Git 服务器上的网页界面中。
- 目录：
  - `hooks`：这个目录存放 Git 钩子（hooks）脚本，用于在执行某些操作时自动触发特定的行为。例如，在提交前进行代码检查，或者在推送前自动部署。
  - `info`：这个目录存储一些配置和其他信息，通常与 Git 跟踪文件的行为有关。
    -  `exclude`：这个文件是 .gitignore 文件的补充，通常用于本地忽略不想提交的文件或目录。
  - **`objects`**：存储所有的 Git 对象。每个对象都由一个哈希值唯一标识。`objects`内容包括：
    - `commit` 对象：保存提交的元数据（如作者、日期、提交信息）及指向文件树对象的引用。
    - `tree` 对象：保存目录结构信息，包含文件路径和对应的 blob 对象的哈希。
    - `blob` 对象：保存文件的内容，Git 会对文件内容进行哈希运算后存储。
    - `tag` 对象：保存标签（tag）相关信息。
  - **`ref`**：存储所有的引用（references），即指向 Git 对象的指针。常见的引用包括分支、标签和远程仓库信息。内容包括：
    - `heads`: 存储本地分支的引用。例如，`.git/refs/heads/main` 指向 main 分支的最新提交。
    - `remotes`: 存储远程分支的引用。每个远程仓库对应一个子目录，如 .`git/refs/remotes/origin/main`。
    - `tags`: 存储 Git 标签的引用

接下来，我们尝试给工作区添加新文件，看看git仓库有什么变化

```bash
touch readme.md
echo "this is my first java project!" > readme.md
```

结果如下：

```bash
$ tree     
.
├── HEAD
├── config
├── description
├── hooks
│   ├── applypatch-msg.sample
│   ├── commit-msg.sample
│   ├── fsmonitor-watchman.sample
│   ├── post-update.sample
│   ├── pre-applypatch.sample
│   ├── pre-commit.sample
│   ├── pre-merge-commit.sample
│   ├── pre-push.sample
│   ├── pre-rebase.sample
│   ├── pre-receive.sample
│   ├── prepare-commit-msg.sample
│   ├── push-to-checkout.sample
│   └── update.sample
├── info
│   └── exclude
├── objects
│   ├── info
│   └── pack
└── refs
    ├── heads
    └── tags

9 directories, 17 files
```

我们发现`info`目录没有什么变化。这是因为我们没有将`readme.md`添加到暂存区，因此git没有追踪该文件`readme.md`，我们可以通过`git status`查看当前git仓库的追踪情况。

```bash
$ git status
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	readme.md

nothing added to commit but untracked files present (use "git add" to track)
```

可以看到，git提示我们文件`readme.md`还没有被追踪。

那么接下来，我们执行`git add readme.md`将文件添加到暂存区。再次使用`git status`查看git追踪状态：

```bash
$ git status
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   readme.md
```

`readme.md`已经进入了我们的git仓库！我们再看看`.git`有什么新文件：

```bash
$ tree .git
.git
├── HEAD
├── config
├── description
├── hooks
│   ├── applypatch-msg.sample
│   ├── commit-msg.sample
│   ├── fsmonitor-watchman.sample
│   ├── post-update.sample
│   ├── pre-applypatch.sample
│   ├── pre-commit.sample
│   ├── pre-merge-commit.sample
│   ├── pre-push.sample
│   ├── pre-rebase.sample
│   ├── pre-receive.sample
│   ├── prepare-commit-msg.sample
│   ├── push-to-checkout.sample
│   └── update.sample
├── index
├── info
│   └── exclude
├── objects
│   ├── 71
│   │   └── 5342074bc9395c6bde2941481266201d2c00a6
│   ├── info
│   └── pack
└── refs
    ├── heads
    └── tags

10 directories, 19 files
```

可以看到，这次我们多了1个目录和2个文件：

- `.git`下的文件`index`：这是暂存区。记录了即将被提交的文件（`readme.md`）的内容。以二进制格式存储，包含了每个文件的路径、权限、状态、哈希值等信息。
- `objects`下的目录`71`
- `71`目录下的文件`5342074bc9395c6bde2941481266201d2c00a6`，这个是新的blob object，记录了`readme.md`的内容

!!! info "为什么需要 index 文件？"

    index 文件使得 Git 可以高效地管理暂存区。在 `git add` 之后，Git 会把文件的变更记录到这个文件中，直到你执行 git commit，它才会将这些变更转化为正式的提交。
    通过这个文件，Git 可以非常快速地判断哪些文件已经修改并准备好提交，而不需要每次都遍历整个工作区。

!!! info "关于暂存区的一些小秘密"

    第一次，我们通过`touch`创建了`readme.md`，该文件内容为空，我们看到.git/objects多出了一个文件。而倘若你尝试创建几个同样的空文件`readme2.md`等，并将其`git add`，你会发现，.git目录不会发生任何改变。

    这是因为，如果你创建的三个文件的内容完全相同，那么 Git 会将它们视为相同的内容，并只为它们生成一个 blob 对象。Git 使用文件内容的哈希值（通常是 SHA-1）来标识文件的内容，而不仅仅是文件名。因此，如果三个文件的内容相同，它们会被分配相同的哈希值，而 .git/objects/ 目录只会存储一个对象。

为了更好地展示之后的内容，我们再添加一个文件：

```bash
touch Main.java
```

输入一部分内容：

```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}
```

接着，我们使用`git commit`将暂存区的内容commit

```bash
$ git commit    
[main (root-commit) fc8298b] Initial Commit
 2 files changed, 7 insertions(+)
 create mode 100644 main.java
 create mode 100644 readme.md
 ```

使用`git status`查看git状态，它告诉我们，暂存区的内容已经成功commit，现在工作目录没有需要commit的文件

```bash
$ git status
On branch main
nothing to commit, working tree clean
```

而如果使用`tree`查看`.git`目录，我们会发现，多了非常多文件：

- 两个`object`：接下来重点讲解这一部分
- .git/refs/main文件：

  ```bash
  cat refs/heads/main 
  fc8298b863f39169b53ee6a1f16d4ea59b23207e
  ```

  `.git/refs/heads/main` 指向 main 分支的最新提交。

- 目录`log`: 这个目录记录了对 Git 仓库的每一次更改（如 git commit、git checkout、git merge 等）。它允许你查看仓库的历史变更。

  ```bash
  $ cat logs/refs/heads/main
  0000000000000000000000000000000000000000 fc8298b863f39169b53ee6a1f16d4ea59b23207e xxxx2077 <13712052798@163.com> 1737120121 +0800	commit (initial): Initial Commit
  ```

  可以看到，logs记录了每个分支的每次commit信息

```bash
.git
├── COMMIT_EDITMSG
├── HEAD
├── config
├── description
├── hooks
│   ├── applypatch-msg.sample
│   ├── commit-msg.sample
│   ├── fsmonitor-watchman.sample
│   ├── post-update.sample
│   ├── pre-applypatch.sample
│   ├── pre-commit.sample
│   ├── pre-merge-commit.sample
│   ├── pre-push.sample
│   ├── pre-rebase.sample
│   ├── pre-receive.sample
│   ├── prepare-commit-msg.sample
│   ├── push-to-checkout.sample
│   └── update.sample
├── index
├── info
│   └── exclude
├── logs
│   ├── HEAD
│   └── refs
│       └── heads
│           └── main
├── objects
│   ├── 0f
│   │   └── a206413efce9b8fc5fd3eee5708ceddd4d937f
│   ├── 71
│   │   └── 5342074bc9395c6bde2941481266201d2c00a6
│   ├── fc
│   │   ├── 0bddc6ed6ae4682d93e1025a9b5c87b3a14c40
│   │   └── 8298b863f39169b53ee6a1f16d4ea59b23207e
│   ├── info
│   └── pack
└── refs
    ├── heads
    │   └── main
    └── tags
```

我们发现多了两个object，我们通过`git cat-file -p`命令查看object的内容：

```bash
$ git cat-file -p fc8298b863f39169b53ee6a1f16d4ea59b23207e
tree fc0bddc6ed6ae4682d93e1025a9b5c87b3a14c40
author xxxx2077 <13712052798@163.com> 1737120121 +0800
committer xxxx2077 <13712052798@163.com> 1737120121 +0800

Initial Commit
```

我们发现这个是commit object，不仅记录了commit的作者、提交者和提交信息，还记录了tree object的哈希值，这意味着，我们能够通过commit object继续往下寻找tree object：

```bash
$ git cat-file -p fc0bddc6ed6ae4682d93e1025a9b5c87b3a14c40
100644 blob 0fa206413efce9b8fc5fd3eee5708ceddd4d937f	main.java
100644 blob 715342074bc9395c6bde2941481266201d2c00a6	readme.md
```

通过读取tree object内容，我们发现其记录了两个blob object：`main.java`和`readme.md`

```bash
$ git cat-file -p 715342074bc9395c6bde2941481266201d2c00a6
this is my first java project!

$ git cat-file -p 0fa206413efce9b8fc5fd3eee5708ceddd4d937f
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}
```

通过`git cat-file -p`命令，我们成功从commit object往下找到了blob object，并读取了数据内容！

现在可以解释多出来的object是什么了：提交commit后，git为我们创建了顶级树tree object和commit object（blob object和普通的tree object在`git add`时已经创建）。commit object包含顶级树tree object的指针（哈希值），因此能够快速找到对应的顶级树

**object之间的关系如下图：**

![picture 2](https://generalthink.github.io/images/understanding-git/data-model-commit-object.png)

我们可以通过`git log`命令（`git log`记录了每次提交的记录）来验证这一过程：

```bash
$ git log
commit fc8298b863f39169b53ee6a1f16d4ea59b23207e (HEAD -> main)
Author: xxxx2077 <13712052798@163.com>
Date:   Fri Jan 17 21:22:01 2025 +0800

    Initial Commit

$ git cat-file -p fc8298b863f39169b53ee6a1f16d4ea59b23207e
tree fc0bddc6ed6ae4682d93e1025a9b5c87b3a14c40
author xxxx2077 <13712052798@163.com> 1737120121 +0800
committer xxxx2077 <13712052798@163.com> 1737120121 +0800

Initial Commit
```

到此，我们已将git理论模型实践了一遍。若你还想了解更多实践上的补充，可以参考以下链接：
<a id="shenruqianchu"></a>

- [深入浅出 git (一) 【数据模型】](https://generalthink.github.io/2019/01/09/understanding-git-data-model/)
- [深入浅出 git (二) 【分支】](https://generalthink.github.io/2019/01/10/understanding-git-branch/)
- [深入浅出 git (四) 【merge和rebase】](https://generalthink.github.io/2019/01/23/understanding-git-merge-and-rebase/)
- [深入浅出 git (五) 【自由的修改提交记录】](https://generalthink.github.io/2019/01/25/understanding-git-move-node/)
- [深入浅出 git (六) 【数据模型】](https://generalthink.github.io/2019/01/29/understanding-git-remote-cmd/)

## Git操作大全

### 基本使用

目录就是工作区

版本库就是工作区中的`.ssh`文件夹

版本库中最重要的就是称为stage（或者叫index）的暂存区，还有Git为我们自动创建的第一个分支`master`，以及指向`master`的一个指针叫`HEAD`。

```shell
git init #创建版本库

git add <file> #添加文件 
git add . #添加所有文件

git commit -m <message> #提交修改
```

`git add`命令实际上就是把要提交的所有修改放到暂存区（Stage），然后，执行`git commit`就可以一次性把暂存区的所有修改提交到分支。

`git status`显示的就是暂存区的状态

### 暂存区操作

#### `git add`

细粒度选择`git add`的内容

```bash
$ git add -p
```

对于每个差异块（hunk），Git 会提供几个选项让你选择如何处理这个块：

- y: 将当前块添加到暂存区。
- n: 跳过当前块，不添加到暂存区。
- s: 将当前块分割成更小的部分（如果可能的话），以便你可以更精确地选择要添加的部分。
- e: 手动编辑当前块，以选择具体的行进行添加。
- d: 不再询问，跳过所有剩余的块。
- q: 退出交互模式，停止处理剩余的块。

#### `git restore --staged`

**功能**：
- **从暂存区移除更改**：`git restore --staged <file>` 命令用于将指定文件从暂存区移除（即取消暂存），但保留工作目录中的更改。这意味着文件的内容在工作目录中保持不变，但不会包含在下一次提交中。

**应用场景**：
- 当你已经将某些文件添加到暂存区，但后来决定不希望这些更改包含在当前提交中时，可以使用这个命令。
- 这个命令特别适合当你想对一部分更改进行提交而暂时忽略其他更改时。

**示例**

1. 修改 `app.js` 并暂存：
   ```sh
   echo "console.log('Feature A');" >> app.js
   git add app.js
   ```

2. 查看状态：
   ```sh
   git status
   ```
   输出示例：
   ```
   Changes to be committed:
     (use "git restore --staged <file>..." to unstage)
           modified:   app.js
   ```

3. 取消暂存 `app.js`：
   ```sh
   git restore --staged app.js
   ```

4. 再次查看状态：
   ```sh
   git status
   ```
   输出示例：
   ```
   Changes not staged for commit:
     (use "git add <file>..." to update what will be committed)
           modified:   app.js
   ```

#### `git rm --cached`

**功能**：
- **从暂存区和索引中移除文件**：`git rm --cached <file>` 命令用于从暂存区和 Git 的索引中移除文件，但保留该文件在工作目录中。换句话说，它会停止跟踪该文件，但不会删除工作目录中的实际文件。
- 这个命令通常用于告诉 Git 不再跟踪某个文件，而不影响本地的工作副本。

**应用场景**：
- 当你有一个已经被 Git 跟踪的文件，但现在希望 Git 忽略它（例如，将它添加到 `.gitignore` 文件中），你可以使用 `git rm --cached` 来停止跟踪该文件。
- 如果你不使用 `--cached` 选项，`git rm` 将不仅从 Git 索引中移除文件，还会删除工作目录中的文件。

**示例**

1. 创建一个配置文件并提交：
   ```sh
   echo '{"api_key": "12345"}' > config.local.json
   git add config.local.json
   git commit -m "Add local config file"
   ```

2. 停止跟踪 `config.local.json`：
   ```sh
   git rm --cached config.local.json
   ```

3. 更新 `.gitignore` 文件以避免未来再次跟踪该文件：
   ```sh
   echo "config.local.json" >> .gitignore
   ```

4. 查看状态：
   ```sh
   git status
   ```
   输出示例：
   ```
   Changes to be committed:
     (use "git restore --staged <file>..." to unstage)
           deleted:    config.local.json

   Untracked files:
     (use "git add <file>..." to include in what will be committed)
           .gitignore
   ```

### git diff

提交后，用`git diff HEAD -- readme.txt`命令可以查看工作区和版本库里面最新版本的区别

git diff 有两个主要的应用场景。

- **git diff:** 当你在没有任何参数的情况下运行 git diff 时，默认情况下它会显示工作目录中尚未添加到暂存区（即未通过 git add）的更改。
- **git diff --cached:** 查看已缓存的改动
- **git diff HEAD:** 显示的是当前工作目录中的所有未提交的更改，包括已经暂存和未暂存的更改，与最近一次提交（HEAD）进行比较。
- **git diff --stat：** 显示摘要而非整个 diff

显示暂存区和工作区的差异:

```
$ git diff [file]
```

显示暂存区和上一次提交(commit)的差异:

```
$ git diff --cached [file]
或
$ git diff --staged [file]
```

显示两次提交之间的差异:

```
$ git diff [first-branch]...[second-branch]
```

### 回退操作

> 这里的回退不仅仅是回到历史操作，还可以恢复被回退了之后的操作
>
> 本质上是移动HEAD指针

`git log`用于查看commit记录，显示从最近到最远的提交日志

Git的版本回退速度非常快，因为Git在内部有个指向当前版本的`HEAD`指针，当你回退版本的时候，Git仅仅是把HEAD从指向`append GPL`：

```
┌────┐
│HEAD│
└────┘
   │
   └──▶ ○ append GPL
        │
        ○ add distributed
        │
        ○ wrote a readme file
```

改为指向`add distributed`：

```
┌────┐
│HEAD│
└────┘
   │
   │    ○ append GPL
   │    │
   └──▶ ○ add distributed
        │
        ○ wrote a readme file
```

然后顺便把工作区的文件更新了。所以你让`HEAD`指向哪个版本号，你就把当前版本定位在哪。

在Git中，用`HEAD`表示当前版本，，上一个版本就是`HEAD^`，上上一个版本就是`HEAD^^`，当然往上100个版本写100个`^`比较容易数不过来，所以写成`HEAD~100`。

现在，我们要把当前版本`append GPL`回退到上一个版本`add distributed`，就可以使用`git reset`命令：

```shell
$ git reset --hard HEAD^
HEAD is now at e475afc add distributed
```

关于`git reset`回退操作的参数

- `--hard`会回退到上个版本的已提交状态
- `--soft`会回退到上个版本的未提交状态
- `--mixed`会回退到上个版本已添加但未提交的状态。

**Git不仅能够回退历史操作，还能恢复操作**

```shell
$ git reset --hard <commit_id> #commit_id不用写全，可以写前几位，能和其他commit_id区分就行
```

如果不知道commit_id怎么办

- Git提供了一个命令`git reflog`用来记录你的每一次命令
- 通过该命令可获取commit_id

## Git分支

查看所有分支

```bash
$ git branch
```

添加分支

```bash
$ git checkout -b <branch_name>
```

切换分支

```bash
$ git checkout <branch_name>
```

删除分支

```bash
$ git branch -d <branch_name>
```