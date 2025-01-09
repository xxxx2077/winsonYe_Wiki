# Redis

Remote Dictionary Server 远程字典服务器

## 特点

- Key-value(KV)
- 命令原子性
- 低延迟，速度快（基于内存、IO多路复用）
- 支持数据持久化
- 支持主从集群、分片集群

## SQL vs NoSQL

SQL(Structured Query Language)->关系型数据库

- 结构化
  - 定义表的结构：多少个字段，每个字段有什么约束...
  - 一旦确定了表的结构，将来插入的数据都需要遵循该约束，否则报错
- 关联的
  - 使用外键将表连接起来
- SQL查询
  - 语法统一
- ACID
  - MySQL支持ACID

NoSQL->非关系型数据库

- 非结构化
  - KV  (如Redis)
  - Document 数据以json形式存储 （如MonogoDB，Elasticsearch)
  - Graph 数据以节点形式存储，数据之间使用边联系（Neo4j）
- 非关联的
  - 程序员自行维护数据关系，使用json嵌套关联数据->会重复数据存储
- 非SQL
  - 语法不统一
- BASE
  - 不支持事务，无ACID

**Other Details**

|          | MySQL                                 | Redis                                  |
| -------- | ------------------------------------- | -------------------------------------- |
| 存储方式 | 磁盘                                  | 内存                                   |
| 扩展性   | 垂直（单机视角：扩展通过加CPU、内存） | 水平（分布式视角，扩展通过加机器）     |
| 使用场景 | 数据结构固定，要求ACID                | 数据结构不固定，不要求ACID，性能要求高 |

## 安装Redis

### ubuntu

```shell
apt-get update
apt-get install redis
```

安装后

配置文件路径： /etc/redis/redis.conf

## 启动redis-server

### 基础运行

前台运行

```shell
redis-server
```

后台运行

> ubuntu apt-install 后自带

```shell
service redis-server start # 后台启动redis
service redis-server stop # 后台暂停redis
service redis-server status #查看状态
```

## 修改Redis配置文件启动

> Tips：vim中输入'/'+字符串可快速搜索对应设置

修改监听地址

```shell
bind 127.0.0.1 # 默认监听地址，只监听本机
bind 0.0.0.0 	# 监听任意主机
```

设置守护进程后台运行

```shell
daemonize yes #修改为yes可后台运行
```

设置redis登录密码

```shell
requirepass 密码
```

端口

```shell
port 6379 #自己设置端口，默认6379
dir . #工作目录（即运行redis-server的工作目录），默认当前目录
database 数字 #数据库数量，默认16
maxmemory 512mb #设置redis使用的最大内存
logfile #日志文件，默认为空不记录日志，可指定日志文件名

```

启动

```shell
redis-server redis.conf的路径
#如果当前在/etc/redis目录下，那么直接
redis-server redis.conf
#否则
redis-server /etc/redis/redis.conf
```

查看redis状态

```shell
ps -aux | grep redis
```

结束redis

```shell
kill -9 进程号（pid）
```

## 开机自启

> 这部分针对CentOS

https://www.cnblogs.com/miracle-luna/p/16864726.html

## 启动redis-cli

```shell
redis-cli [option] [command]

option:
-h : redis-server ip地址
-p : redis-server 端口（默认6379)
-a : 密码
```

如果redis-server有密码，但是一开始没有使用`-a`

那么输入AUTH加上用户名（可选）和密码

```shell
xxx> AUTH [serverName(optional)] [serverPassward]
```

## 帮助文档

官网commands

redis-cli 命令行 `help@`

## 常用命令

```shell
keys #查询满足pattern的key，不建议在主节点做，会阻塞
del #删除一个或多个key
exists #判断某个/多个key是否存在
expire #给一个key设置有效期，有效期到期该key被自动删除
ttl #查看剩余存活时间(time to live)
```

ttl返回-1表示永久有效，-2表示该key不存在

## Redis数据类型

### String

- string
- int
- float

以上均以字节数组方式存储

#### 命令

