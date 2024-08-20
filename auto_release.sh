#!/bin/bash

git pull
file=pubspec.yaml
ios_pudspec=ios/flutter_meteor.podspec

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

# 替换iOS 的版本号
sed -i "" "s/s.version *= *'[^']*'/s.version = '${new_version}'/" "$ios_pudspec"

# 检查替换结果
if grep -q "s.version = '${new_version}'" "$ios_pudspec"; then
  echo "iOS版本号已成功更新为 ${new_version}"
else
  echo "iOS版本号更新失败"
fi

# 升级版本号
echo "升级版本号： $new_version"
git add .
git commit -m "feat: 升级版本号"
echo "开始push新的提交"
git push

# 检查退出状态码
# shellcheck disable=SC2181
if [ $? -eq 0 ]; then
  echo "Git push 成功"
  # 打tag
  echo "开始打tag"
  git tag $new_version
  git push origin $new_version
else
  # 替换文件中的版本号
  sed -i '' "s/version:$new_version/version: $current_version/" $file

  # 替换iOS 的版本号
  sed -i "" "s/s.version *= *'[^']*'/s.version = '$current_version'/" "$ios_pudspec"
  echo "回退版本： $current_version"
  git add .
  git commit -m "feat: 回退版本"
  echo "Git push 失败"
fi
