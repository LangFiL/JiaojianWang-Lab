clear;clc



mesh_file = 'Schaefer2018_600Parcels_7Networks_order_FSLMNI152_2mm.nii.gz'; %choose the mask file
roi = 600; % the region of interesting
voxel = 2; % the voxel size
interval = [5,10]./voxel; % set the interval
numWorkers = 40; % Set the number of workers (threads) for parallel pool 
subject_bandpass_path = 'Filtered_4DVolume.nii'; % input subject file path


mask_segment(mesh_file,roi)
idac_data_lh = IDAC(subject_bandpass_path, 'lh.nii', interval);
idac_data_rh = IDAC(subject_bandpass_path, 'rh.nii', interval);
idac_data = idac_data_lh + idac_data_rh;

info = load_untouch_nii(mesh_file);
info.img = idac_data;
save_path = strcat(subjects_path,'/', ...
    subject_dir(subject).name,'/','func_IDAC');
if ~exist("save_path","dir")
    mkdir(save_path);
end


% save IDAC of subject
save_name = 'idac';
save_untouch_nii(info,[save_path '/' save_name])



