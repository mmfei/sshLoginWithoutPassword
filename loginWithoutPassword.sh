#!/bin/bash
echo "********************";
echo " 目的 在 A机器 [这里称为 控制机] 要免密码登陆 B机器[被控制机]";
echo "********************";
echo "";

echo "本脚本要在控制机器 A上运行";

echo "请输入被控制机器IP";
read destIp;

echo "";

echo "请输入被控制机器账号";
read destUser;

echo "";

echo "请输入被控制机器端口";
read destPort;

if [ -z "$destPort" ]; then
        destPort=22;
fi

echo "";

echo "是否已经在A机器生成了对应的key(y/n)";
read isHasCreateKey;

if [ "n" = "$isHasCreateKey" ]; then
        echo "需要生成公钥私钥 , 请连续敲三次回车";
        ssh-keygen -t rsa # (连续三次回车,即在本地生成了公钥和私钥,不设置密码)
fi

echo "正在被控制机器创建文件夹.ssh ; 需要输入被控制机器的密码 ; ";

ssh -p $destPort $destUser@$destIp "mkdir .ssh;chmod 0700 .ssh" # (需要输入密码， 注:必须将.ssh的权限设为700)

echo "正在传输对应的公钥到被控制机 , 请输入被控制机密码";
scp -P $destPort ~/.ssh/id_rsa.pub $destUser@$destIp:.ssh/id_rsa.pub # (需要输入密码)

echo "正在目标机器中部署 , 请输入被控制机密码";

ssh -p $destPort $destUser@$destIp "if [ ! -f  ~/.ssh/authorized_keys ]; then touch ~/.ssh/authorized_keys; fi; chmod 600 ~/.ssh/authorized_keys; cat ~/.ssh/id_rsa.pub  >> ~/.ssh/authorized_keys";

echo "";
echo "********************";
echo "恭喜!!! 已经完成了免密码登陆的所有操作 , 请使用尝试登陆!!!";
echo "********************";
echo "";

echo "ssh -p $destPort $destUser@$destIp";
