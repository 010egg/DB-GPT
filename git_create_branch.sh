#!/bin/bash

# --------- 中文转拼音依赖 ---------
to_pinyin() {
    python3 -c "from pypinyin import lazy_pinyin; import sys; print('-'.join(lazy_pinyin(sys.argv[1])))" "$1"
}

# --------- 获取描述 ---------
echo "请输入本次开发分支的中文描述："
read desc

if [[ -z "$desc" ]]; then
  echo "❌ 描述不能为空"
  exit 1
fi

# --------- 分类分支前缀 ---------
if [[ "$desc" == *修复* || "$desc" == *bug* ]]; then
  prefix="fix"
elif [[ "$desc" == *调试* || "$desc" == *测试* ]]; then
  prefix="dev"
else
  prefix="feat"
fi

pinyin=$(to_pinyin "$desc")
branch="$prefix/$pinyin"

# --------- Git 操作 ---------
git switch main || exit 1
git pull origin main
git switch -c "$branch"

echo "✅ 已切换到新分支：$branch"

