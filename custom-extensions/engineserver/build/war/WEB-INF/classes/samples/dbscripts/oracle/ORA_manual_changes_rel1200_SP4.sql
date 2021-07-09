alter table VOL_SURFACE_POINT_TYPE_SWAP drop primary key
;
alter table VOL_SURFACE_POINT_TYPE_SWAP add constraint pk_vol_surface_pt_ty_sw1 primary key (vol_surface_id,vol_surface_date)
;