- set
- get
- mset
- mget
- incr
- incrby
- incrbyfloat
- setnx = set nx
- setex

#### 原理

底层使用了SDS（简单动态字符串）

使用len记录字符串的长度，而不是通过'\0'判断字符串结尾

- 不仅可以保存文本数据，还可以保存二进制数据（如视频、文件等）
- 获取字符串长度的时间复杂度为O(1)
- Redis字符串的API是安全的，拼接字符串不会造成缓冲区溢出（会自动扩容）

#### 应用

- 缓存对象
- 常规计数（Redis执行命令是单线程原子操作）
- 分布式锁
  - 利用SETNX命令，key不存在时才插入
    - 如果key不存在，则显示插入成功，对应加锁成功
    - 如果key存在，则显示插入失败，对应加锁失败
  - 使用EX命令设置锁的过期时间，防止死锁
  - 使用Lua脚本（Redis执行Lua脚本时可以以原子的方式执行）保证锁释放操作的原子性
- 共享session信息

### list

#### 特点

- 有序
- 元素可以重复
- 插入和删除快
- 查询速度一般

#### 命令

> l表示left, r表示right, b表示block 阻塞

- lpush
- lpop
- rpush
- rpop
- lrange
- blpop
- brpop

#### 原理

底层使用双向链表或压缩列表实现

Redis3.2版本之后使用quicklist

#### 应用

消息队列

- 先进先出：LPUSH + RPOP or RPUSH + LPOP
  - 消费者无法得知生产者有新数据产生，使用RPOP或LPOP需要循环阻塞
  - **使用BRPOP非阻塞式读取，没读到数据自动阻塞，有新数据进入读到数据就返回，节省CPU开销**
- 处理重复消息
  - 每个消息需要有一个全局ID
  - 消费者需要记录已经处理过的消息ID，与当前收到的消息ID比对，如果处理过无需再处理
  - **我们需要自行为每条消息生成一个全局唯一ID**
- 保证消息可靠性
  - 消费者从List读取一条消息后，List不再存有这条消息，若消费者处理过程因为故障或其他原因丢失这条消息，则消费者程序再次启动时，就没法从List读取这条消息
  - 使用BRPOPLPUSH命令，消费者程序从一个List读取消息，同时将这条消息插入到备份List中留存
  - 若丢失消息可以从备份List中读取

缺点：

不支持多个消费者消费同一条消息，消费完一条消息，这条消息就从List中删去

想要实现多个消费者消费同一条消息，需要实现消费组，List不支持消费组的实现

而Stream类型可以

### hash

#### 命令

- hset
- hget
- hmset
- hmget
-  hgetall
- hkeys
- hvals
- hincryby
- hsetnx

#### 原理

压缩列表或哈希表

Redis7.0由listpack实现

#### 应用

缓存对象

String + Json 和 Hash都能缓存对象

一般使用String + Json 

变动频繁使用Hash

- 购物车，key对应用户id，field对应商品id，value对应商品数量

### set

#### 特点

类似于哈希表

- 无序
- 元素不可重复
- 查找快
- 支持集合运算

#### 命令

- sadd
- srem
- scard 元素个数
- sismember
- smembers
- 集合运算
  - sinter 交集
  - sdiff 差集
  - sunion 并集

#### 原理

哈希表或整数集合

#### 应用

适合数据去重和保证数据的唯一性

适合统计多个集合的交集、错集和并集等

- 计算复杂度较高，避免主库阻塞，交给从库或客户端计算

点赞功能（一个用户只能点一个赞）

共同关注（交集运算）

抽奖活动（一个用户只能中一次奖）

### SortedSet/zset

#### 特点

- 可排序
- 元素不重复
- 查询速度快

#### 命令

![image-20241031220950726](/Users/t/Desktop/xxxx2077.github.io/docs/software_development/backend/Redis.assets/image-20241031220950726.png)

压缩列表 or 跳表

Redis7.0压缩列表废弃，交给listpack

在set基础上添加了score，score可以重复，value不能重复，通过score排序

#### 应用

排行榜

## 实战篇
