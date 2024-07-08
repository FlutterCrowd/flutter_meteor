#!/bin/bash


file=pubspec.yaml

# 读取文件中的版本号
version_line=$(grep 'version:' $file)
# shellcheck disable=SC2001
current_version=$(echo "$version_line" | sed 's/version: //')
echo "当前版本: $current_version"
# 分割版本号
head_version=$(echo "$current_version" | cut -d'.' -f1)
mid_version=$(echo "$current_version" | cut -d'.' -f2)
last_version=$(echo "$current_version" | cut -d'.' -f3)
# 自增版本号
type=$1
echo "自增版本类型： $type"
if [ "$type" == '1' ]; then
  mid_version=$((mid_version + 1))
elif [ "$type" == '2' ]; then
  head_version=$((head_version + 1))
else
  # shellcheck disable=SC2004
  last_version=$((last_version + 1))
fi
new_version="${head_version}.${mid_version}.${last_version}"
# 替换文件中的版本号
sed -i '' "s/version: $current_version/version: $new_version/" $file

# 升级版本号
echo "升级版本号： $new_version"
git add .
git commit -m "feat: 升级版本号"
echo "开始push新的提交"
git push

# 打tag
echo "开始打tag"
git tag $new_version
git push origin $new_version