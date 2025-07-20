#!/bin/bash

# 获取当前分支名
current_branch=$(git symbolic-ref --short HEAD)

if [[ "$current_branch" == "main" ]]; then
  echo "❌ 当前就在 main，不建议直接提交合并！"
  exit 1
fi

echo "请输入本次提交的备注（例如：新增图谱配置解析）："
read commit_msg

if [[ -z "$commit_msg" ]]; then
  echo "❌ 提交信息不能为空"
  exit 1
fi

# 提交
git add .
git commit -m "feat: $commit_msg"

# 合并到 main
git switch main
git pull origin main
git merge --no-ff "$current_branch"
git push origin main

# 可选删除功能分支
read -p "是否删除分支 $current_branch？(y/N): " confirm
if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  git branch -d "$current_branch"
  git push origin --delete "$current_branch"
  echo "🧹 已删除分支：$current_branch"
else
  echo "✅ 分支保留：$current_branch"
fi

echo "🎉 提交完成并合并进 main！"

