%������
function ImageRecognition()
clc
clear
cutimage= imread('eg.jpg');

cutimage = rgb2hsv(cutimage);

img = cutimage(:,:,1);
cluster_num = 2;    % ���÷�����
maxiter = 60;       % ����������

%-------------�����ʼ����ǩ----------------
%label = randi([1,cluster_num],size(img));

%-----------kmeans��Ϊ��ʼ��Ԥ�ָ�----------
label = kmeans(img(:),cluster_num);
label = reshape(label,size(img));
iter = 0;

while iter < maxiter
    %-------�����������---------------
    %�����Ҳ��õ������ص��3*3����ı�ǩ��ͬ
    %�������Ϊ�������
    %------�ռ���������б�Ȱ˸�����ı�ǩ--------
    label_u = imfilter(label,[0,1,0;0,0,0;0,0,0],'replicate');
    label_d = imfilter(label,[0,0,0;0,0,0;0,1,0],'replicate');
    label_l = imfilter(label,[0,0,0;1,0,0;0,0,0],'replicate');
    label_r = imfilter(label,[0,0,0;0,0,1;0,0,0],'replicate');
    label_ul = imfilter(label,[1,0,0;0,0,0;0,0,0],'replicate');
    label_ur = imfilter(label,[0,0,1;0,0,0;0,0,0],'replicate');
    label_dl = imfilter(label,[0,0,0;0,0,0;1,0,0],'replicate');
    label_dr = imfilter(label,[0,0,0;0,0,0;0,0,1],'replicate');
    p_c = zeros(cluster_num,size(label,1)*size(label,2));
    % �������ص�8�����ǩ�����ÿһ�����ͬ����
    for i = 1:cluster_num
        label_i = i * ones(size(label));
        temp = ~(label_i - label_u) + ~(label_i - label_d) + ...
            ~(label_i - label_l) + ~(label_i - label_r) + ...
            ~(label_i - label_ul) + ~(label_i - label_ur) + ...
            ~(label_i - label_dl) +~(label_i - label_dr);
        p_c(i,:) = temp(:)/8;%�������
    end
    p_c(p_c == 0) = 0.001;%��ֹ����0
    %---------------������Ȼ����----------------
    mu = zeros(1,cluster_num);
    sigma = zeros(1,cluster_num);
    %���ÿһ��ĵĸ�˹����--��ֵ����
    for i = 1:cluster_num
        index = label == i;%�ҵ�ÿһ��ĵ�
        data_c = double(img(index));
        mu(i) = mean(data_c);%��ֵ
        sigma(i) = var(data_c);%����
    end
    p_sc = zeros(cluster_num,size(label,1)*size(label,2));
%     for i = 1:size(img,1)*size(img,2)
%         for j = 1:cluster_num
%             p_sc(j,i) = 1/sqrt(2*pi*sigma(j))*...
%               exp(-(img(i)-mu(j))^2/2/sigma(j));
%         end
%     end
    %------����ÿ�����ص�����ÿһ�����Ȼ����--------
    %------Ϊ�˼������㣬��ѭ����Ϊ����һ�����--------
    for j = 1:cluster_num
        MU = repmat(mu(j),size(img,1)*size(img,2),1);
        p_sc(j,:) = 1/sqrt(2*pi*sigma(j))*...
            exp(-(double(img(:))-MU).^2/2/sigma(j));
    end 
    %�ҵ�����һ�����������Ϊ��ǩ��ȡ������ֵֹ̫С
    [~,label] = max(log(p_c) + log(p_sc));
    %�Ĵ�С������ʾ
    label = reshape(label,size(img));
    iter = iter + 1;
end

m = numel(label);
x = length(find(label==1));
y = min(x,m-x);

% Roberts����
% BW1 = edge(label,'Roberts',0.04);
% g1 = length(find(BW1==1))/2;
% h1 = y/g1;

% Sobel����
% BW2 = edge(label,'Sobel',0.04);
% g2 = length(find(BW2==1))/2;
% h2 = y/g2;

% Prewitt����
BW3 = edge(label,'Prewitt',0.04);
g3 = length(find(BW3==1))/2;
h3 = y/g3;


% LOG����
% BW4 = edge(label,'LOG',0.004);
% g4 = length(find(BW4==1))/2;
% h4 = y/g4;

% Canny����
% BW5 = edge(label,'Canny',0.04);
% g5 = length(find(BW5==1))/2;
% h5 = y/g5;

% Sobel����
% BW6 = edge(label,'Sobel',0.04);
% g6 = length(find(BW6==1))/2;
% h6 = y/g6

% ��ʾ
global hh1 hh2 hh3;

str = ['����Ѫ�ܿ�ȣ�',num2str(h3),'����'];

hh1 = subplot(2,2,[1,2]);
imshow(cutimage)
title({str;'��ȡ��ͼƬ'})

hh2 = subplot(2,2,3);
imshow(label,[])
title('�ָ��ͼ��')

hh3 = subplot(2,2,4);
imshow(BW3)
title(' ��Ե��� ')
end