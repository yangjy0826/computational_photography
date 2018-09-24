% cor.m
clear

% set model and image coordinates
load letter_f_and_similar

% 1 extract point features of model
xmod=x; % xmod
ymod=y; % ymod

% 2 for each ordered pair (ie basis) of point features do:
hashtable=cell(20); % hashtable where the model coordinates are hashed
for i1=1:max(size(xmod)) % bas1 index order number
    for i2=1:max(size(xmod)) % bas2 index order number
        if i1~=i2
            % a) compute the coordinates (u,v) of the remaining features
            ps0x=xmod(i1); % origin of the new coordinate system...
            ps0y=ymod(i1); % ...right between the base points
            psxx=xmod(i1)-xmod(i2); % x-axis of the new coordinate system
            psxy=ymod(i1)-ymod(i2); % x-axis of the new coordinate system
            psyx=psxy;
            psyy=-psxx;
            A=[psxx psyx; psxy psyy];
            Ainv=inv(A);
            for i3=1:max(size(xmod))
                if ~(i3==i1 | i3==i2)
                    x=xmod(i3);
                    y=ymod(i3);
                    uv=Ainv*[x-ps0x; y-ps0y];
                    u=uv(1);
                    v=uv(2);
                    uq=floor(u+.5);
                    vq=floor(v+.5);
                    % b) after a proper quantization, use the tuple as an index to a 2D hash table data structure,
                    %    and insert in the corresponding hash table bin the information (m,(basis)),
                    %    namely, the model number and the basis tuple which was used to determine (uq,vq)
                    hashtable{uq+10,vq+10}=[hashtable{uq+10,vq+10};i1,i2];
                end % if
            end % for i3
        end % if
    end % for i2
end % for i1
    

% 1 extract point features of image
ximg=xp'; % ximg
yimg=yp'; % yimg

votes=zeros(size(xmod,1),size(ximg,1));
    
% 2 for each ordered pair (ie basis) of point features do:
for i1=1:max(size(ximg))
    for i2=1:max(size(ximg))
        if i1~=i2
            % a) compute the coordinates (u,v) of the remaining features
            ps0x=ximg(i1);
            ps0y=yimg(i1);
            psxx=ximg(i1)-ximg(i2);
            psxy=yimg(i1)-yimg(i2);
            psyx=psxy;
            psyy=-psxx;
            A=[psxx psyx; psxy psyy];
            Ainv=inv(A);
            for i3=1:max(size(ximg))
                if ~(i3==i1 | i3==i2)
                    x=ximg(i3);
                    y=yimg(i3);
                    uv=Ainv*[x-ps0x; y-ps0y];
                    u=uv(1);
                    v=uv(2);
                    uq=floor(u+.5);
                    vq=floor(v+.5);
                    % b) after a proper quantization, use the tuple as an index to a 2D hash table data structure,
                    h=hashtable{uq+10,vq+10};
                    %    and vote for all the tuples at that index
                    n=size(h,1);
                    for l=1:n
                        %INSERT
                    end % for l
                end % if
            end % for i3
        end % if
    end % for i2
end % for i1
corpts=greedyalg(votes);

plot_elect(corpts,[ximg yimg ximg yimg],[xmod ymod xmod ymod],[],[],[],[])

figure
bar3(votes)
