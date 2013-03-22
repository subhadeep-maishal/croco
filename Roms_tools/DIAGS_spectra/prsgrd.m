function [Px,Py]=prsgrd(rho,z_w,z_r,pm,pn)
%============================================================
%
% pressure gradient in m2/s2 (dPx/rho0)
%
%============================================================

[Lr,Mr,N]=size(rho);
Lu=Lr-1;Mu=Mr;
Mv=Mr-1;Lv=Lr;
Px=zeros(Lu,Mu,N);
Py=zeros(Lv,Mv,N);
Pxtmp=zeros(Lu,Mu);
Pytmp=zeros(Lv,Mv);

g=9.8; rho0=1025; rhoref=1000;
cff=0.5*g/rho0;
cff1= rhoref.*g/rho0;
rho=rho-rhoref;

Pxtmp(:,:)=cff*(rho(2:end,:,N)  -rho(1:end-1,:,N)) ...
            .*( z_w(2:end,:,N+1)+z_w(1:end-1,:,N+1) ...
               -z_r(2:end,:,N)  -z_r(1:end-1,:,N)) ...
    +(cff1+cff*(rho(2:end,:,N)  +rho(1:end-1,:,N))) ...
             .*(z_w(2:end,:,N+1)-z_w(1:end-1,:,N+1));
Pxtmp(:,:)=0.5*Pxtmp(:,:).*(pm(2:end,:)+pm(1:end-1,:));
Px(:,:,N)=-Pxtmp(:,:);
for k=N-1:-1:1
  Pxtmp(:,:)=Pxtmp(:,:)+0.5*cff*( ...
                               ( rho(2:end,:,k+1)-rho(1:end-1,:,k+1) ...
                               + rho(2:end,:,k  )-rho(1:end-1,:,k  )) ...
                             .*( z_r(2:end,:,k+1)+z_r(1:end-1,:,k+1) ...
                                -z_r(2:end,:,k  )-z_r(1:end-1,:,k  )) ...
                              -( rho(2:end,:,k+1)+rho(1:end-1,:,k+1) ...
                                -rho(2:end,:,k  )-rho(1:end-1,:,k  )) ...
                             .*( z_r(2:end,:,k+1)-z_r(1:end-1,:,k+1) ...
                                +z_r(2:end,:,k  )-z_r(1:end-1,:,k  )) ...
                                );
  Pxtmp(:,:)=0.5*Pxtmp(:,:).*(pm(2:end,:)+pm(1:end-1,:));
  Px(:,:,k)=-Pxtmp(:,:);
end

Pytmp(:,:)=cff*(rho(:,2:end,N)  -rho(:,1:end-1,N)) ...
            .*( z_w(:,2:end,N+1)+z_w(:,1:end-1,N+1) ...
               -z_r(:,2:end,N)  -z_r(:,1:end-1,N)) ...
    +(cff1+cff*(rho(:,2:end,N)  +rho(:,1:end-1,N))) ...
             .*(z_w(:,2:end,N+1)-z_w(:,1:end-1,N+1));
Pytmp(:,:)=Pytmp(:,:).*(pn(:,2:end)+pn(:,1:end-1));
Py(:,:,N)=-Pytmp(:,:);
for k=N-1:-1:1
  Pytmp(:,:)=Pytmp(:,:)+0.5*cff*( ...
                               ( rho(:,2:end,k+1)-rho(:,1:end-1,k+1) ...
                               + rho(:,2:end,k  )-rho(:,1:end-1,k  )) ...
                             .*( z_r(:,2:end,k+1)+z_r(:,1:end-1,k+1) ...
                                -z_r(:,2:end,k  )-z_r(:,1:end-1,k  )) ...
                              -( rho(:,2:end,k+1)+rho(:,1:end-1,k+1) ...
                                -rho(:,2:end,k  )-rho(:,1:end-1,k  )) ...
                             .*( z_r(:,2:end,k+1)-z_r(:,1:end-1,k+1) ...
                                +z_r(:,2:end,k  )-z_r(:,1:end-1,k  )) ...
                                  ); 
  Pytmp(:,:)=Pytmp(:,:).*(pn(:,2:end)+pn(:,1:end-1));
  Py(:,:,k)=-Pytmp(:,:);
end

%Px=perm(u2rho(perm(squeeze(Px(:,:,1))));
%Py=perm(v2rho(perm(squeeze(Py(:,:,1))));

return

