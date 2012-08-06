function [unit_vectors, charge, xv, yv, zv] = process_chgcar(path)

file = [path '\CHGCAR']

fid=fopen(file);
unit_vectors = [];
coord_list = [];
restricted = [];
counter = 0;

fgetl(fid); % skip some lines
fgetl(fid);

%% build the unit cell vectors
for i=1:3
    temp = fgetl(fid);
    [v1, temp] = strtok(temp); %x
    [v2, temp] = strtok(temp); %y
    [v3, temp] = strtok(temp); %z
    unit_vectors = [unit_vectors; str2num(v1) str2num(v2) str2num(v3)];
end

fgetl(fid);
n = sum(str2num(fgetl(fid)));

for i = 1:(n+2)
    fgetl(fid);
end

temp = fgetl(fid)
[nx, temp] = strtok(temp); %x
[ny, temp] = strtok(temp); %y
[nz, temp] = strtok(temp); %z
Nx = str2num(nx)
Ny = str2num(ny)
Nz = str2num(nz)
N = Nx*Ny*Nz/5;
N*5
dx = unit_vectors(1,:)/Nx;
dy = unit_vectors(2,:)/Ny;
dz = unit_vectors(3,:)/Nz;

%% build vectors
xv = [];
yv = [];
zv = [];
ref = [0,0,0];
temp = ref;
for x=1:Nx
    temp = temp + dx;
    xv = [xv;temp]
end
temp = ref;
for y=1:Ny
    temp = temp + dy;
    yv = [yv;temp]
end
temp = ref;
for z=1:Nz
    temp = temp + dz;
    zv = [zv;temp]
end

charge = zeros(N*5,4); 
counter =0;
temp = ref;

%% build mesh
for x=1:Nx
    for y=1:Ny
        for z = 1:Nz
            counter = counter+1;
            charge(counter,1:3) = temp;
            temp = temp + dz;
        end
        temp = temp + dy;
        temp = temp - Nz*dz;
    end
    temp = temp + dx;
    temp = temp - Ny*dy;
end
% 
% counter = 0;
% for i = 1:N
%     temp = fgetl(fid);
%     for j= 1:5
%           counter = counter + 1
%           [c,temp] = strtok(temp);
%           charge(counter,4) = str2num(c);   
%     end
% end

end