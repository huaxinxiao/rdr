function [Z,E] = Ladmp(X,lambda,rho,DEBUG,Dic)

if (~exist('DEBUG','var'))
    DEBUG = 1;
end
if (~exist('Dic','var'))
    Dic = X;
end
if nargin < 3
    rho = 1.9;
end
if nargin < 2
    lambda = 0.1;
end

normfX = norm(X,'fro');
tol1 = 1e-3;%threshold for the error in constraint
tol2 = 1e-3;%threshold for the change in the solutions
[d,n] = size(X);
[~,atoms] = size(Dic);
maxIter = 100;

max_mu = 1e10;
norm2X = norm(X,2);
% mu = 1e2*tol2;
mu = min(d,n)*tol2;
eta = norm2X*norm2X*1.02;%eta needs to be larger than ||X||_2^2, but need not be too large.

%% Initializing optimization variables
% intialize
E = sparse(d,n);
Y = zeros(d,n);
Z = zeros(atoms, n)'; %Z = Z'
XZ = zeros(d, n); %XZ = Dic*Z';

%% Start main loop
iter = 0;

while iter<maxIter
    iter = iter + 1;
    
    %copy E and Z to compute the change in the solutions
    Ek = E;
    Zk = Z;
    
    E = solve_F(X - XZ + Y/mu,lambda/mu);
    %E = solve_l11(X - XZ + Y/mu,lambda/mu);
    %E = solve_l2l1(X - XZ + Y/mu,lambda/mu); 
    %Z = solve_l2l1(Zk + (X' - XZ' - E' + Y'/mu) * Dic/eta,1/(mu*eta));
    Z = solve_l1l2(Zk + (X' - XZ' - E' + Y'/mu) * Dic/eta,1/(mu*eta));
    
    relChgZ = norm(Z - Zk,'fro')/normfX;
    relChgE = norm(E - Ek,'fro')/normfX;
    relChg = max(relChgZ,relChgE);

    XZ = Dic * Z';%introducing XZ to avoid computing X*Z multiple times, which has O(n^3) complexity.
    dY = X - XZ - E;
    recErr = norm(dY,'fro')/normfX;
    
    convergenced = recErr <tol1 && relChg < tol2;
    
    if DEBUG
        if iter==1 || mod(iter,50)==0 || convergenced
            disp(['iter ' num2str(iter) ',mu=' num2str(mu) ...
                ',relChg=' num2str(max(relChgZ,relChgE))...
                ',recErr=' num2str(recErr)]);
        end
    end
    if convergenced
%    if recErr <tol1 & mu*max(relChgZ,relChgE) < tol2 %this is the correct
%    stopping criteria. 
        break;
    else
        Y = Y + mu*dY;
        
        if mu*relChg < tol2
            mu = min(max_mu, mu*rho);
        end
    end
end
Z = Z';

function [E] = solve_l2l1(W,lambda)  %
n = size(W,2);
E = W;
for i=1:n
    E(:,i) = solve_l2(W(:,i),lambda);
end

function [E] = solve_l1l2(W,lambda)  %
n = size(W,1);
E = W;
for i=1:n
    E(i,:) = solve_l2(W(i,:),lambda);
end

function [x] = solve_l2(w,lambda)
% min lambda |x|_2 + |x-w|_2^2
nw = norm(w);
if nw>lambda
    x = (nw-lambda)*w/nw;
else
    x = zeros(length(w),1);
end

function E = solve_l11(temp_E,lambda)

E = max(temp_E - lambda, 0);
E = E + min(temp_E + lambda, 0);  %

function E = solve_F(M,lambda)
%E = lambda/(1+lambda).*M;
E = 1/(1+2*lambda).*M;

