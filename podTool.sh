
#!/bin/bash


POD_SPECS_HTTP="https://github.com/OrageKK/Specs"
POD_SPECS_NAME="Specs"

echo "\033[36;1m请选择方式(输入序号,按回车即可) \033[0m"
echo "\033[33;1m Enter 全部流程       \033[0m"
echo "\033[33;1m0. 本地校验       \033[0m"
echo "\033[33;1m1. 校验spec并远程验证    \033[0m"
echo "\033[33;1m2. 推送到远程       \033[0m"

read buildParameter
# 判读用户是否有输入

if [ ! -n "$buildParameter" ]
then
pod lib lint --sources="$POD_SPECS_HTTP,https://github.com/CocoaPods/Specs"  --clean --private --allow-warnings --use-libraries

pod spec lint --sources="$POD_SPECS_HTTP,https://github.com/CocoaPods/Specs"  --clean --private --allow-warnings --verbose --use-libraries

pod repo push $POD_SPECS_NAME --private --allow-warnings --use-libraries
elif [ $buildParameter == 0 ]
then
  pod lib lint --sources="$POD_SPECS_HTTP,https://github.com/CocoaPods/Specs" --clean --private --allow-warnings --use-libraries
elif [ $buildParameter == 1 ]
then
  pod spec lint --sources="$POD_SPECS_HTTP,https://github.com/CocoaPods/Specs" --clean --private --allow-warnings --verbose --use-libraries
elif [ $buildParameter == 2 ]
then
    pod repo push $POD_SPECS_NAME --private --allow-warnings --use-libraries
else
    echo '参数有误'
    exit 1
fi
