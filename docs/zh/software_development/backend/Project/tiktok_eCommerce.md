# 抖音商城项目

## 技术栈

项目基础：

- 编程语言：Go
- RPC框架：[Kitex](https://www.cloudwego.io/zh/docs/kitex/overview/)
- HTTP框架：[Hertz](https://www.cloudwego.io/zh/docs/hertz/overview/)
- IDL语言：[proto3](../Framework/RPC.md/#proto3)
- 服务注册与发现： [Consul](https://www.cloudwego.io/zh/docs/kitex/tutorials/service-governance/service_discovery/consul/)
- 数据库：Mysql & [GORM](https://gorm.io/zh_CN/docs/index.html)
- 缓存：Redis

项目组织工具：

- Makefile
- 代码生成工具：[cwgo](https://www.cloudwego.io/zh/docs/cwgo/overview/)

## 项目架构

### 微服务

单个服务采用cwgo根据idl生成项目框架

cwgo生成RPC项目结构为：

```
├── biz // 业务逻辑目录
│   ├── dal // 数据访问层
│   │   ├── init.go
│   │   ├── mysql
│   │   │   └── init.go
│   │   └── redis
│   │       └── init.go
│   └── service // service 层，业务逻辑存放的地方。更新时，新的方法会追加文件。
│       ├── HelloMethod.go
│       └── HelloMethod_test.go
├── build.sh
├── conf // 存放不同环境下的配置文件
│     └── ...
├── docker-compose.yaml
├── go.mod // go.mod 文件，如不在命令行指定，则默认使用相对于 GOPATH 的相对路径作为 module 名
├── handler.go // 业务逻辑入口，更新时会全量覆盖
├── idl
│   └── hello.thrift
├── kitex.yaml
├── kitex_gen // IDL 内容相关的生成代码，勿动
│     └── ...
├── main.go // 程序入口
├── readme.md
└── script // 启动脚本
    └── bootstrap.sh
```

## 搭建项目

## 开发项目

### 开发环境配置

**开发工具**

- [VScode](../../../configuration/vscode.md)
- [terminal](../../../configuration/terminal.md)
- Docker

**idl编译工具**

- 下载`protoc`以编译protobuf
- 下载protobuf的go插件

!!! tip

    我们使用cwgo编译idl并生成代码，包含以上步骤：[cwgo配置教程](https://www.cloudwego.io/zh/docs/cwgo/getting-started/)

**读取环境变量工具**

- `godotenv`

### 数据库使用

在`biz-demo`目录下新建目录`model`，添加表信息：

```Go
package model

import "gorm.io/gorm"

type User struct {
	gorm.Model
	Email    string `gorm:"uniqueIndex;type:varchar(128) not null"`
	Password string `gorm:"type:varchar(64) not null"`
}

// 更改表名
func (u *User) TableName() string {
	return "user"
}

```

编写`dal/init.go`函数，配置填写在`.env`文件：

`.env`文件：
```bash
MYSQL_USER=winson
MYSQL_PASSWORD=winson1216
MYSQL_HOST=127.0.0.1
MYSQL_DATABASE=test
```

`dal/init.go`文件：

```Go
package mysql

import (
	"fmt"
	"log"
	"os"

	"github.com/xxxx2077/demo/ch2/echo/biz/model"
	"github.com/xxxx2077/demo/ch2/echo/conf"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var (
	DB  *gorm.DB
	err error
)

func Init() {
    // 读取环境设置
	dsn := fmt.Sprintf(conf.GetConf().MySQL.DSN,
		os.Getenv("MYSQL_USER"),
		os.Getenv("MYSQL_PASSWORD"),
		os.Getenv("MYSQL_HOST"),
		os.Getenv("MYSQL_DATABASE"),
	)
	DB, err = gorm.Open(mysql.Open(dsn),
		&gorm.Config{
			PrepareStmt:            true,
			SkipDefaultTransaction: true,
		},
	)
	if err != nil {
		panic(err)
	}

    // 这部分仅仅测试是否连上数据库
	type Version struct {
		Version string
	}

	var v Version

	err := DB.Raw("select version() as version").Scan(&v).Error
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(v.Version)

    // gorm自动迁移
	DB.AutoMigrate(&model.User{})
}

```

业务代码调用`gorm`方式：

```Go
dal.Init()

mysql.DB.Create(&model.User{
    Email:    "123456@qq.com",
    Password: "123345",
})
```

使用方法见[GORM](https://gorm.io/zh_CN/docs/index.html)
