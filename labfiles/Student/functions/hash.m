% hash.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                    %%%
%%%   Preprocessing phase building the shape library   %%%
%%%                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set model coordinates
load letter_b
xymods{1}=[x y];
load letter_d
xymods{2}=[x y];
load letter_f
xymods{3}=[x y];
hashtable=cell(300); % 300x300 hashtable for the affine coordinates of the different models
% For each stored model shape do:
for M=1:3; % models F, B and D
    xymod=xymods{M};
    xmod=xymod(:,1);
    ymod=xymod(:,2);
    nofpts=size(xmod,1); % number of model points
    % 1.Select all triplets of points pi,pk,pl
    for i=1:nofpts % base1 index order number
        for k=1:nofpts % base2 index order number
            for l=1:nofpts % base3 index order number
                if i~=k & i~=l & k~=l % i,k,l distinct
                    x1=xmod(i);
                    x2=xmod(k);
                    x3=xmod(l);
                    y1=ymod(i);
                    y2=ymod(k);
                    y3=ymod(l);
                    % the base points cannot be colinear or close to colinear
                    if ~colinear(x1,y1,x2,y2,x3,y3);
                        % 2.for every point pn in the current model shape:
                        for n=1:nofpts
                            if ~(n==i | n==k | n==l) % don't choose any of the basis points
                                xn=xmod(n);
                                yn=ymod(n);
                                % (a) Compute the affine coordinate a,b in the basis pi,pk,pl
                                [a,b]=affine(xn,yn,x1,y1,x2,y2,x3,y3);
                                % (b) Quantize the values of a,b into a set of discrete values aq,bq
                                aq=floor(5*a+.5);
                                bq=floor(5*b+.5);
                                % (c) Use the discrete values aq,bq as indexes into a 2D array.
                                %     In this 2D array, store (1) The model M and (2) the points i,j,k
                                hashtable{aq+150,bq+150}=[hashtable{aq+150,bq+150};M,i,k,l]; % +150 to makes all indices >0
                            end % if ~(n==i | n==k | n==l)
                        end % for n
                    end % if ~colinear
                end % if i~=k & i~=l & k~=l
            end % for l
        end % for k
    end % for i
