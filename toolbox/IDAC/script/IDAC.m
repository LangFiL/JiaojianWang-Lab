function idac_data=IDAC(path,mask_path,interval,numWorkers)

%input:distance interval h, for example h=[5,10]


img = load_untouch_nii(path).img;


mask = load_untouch_nii(mask_path).img;

images = img.*mask;


maxX = size(images, 1);
maxY = size(images, 2);
maxZ = size(images, 3);
maxT = size(images, 4);

idac_data = zeros(maxX, maxY, maxZ);

if isempty(gcp('nocreate'))
    parpool('local', numWorkers);
end

parfor x = 1:maxX

    for y = 1:maxY
        for z = 1:maxZ
            if ~all(images(x, y, z, :) == 0)
                 point = countIntegerPointsInSphere([x,y,z],interval);
                point(point(:,1) < 1 | point(:,1) > maxX | ...
                    point(:,2) > maxY | ...
                    point(:,3) > maxZ | ...
                    point(:,2) < 1 | point(:,3) < 1,:) = [];
                data = zeros(size(point,1),maxT);
                for p = 1:size(point,1)
                    data(p,:) = reshape(images(point(p,1),point(p,2),point(p,3),:),[],1);
                end
                start_voxel = reshape(images(x,y,z,:),[],1);
                correlation = corr(start_voxel,data');
                z_value = sqrt(size(images,4)-3)/2*log((1+correlation)./(1-correlation));
                z_value(isnan(z_value)) = [];
                idac_data(x,y,z) = mean(z_value);
            end
        end
    end
end


% Close the parallel pool when done
delete(gcp);

end
