#!/bin/bash

# 文件路径
FILE="pubspec.yaml"

# 读取 pubspec.yaml 中的版本号
VERSION_LINE=$(grep 'version:' $FILE)
# shellcheck disable=SC2001
CURRENT_VERSION=$(echo "$VERSION_LINE" | sed 's/version: //')
echo "当前版本: $CURRENT_VERSION"

# 打 tag 并推送 tag
echo "开始打 tag"
git tag "$NEW_VERSION"
if git push origin "$NEW_VERSION"; then
  echo "Tag $NEW_VERSION 推送成功"
else
  echo "[ERROR] Tag 推送失败"
fi