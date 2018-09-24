% H = compute_homography(points1, points2)
%
% Method: Determines the mapping H * points1 = points2
% 
% Input:  points1, points2 are of the form (3,n) with 
%         n is the number of points.
%         The points should be normalized for 
%         better performance.
% 
% Output: H 3x3 matrix 
%

%-------------------------
% TODO: FILL IN THIS PART
function H = compute_homography( points1, points2 )
[~,n] = size(points1);
count = 0;
if all(all(points1==points2==1)==1)==0 % points1 and points2 are not equal
    for i = 1:n
        if isnan(points2(1,i)) == 1
            count=count+1;
            if count == 1
                p_start = i;
            end
            if isnan(points2(1,i+1)) == 0 || i+1 == n
                p_end = i+1;
                break
            end
        end
    end
    points1(:,p_start:p_end) = [];
    points2(:,p_start:p_end) = [];
    [~,n] = size(points1);
end
Q = zeros(2*n, 9);
for i = 1:n
        alpha=[points2(1,i) points2(2,i) points2(3,i) 0 0 0 -points2(1,i)*points1(1,i) -points2(2,i)*points1(1,i) -points1(1,i)];
        beta=[0 0 0 points2(1,i) points2(2,i) points2(3,i) -points2(1,i)*points1(2,i) -points2(2,i)*points1(2,i) -points1(2,i)];
    Q(i,:)=alpha;
    Q(n+i,:)=beta;
end
[U,S,V] = svd(Q);
h = V(:,end);
H = reshape(h,[3,3])';
%% A second method
% function H = compute_homography( points1, points2 )
% [~,n] = size(points1);
% Q = zeros(2*n, 9);
% for i = 1:n
%     if isnan(points2(1,i)) == 1
%         alpha = [NaN NaN NaN NaN NaN NaN NaN NaN NaN];
%         beta = [NaN NaN NaN NaN NaN NaN NaN NaN NaN];
%     else
%         alpha=[points2(1,i) points2(2,i) points2(3,i) 0 0 0 -points2(1,i)*points1(1,i) -points2(2,i)*points1(1,i) -points1(1,i)];
%         beta=[0 0 0 points2(1,i) points2(2,i) points2(3,i) -points2(1,i)*points1(2,i) -points2(2,i)*points1(2,i) -points1(2,i)];
%     end
%     Q(i,:)=alpha;
%     Q(n+i,:)=beta;
% end
% c = [];
% for i = 1:2*n
%     if isnan(Q(i,1)) == 1
%         c = [c i];
%     end
% end
% Q(c,:) = [];
% [U,S,V] = svd(Q);
% h = V(:,end);
% H = reshape(h,[3,3])';
