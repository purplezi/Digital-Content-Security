# <center> 图像基本处理以及图像JPEG压缩
##### <center> 赵紫如
###### <center> 学号：201711123020 班级：信息安全2017级

# 1 测试环境
(1) 实验图像：512x512的灰度图像和512x512的彩色图像。即lena512.bmp和lena512.tif。

(2) 使用的工具：MATLAB R2018a。
  
# 2 实验目的
(1)熟悉Matlab图像处理编程环境；

(2)图像JPEG压缩实验。

# 3 实验内容
## 3.1 模拟数字图像JPEG压缩，绘制PSNR~Q曲线

### 3.1.1 读入图片
(1) 用imread读入灰度图片。
```matlab
% imread返回值类型为uint8，读入一张灰度图片
im=imread('lena512.bmp');
```
(2) 读入彩色图片，需要转换颜色空间，y是最终的亮度通道。
```matlab
% imread返回值类型为uint8
im=imread('lena512.bmp');
% convert the image to YIQ color space
y=rgb2ntsc(im);
% get the NTSC luminance value
% represented by the first color channel in the YIQ image.
y=y(:,:,1);
```

### 3.1.2 遍历质量因子，得到压缩后的图片
(1) 质量因子$q$的范围是$0~100$，由$F_q(u,v)=F(u,v)/q$，我们可从理论上分析质量因子越大，压缩的比重越小，损失越小。

(2) 遍历质量因子的范围，得到101张lena图像。
```matlab
path='images/';
im=imread('lena512.bmp');
% get the images when Quality change between 0-100 
for i=0:100
    % 将文件以编号重命名放入images文件夹中
    savename=[num2str(i),'.jpg'];
    savename=[path,savename];
    % imwrite可以实现JPEG压缩并指定质量因子
    imwrite(im,savename,'jpg','Quality',i);
end
```
从实验上验证我们的分析，可得如下对比图1。
```matlab
q=[1, 5, 10, 15, 30, 50, 70, 90];
num=1;
for i=q
    imwrite(im,'test.jpg','jpg','Quality',i);
    subplot(2,4,num),imshow(imread('test.jpg')),title(['质量因子',int2str(i),'%']);
    num=num+1;
end
```

![质量因子的变化](images/qualifactor-contrast.png)


### 3.1.3 绘制PSNR~Q曲线
(1) PSNR(Peak Signal-to-Noise Ratio)峰值信噪比，PSNR越高，压缩后失真越小。

(2) 根据公式$PSNR=10*log_{10}({MAX_I^2 \over MSE})$，$MAX_I$为最大像素值(8bit的灰度图像为255)，$MSE$是均方差，计算公式为$MSE={1\over mn}\sum_{i=0}^{m-1}\sum_{j=0}^{n-1}||I(i,j)-K(i,j)||^2$，$I$为原图像，$K$为失真后图像，(m,n)为图像尺寸。

```matlab
im=imread('lena512.bmp');
[h w]=size(im); 
im=double(im);
ans=zeros(1,101);
ans=double(ans);
MAX=255*255;
for i=0:100
    readname=[path,num2str(i)];
    readname=[readname,'.jpg'];
    read=imread(readname);
    read=double(read);
    % 矩阵可以直接相减
    MES=sum(sum((im-read).^2))/(h*w);
    ans(i+1)=10*log10(MAX/MES);
end 
```
处理后的曲线为图2。
![PSNR~Q1](images/PSNR~Q.png)

(3) 调用psnr函数
```matlab
im=imread('lena512.bmp');
ans=zeros(1,101);
ans=double(ans);
for i=0:100
    readname=[path,num2str(i)];
    readname=[readname,'.jpg'];
    read=imread(readname);
    read=double(read);
    [peaksnr,snr]=psnr(read,double(im));
    ans(i+1)=peaksnr;
end
```
处理后的曲线为图3。
![PSNR~Q2](images/PSNR~Q-myfunc.png)

### 3.1.4 问题与解决
(1) 为什么自己编写的PSNR和调用matlab的内置函数PSNR有差别？

## 3.2 


# 4 参考资料
(1) 文件格式的说明：
* TIFF(Tag Image File Format)标签图像文件格式，是灵活的位图格式，主要用来储存包括照片和艺术图在内的图像
* PNG(Portable Network Graphics)便携式网络图形，一种无损压缩的位图片形格式

(2) [读取JPEG文件的压缩质量/质量因子参数](https://blog.csdn.net/gwena/article/details/71123734)