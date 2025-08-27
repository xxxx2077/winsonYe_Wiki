# Linux

## 常用命令

### netstat

查看整个Linux系统的网络情况

```
-a   或–all                             显示所有连线中的Socket。
-A                                       <网络类型>或–<网络类型> 列出该网络类型连线中的相关地址。
-c   或–continuous               持续列出网络状态。
-C 或–cache                       显示路由器配置的快取信息。
-e  或–extend                     显示网络其他相关信息。
-F  或 –fib                          显示FIB。
-g  或–groups                     显示多重广播功能群组组员名单。
-h  或–help                        在线帮助。
-i   或–interfaces                 显示网络界面信息表单。
-l  或–listening                    显示监控中的服务器的Socket。
-M   或–masquerade           显示伪装的网络连线。
-n  或–numeric                   直接使用IP地址，而不通过域名服务器。
-N   或–netlink或–symbolic  显示网络硬件外围设备的符号连接名称。
-o  或–timers                      显示计时器。
-p   或–programs                显示正在使用Socket的程序识别码和程序名称。
-r  或–route                        显示 Routing Table。
-s  或–statistice 显示网络工作信息统计表。
-t  或–tcp 显示TCP 传输协议的连线状况。
-u或–udp 显示UDP传输协议的连线状况。
-v或–verbose 显示指令执行过程。
-V 或–version 显示版本信息。
-w或–raw 显示RAW传输协议的连线状况。
-x或–unix 此参数的效果和指定”-A unix”参数相同。
–ip或–inet 此参数的效果和指定”-A inet”参数相同。
```

常用命令如下：

```
netstat -ntlp //查看当前所有tcp端口使用情况	

netstat -ntulp | grep 80 //查看所有80端口的使用情况	

netstat -an | grep 3306   //查看所有3306端口使用情况

netstat -nlp | grep LISTEN   //查看当前所有监听端口
```



> 解释一下状态（state）了
>
> - LISTEN：(Listening for a connection.)侦听来自远方的TCP端口的连接请求
> - SYN-SENT：(Active; sent SYN. Waiting for a matching connection request after having sent a connection request.)再发送连接请求后等待匹配的连接请求
> - SYN-RECEIVED：(Sent and received SYN. Waiting for a confirming connection request acknowledgment after having both received and sent connection requests.)再收到和发送一个连接请求后等待对方对连接请求的确认
> - ESTABLISHED：(Connection established.)代表一个打开的连接
> - FIN-WAIT-1：(Closed; sent FIN.)等待远程TCP连接中断请求，或先前的连接中断请求的确认
> - FIN-WAIT-2：(Closed; FIN is acknowledged; awaiting FIN.)从远程TCP等待连接中断请求
> - CLOSE-WAIT：(Received FIN; waiting to receive CLOSE.)等待从本地用户发来的连接中断请求
> - CLOSING：(Closed; exchanged FIN; waiting for FIN.)等待远程TCP对连接中断的确认
> - LAST-ACK：(Received FIN and CLOSE; waiting for FIN ACK.)等待原来的发向远程TCP的连接中断请求的确认
> - TIME-WAIT：(In 2 MSL (twice the maximum segment length) quiet wait after close. )等待足够的时间以确保远程TCP接收到连接中断请求的确认
> - CLOSED：(Connection is closed.)没有任何连接状态



route 

arp

top

下面这个命令可以定位僵尸进程以及该僵尸进程的父进程：

```bash
ps -A -ostat,ppid,pid,cmd |grep -e '^[Zz]'
```