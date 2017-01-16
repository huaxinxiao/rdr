function   [AA,g] = GraphCut(img)

[H,W,~] = size(img);
imm = double(img);
m1 = imm(:,:,1);
m2 = imm(:,:,2);
m3 = imm(:,:,3);
E  = edges4connected(H,W);
V  = 1./(1+sqrt((m1(E(:,1))-m1(E(:,2))).^2+(m2(E(:,1))-m2(E(:,2))).^2+(m3(E(:,1))-m3(E(:,2))).^2));
AA = 1000*sparse(E(:,1),E(:,2),0.3*V);
g  = fspecial('gauss', [5 5], sqrt(5));
