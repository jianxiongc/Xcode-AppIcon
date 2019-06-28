#!/bin/sh

if [ ! -n "$1" ] ;then
echo "\033[31m 没有传入参数，需要传入执行的图片路径 \033[0m"
exit
else
echo "\033[32m 开始执行 \033[0m"
fi

echo "-------------------------开始裁剪Appicon---------------------------"

filename="$1"

dirname="AppIcon.appiconset"

author="jianxiong"

filename_array=("iphone_Notification_20pt@2x.png" "iphone_Notification_20pt@3x.png"\
				"iphone_Setting_29pt@2x.png" "iphone_Setting_29pt@3x.png"\
				"iphone_Spotlight_40pt@2x.png" "iphone_Spotlight_40pt@3x.png"\
				"iphone_App_60pt@2x.png" "iphone_App_60pt@3x.png"\
				"ipad_Notification_20pt@1x.png" "ipad_Notification_20pt@2x.png"\
				"ipad_Setting_29pt@1x.png" "ipad_Setting_29pt@2x.png"\
				"ipad_Spotlight_40pt@1x.png" "ipad_Spotlight_40pt@2x.png"\
				"ipad_App_76pt@1x.png" "ipad_App_76pt@2x.png"\
				"ipad_Pro_App_83.5pt@2x.png"\
				"ios-marketing_Store_1024pt@1x.png")

commonsize_array=("20" "20"\
			"29" "29"\
			"40" "40"\
			"60" "60"\
			"20" "20"\
			"29" "29"\
			"40" "40"\
			"76" "76"\
			"83.5"\
			"1024")



size_array=("40" "60"\
			"58" "87"\
			"80" "120"\
			"120" "180"\
			"20" "40"\
			"29" "58"\
			"40" "80"\
			"76" "152"\
			"167"\
			"1024")





mkdir $dirname




#添加描述文件
files=`find filename -name "*.png"`
for i in ${files[@]}; 
do
    echo "+++${i}"
    SOURCE_FILE=${i}
    DESTINATION_FILE=$SOURCE_FILE
    sips \--matchTo '/System/Library/ColorSync/Profiles/sRGB Profile.icc' $SOURCE_FILE \--out $DESTINATION_FILE
done




echo "----------开始裁剪---------"
for ((i=0;i<${#size_array[@]};++i)); do

mkdir $dirname

m_dir=$dirname/${filename_array[i]}

echo $filename $m_dir
cp $filename $m_dir

sips -Z ${size_array[i]} $m_dir

done


cd $dirname
echo "----------开始生成Content.json---------"
echo {  >> Contents.json
echo "  \"images\"" : [>> Contents.json


for (( i = 0; i < ${#size_array[@]}; ++i )); do
	#statements
	imageName=${filename_array[i]}
	IFS='@' arr=($imageName)
	IFS='_' idiomArr=($imageName)
	temp=${arr[1]}
	scaleStr=${temp:0:2}
	scale=${temp:0:1}
	size=${size_array[i]}	
	# commonSize=$(echo "${size}/${scale}"|bc)
	commonsize=${commonsize_array[i]}
	idiom=${idiomArr[0]}

	echo "--------------------------------"
	echo "size:${commonsize}x${commonsize}"
	echo "filename:$imageName"
	echo "scale:$scale"
	echo "idiom:$idiom"
	echo "--------------------------------"

	echo "   "{>> Contents.json
	echo "      \"size\"" : "\"${commonsize}x${commonsize}\"",>> Contents.json
    echo "      \"idiom\"" : "\"$idiom\"",>> Contents.json
    echo "      \"filename\"" : "\"$imageName\"",>> Contents.json
    echo "      \"scale\"" : "\"$scaleStr\"">> Contents.json
    echo "   "},>> Contents.json

done
echo " "],>> Contents.json
echo "  \"info\"" : {>> Contents.json
echo "     \"version\"" : 1,>> Contents.json
echo "     \"author\"" : "\"$author\"">> Contents.json
echo " "}>> Contents.json
echo }>> Contents.json

echo "-------------------------裁剪结束--------------------------"
cd ..

echo "生成图标数个数为: ${#filename_array[*]}"
echo "文件大小:$(du -h $dirname)"
echo "\033[36;1m总用时: ${SECONDS}s \033[0m"
