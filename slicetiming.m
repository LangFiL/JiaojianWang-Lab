
% SliceTime(2000,30,4.5,29,80)
% SliceTime(1500,25,4,29,70)
% function ST= SliceTime(TR,TE,SliceThickness,NumberOfSlices,FlipAngle)
%     ST = TR/(NumberOfSlices*TE)+(SliceThickness/2)*tan(FlipAngle);
%     
% end
slicetime(2,38,true,false)
function slicetime(TRsec, nSlices, isAscending, isSequential, DelayBetweenVolumesSec)
%compute slice timing
% TRsec : sampling rate (TR) in seconds
% nSlices: number of slices in each 3D volume
% isAscending: ascending (true) or descending (false) order
% isSequential: interleaved (false) or sequential (true) order
% DelayBetweenVolumesSec: pause between final slice of volume and start of next
%Examples
% sliceTime(2.0, 10, true, true); %ascending, sequential
% sliceTime(2.0, 10, false, true); %descending, sequential
% sliceTime(2.0, 10, true, false); %ascending, interleaved
% sliceTime(2.0, 10, false, false); %descending, interleaved
% sliceTime(3.0, 10, true, true, 1.0); %ascending, sequential, sparse


if ~exist('DelayBetweenVolumesSec', 'var')
    DelayBetweenVolumesSec = 0; %continuous acquisition
end

TA = (TRsec - DelayBetweenVolumesSec) / nSlices; %assumes no temporal gap between volumes
bidsSliceTiming=[0:TA:TRsec-TA]; %ascending
if ~isAscending %descending
   bidsSliceTiming = flip(bidsSliceTiming);
end
if ~isSequential %interleaved
    if ~mod(nSlices,2)
        fprintf('Timings for Philips or GE. Siemens volume with even number of slices differs https://www.mccauslandcenter.sc.edu/crnl/tools/stc)\n');
    end
    order = [1:2:nSlices 2:2:nSlices];
    bidsSliceTiming(order) = bidsSliceTiming;
end
%report results
fprintf('	"SliceTiming": [\n');
for i = 1 : nSlices
    fprintf('		%.5f', bidsSliceTiming(i));
    if (i < nSlices)
        fprintf(',\n');
    else
        fprintf('	],\n');
    end  
end
end