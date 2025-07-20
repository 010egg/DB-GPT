#!/bin/bash

# 中文转拼音依赖: pypinyin
# 安装: pip install pypinyin

# ========= 函数部分 =========
to_pinyin() {
    python3 -c "from pypinyin import lazy_pinyin; import sys; print('-'.join(lazy_pinyin(sys.argv[1])))" "$1"
}

# ========= 输入部分 =========
echo "请输入更新内容（中文，例如：修复图谱初始化失败）："
read update_msg

if [[ -z "$update_msg" ]]; then
    echo "❌ 更新内容不能为空"
    exit 1
fi

# ========= 分类逻辑 =========
if [[ "$update_msg" == *修复* || "$update_msg" == *bug* ]]; then
    prefix="fix"
elif [[ "$update_msg" == *调试* || "$update_msg" == *测试* ]]; then
    prefix="dev"
else
    prefix="feat"
fi

# ========= 拼接分支名 =========
pinyin_name=$(to_pinyin "$update_msg")
branch_name="$prefix/$pinyin_name"

echo "🔧 生成分支名：$branch_name"

# ========= Git 操作流程 =========
git checkout main || exit 1
git pull origin main

# 创建新分支
git checkout -b "$branch_name"

# 添加、提交
git add .
git commit -m "$prefix: $update_msg"

# 合并回 main
git checkout main
git pull origin main
git merge --no-ff "$branch_name"

# 推送 main
git push origin main

# 删除功能分支（可选注释掉）
#git branch -d "$branch_name"
#git push origin --delete "$branch_name"

echo "✅ 已完成：$update_msg 已合并并推送到 main 分支。"

