function [] = Thinning(I)
SKL = I;
iterate = true;
%%Skeletonization algorithm
while iterate
    %%Store the current state of the skeleton
    SKL_old = SKL;

    %%Initialize SKEL_del matrix to zeros
    SKL_del = zeros(size(SKL));

    %%Iterate over each pixel of the image
    for m = 2:size(SKL, 1)-1
        for n = 2:size(SKL, 2)-1
            %%Get the 8-pixel neighborhood around the current pixel
            P = [SKL(m,n) SKL(m-1,n) SKL(m-1,n+1) SKL(m,n+1) SKL(m+1,n+1) SKL(m+1,n) SKL(m+1,n-1) SKL(m,n-1) SKL(m-1,n-1) SKL(m-1,n)];
            %%Step 1
            %%Define Conditions
            a = (sum(P(2:end-1)) <= 6 && sum(P(2:end-1)) >= 2);
            %%b if T = 1;
            c = P(2) * P(4) * P(6);
            d = P(4) * P(6) * P(8);
            %%Check if the pixel satisfies the conditions for deletion as seen in equation a,b,c and d
            if c == 0 && d == 0 && a
                T = 0;
                for j = 2:size(P(:),1)-1
                    if P(j) == 0 && P(j+1)==1
                        T = T+1;
                    end
                end
                if (T==1)
                    SKL_del(m,n)=1;
                end
            end
        end
    end

    %%Delete the marked pixels from the skeleton
    SKL(SKL_del==1) = 0;

    %%Repeat the same process with a different set of conditions
    SKL_del = zeros(size(SKL));
    for m=2:size(SKL,1)-1
        for n = 2:size(SKL,2)-1
            P = [SKL(m,n) SKL(m-1,n) SKL(m-1,n+1) SKL(m,n+1) SKL(m+1,n+1) SKL(m+1,n) SKL(m+1,n-1) SKL(m,n-1) SKL(m-1,n-1) SKL(m-1,n)];
            %%Step 2
            %%Check if the pixel satisfies the conditions for deletion as seen in equation a,b,c1 and d1
            %%Define the conditions for deletion.
            a = (sum(P(2:end-1)) <= 6 && sum(P(2:end-1)) >= 2);
            %%b if T = 1;
            c1 = P(2) * P(4) * P(8);
            d1 = P(2) * P(6) * P(8);
            if c1 == 0 && d1 == 0 && a
                T = 0;
                for j = 2:size(P(:),1)-1
                    if P(j) == 0 && P(j+1)==1
                        T = T+1;
                    end
                end
                if (T==1) %b Condition
                    SKL_del(m,n)=1;
                end
            end
        end
    end
    SKL(SKL_del==1) = 0;



    %%If the skeleton did not change, set the iterate flag to false
    if isequal(SKL_old, SKL)
        iterate = false;
    end
end
figure,imshow((SKL),[]);
title('Skeleton');
end