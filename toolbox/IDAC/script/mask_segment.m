function mask_segment(mask_path,roi)
    info = load_untouch_nii(mask_path);
    img = info.img;
    img(img > 0 & img <= roi/2) = 1;
    img(img>roi/2) = 0;
    info.img = img;
    save_untouch_nii(info,'lh')
    
    info = load_untouch_nii(mask_path);
    img = info.img;
    img(img > 0 & img <= roi/2) = 0;
    img(img>roi/2) = 1;
    info.img = img;
    save_untouch_nii(info,'rh')
end
