#!/bin/bash

# 检查是否有名为 mkdocs 的环境
if ! conda env list | grep -q 'mkdocs'; then
  echo "环境 mkdocs 不存在，正在创建..."
  conda create -n mkdocs python=3.9 -y
else
  echo "环境 mkdocs 已存在。"
fi

# 激活环境 mkdocs
echo "激活 mkdocs 环境..."
conda activate mkdocs

# 安装依赖
echo "安装依赖..."
pip install -r requirements.txt

# 启动 mkdocs 服务
echo "启动 mkdocs 服务..."
mkdocs serve
