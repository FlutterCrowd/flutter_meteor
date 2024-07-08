#!/bin/bash


file=pubspec.yaml

# 读取文件中的版本号
version_line=$(grep 'version:' $file)
current_version=$(echo $version_line | sed 's/version: //')
echo "current version is: $current_version"
# 分割版本号
#base_version=$(echo $current_version | cut -d'+' -f1)
#build_number=$(echo $current_version | cut -d'+' -f2)
head_version=$(echo $current_version | cut -d'.' -f1)
mid_version=$(echo $current_version | cut -d'.' -f2)
last_version=$(echo $current_version | cut -d'.' -f3)
echo "head_version:$head_version, mid_version: $mid_version, last_version:$last_version"
# 自增版本号
type=$1
if [ "$type" == '1' ]; then
  mid_version=$((mid_version + 1))
elif [ "$type" == '2' ]; then
  head_version=$((head_version + 1))
else
  # shellcheck disable=SC2004
  last_version=$((last_version + 1))
fi
new_version="${head_version}.${mid_version}.${last_version}"
echo "new version is: $new_version"
# 替换文件中的版本号
sed -i '' "s/version: $current_version/version: $new_version/" $file

# 升级版本号
git add .
git commit -m "feat: 升级版本号"
git push origin develop

# 打tag
git tag $new_version
git push origin $new_version