end % for M



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                    %%%
%%%   Recognition phase                                %%%
%%%                                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set image coordinates
load letter_b_oblique
xyimg=[x y];
ximg=xyimg(:,1);
yimg=xyimg(:,2);
x=xyimg(:,1);
y=xyimg(:,2);
nofimgpts=size(x,1); % number of image points
modelfound=0; % boolean that indicates if a corresponding model has been found
alltri=nchoosek(1:nofimgpts,3); % All combinations of different triplets
cnttri=0; % counter for the triplets
while ~modelfound
    cnttri=cnttri+1; % increase the counter for the triplets
    % 1.Choose an arbitrary triplet of points pi,pk,pl
    i=alltri(cnttri,1);
    k=alltri(cnttri,2);
    l=alltri(cnttri,3);
    x1=x(i);
    x2=x(k);
    x3=x(l);
    y1=y(i);
    y2=y(k);
    y3=y(l);
    % the base points cannot be colinear
    if ~colinear(x1,y1,x2,y2,x3,y3);
        % 2.for every point pn in the image shape:
        maxnofpts=max([size(xymods{1}) size(xymods{2}) size(xymods{3})]); % the number of points of the biggest model
        modvot=zeros(3,maxnofpts,maxnofpts,maxnofpts); % model votes: 3 models with a triplet each
        for n=1:max(size(ximg))
            if ~(n==i | n==k | n==l) % don't choose any of the basis points
                xn=ximg(n);
                yn=yimg(n);
                % (a) Compute the affine coordinate a,b in the basis pi,pk,pl
                [a,b]=affine(xn,yn,x1,y1,x2,y2,x3,y3);
                % (b) Quantize the values of a,b into a set of discrete values aq,bq
                aq=floor(5*a+.5);
                bq=floor(5*b+.5);
                % (c) Use the discrete values aq,bq as indexes into the 2D array defined in the preprocessing phase.
                % (d) This entry contains triplets of points for each model as descrbibed above.
                tri=hashtable{aq+150,bq+150}; % +100 makes the indices >0
                %     All these triplets and models are given a vote.
                %    and vote for all the tuples at that index
                noftri=size(tri,1); % number of triplets
                for trii=1:noftri % triplet index
                    %INSERT code for voting
                end % for trii
            end % if
        end % for n
        % 3 This will result in all point triplets in all models having a number of votes.
        %   By thresholding this number we obtain triplet candidates that
        %   correspond to the chosen points pi,pk,pl
        thr=5; % threshold value
        abovethrind=find(modvot>=thr); % the indices of the modvot entries above threshold
        %   Go thru the triplets.
        cnt=0; % counter
        while cnt<size(abovethrind,1) & ~modelfound
            % Increase the counter
            cnt=cnt+1;
            % Pick the cnt:st abovethri in the list of abovethrind
            abovethri=abovethrind(cnt);
            % Get the model number and the triplet
            [modnumber,modi,modk,modl] = ind2sub(size(modvot),abovethri);
            xymod=xymods{modnumber};
            xmod=xymod(:,1);
            ymod=xymod(:,2);
            xp1=xmod(modi); %x'1: see formula in lecture notes
            yp1=ymod(modi); %y'1
            xp2=xmod(modk); %x'2
            yp2=ymod(modk); %y'2
            xp3=xmod(modl); %x'3
            yp3=ymod(modl); %y'3
            % Make the transform of the image,
            % fitting the image triplet to the model triplet
            xp=[]; % The list of transformed x coordinates
            yp=[]; % The list of transformed y coordinates
            % For each image point
            for i=1:size(x,1)
                % Calculate its affine coordinates
                [a,b]=affine(x(i),y(i),x1,y1,x2,y2,x3,y3);
                % Calculate the new cartesian coordinates
                xpi=%INSERT
                ypi=%INSERT
                % Add it to the list
                xp=[xp; xpi];
                yp=[yp; ypi];
            end
            % Verify the correctness, by %INSERT
            xdiff=xmod*ones(1,size(xp,1))-ones(size(xmod,1),1)*xp';
            ydiff=ymod*ones(1,size(yp,1))-ones(size(ymod,1),1)*yp';
            distm=sqrt(xdiff.*xdiff+ydiff.*ydiff);
            if max(min(distm'))<7 & max(min(distm))<7
                modelfound=1;
                % Plot the image transformed to the model
                set(figure,'Color','white');
                plot(xmod,ymod,'o');
                hold on
                plot(xp,yp,'rx');
                axis equal
                axis off
		
		
		                % Save the figure for demo
                saveas(1,'bb','fig');
                

                % Transform B to the best D triplet
                dmodvot=modvot(2,:,:,:);
                [yyy,dind]=max(dmodvot(:)); % the index of the modvot for max entry
                abovethri=dind;
                % Get the triplet
                [modnumber,modi,modk,modl] = ind2sub(size(dmodvot),abovethri);
                xymod=xymods{2};
                xmod=xymod(:,1);
                ymod=xymod(:,2);
                xp1=xmod(modi); %x'1: see formula in lecture notes
                yp1=ymod(modi); %y'1
                xp2=xmod(modk); %x'2
                yp2=ymod(modk); %y'2
                xp3=xmod(modl); %x'3
                yp3=ymod(modl); %y'3
                % Make the transform of the image,
                % fitting the image triplet to the model triplet
                xp=[]; % The list of transformed x coordinates
                yp=[]; % The list of transformed y coordinates
                % For each image point
                for i=1:size(x,1)
                    % Calculate its affine coordinates
                    [a,b]=affine(x(i),y(i),x1,y1,x2,y2,x3,y3);
                    % Calculate the new cartesian coordinates
                    xp_=a*(xp2-xp1)+b*(xp3-xp1)+xp1;
                    yp_=a*(yp2-yp1)+b*(yp3-yp1)+yp1;
                    % Add it to the list
                    xp=[xp; xp_];
                    yp=[yp; yp_];
                end
                
                
                
                % Plot the image transformed to the D model
                set(figure,'Color','white');
                plot(xmod,ymod,'o');
                hold on
                plot(xp,yp,'rx');
                axis equal
                axis off
                % Save the figure for demo
                saveas(1,'bd','fig');
	    
                
                % Transform B to the best D triplet
                dmodvot=modvot(3,:,:,:);
                [yyy,dind]=max(dmodvot(:)); % the index of the modvot for max entry
                abovethri=dind;
                % Get the triplet
                [modnumber,modi,modk,modl] = ind2sub(size(dmodvot),abovethri);
                xymod=xymods{3};
                xmod=xymod(:,1);
                ymod=xymod(:,2);
                xp1=xmod(modi); %x'1: see formula in lecture notes
                yp1=ymod(modi); %y'1
                xp2=xmod(modk); %x'2
                yp2=ymod(modk); %y'2
                xp3=xmod(modl); %x'3
                yp3=ymod(modl); %y'3
                % Make the transform of the image,
                % fitting the image triplet to the model triplet
                xp=[]; % The list of transformed x coordinates
                yp=[]; % The list of transformed y coordinates
                % For each image point
                for i=1:size(x,1)
                    % Calculate its affine coordinates
                    [a,b]=affine(x(i),y(i),x1,y1,x2,y2,x3,y3);
                    % Calculate the new cartesian coordinates
                    xp_=a*(xp2-xp1)+b*(xp3-xp1)+xp1;
                    yp_=a*(yp2-yp1)+b*(yp3-yp1)+yp1;
                    % Add it to the list
                    xp=[xp; xp_];
                    yp=[yp; yp_];
                end
                

                
                % Plot the image transformed to the F model
                set(figure,'Color','white');
                plot(xmod,ymod,'o');
                hold on
                plot(xp,yp,'rx');
                axis equal
                axis off
                % Save the figure for demo
                saveas(1,'bf','fig');
	    end
        end % while cnt
    end % if ~colinear
end %while
