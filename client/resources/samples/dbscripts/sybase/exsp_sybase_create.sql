
CREATE TABLE exsp_xcpn (
        product_id                      _Id  NOT NULL,
        leg_id                          _Id  NOT NULL,
        rate_func                       varchar(128),
        rng_acc_func                    varchar(128),
        rng_acc_ubnd_func               varchar(128),
        rng_acc_lbnd_func               varchar(128),
        upr_bnd_func                    varchar(128),
        upr_bnd_trg_func                varchar(128),
        lwr_bnd_func                    varchar(128),
        lwr_bnd_trg_func                varchar(128),
        conditional_func                varchar(128),
        rng_acc_enbld                   _Boolean,
        fxd_prds                        int,
        flow_id                         _Id NOT NULL,
        interpret_as_amount             _Boolean,
        rng_acc_upr_inc                 _Boolean,
        rng_acc_lwr_inc                 _Boolean,
        reset_cutoff                    int,
        rng_acc_method                  _ResetAveragingMethod,
        resetcutoffbusdayb              _Boolean,
        conditional_date                _Date,
        upr_bnd_exercise_type           VARCHAR(32),
        upr_bnd_flexi_num               int,
        upr_bnd_flexi_locked            _Boolean ,
        rate_upr_inc                    _Boolean DEFAULT 0,
        rate_lwr_inc                    _Boolean DEFAULT 0,
        reset_cutoff_holidays           _HolidayList,
        CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (product_id,leg_id,flow_id)
        )
go


CREATE TABLE product_exsp_note (
        product_id                      _Id  NOT NULL,
        redemption_date _Date,
                CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (product_id)
        )
go

CREATE TABLE product_exsp_extended_type (
        product_id                      _Id  NOT NULL,
        name                            _Name NOT NULL,
        CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (name))
go

CREATE TABLE exsp_variable_setting (
        product_id                      _Id  NOT NULL,
        var_name                        VARCHAR(32),
        var_setting                     VARCHAR(255),
        CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (product_id,var_name))
go

CREATE TABLE exsp_compute_config (
        product_id                      _Id  NOT NULL,
        compute_name                    _Name NOT NULL,
        compute_type                    _Name NOT NULL,
        compute_label                   _Name,
        compute_description             VARCHAR(255),
        product_override                _Boolean,
        trade_override                  _Boolean,
        visible                         _Boolean,
        sort_order                      int,
        restricted_list                 VARCHAR(255),
        default_value                   _Name,
        label                           VARCHAR(255),
        CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (product_id,compute_name))
go

CREATE TABLE exsp_pvar_override (
        product_id        _Id NOT NULL,
        pvar_name         varchar(32) NOT NULL,
        formula           varchar(128),
        CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (product_id,pvar_name))
go

CREATE TABLE exsp_qvar_override (
        product_id        _Id NOT NULL,
        qvar_name         varchar(32) NOT NULL,
        reset_days        int,
        reset_bus_lag_b   _Boolean,
        reset_in_arrear_b _Boolean,
        reset_holidays    _HolidayList,
        sample_freq       _FrequencyCode,
        day_count      _DaycountCode,
        CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (product_id,qvar_name))
go

CREATE TABLE exsp_type_mapping (
        product_id                      _Id  NOT NULL,
        product_class                   VARCHAR(255) NOT NULL,
        sub_type                        _Name NOT NULL,
        CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (product_id,product_class,sub_type))
go

CREATE TABLE exsp_product_variable (
        name                            varchar(32) NOT NULL,
        class_name                      varchar(255) NOT NULL ,
        version_num                     int NULL,
        pvar_type                       varchar(50),
        subject                         varchar(128),
        description                     varchar(255),
        CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (name,class_name))
go

CREATE TABLE exsp_quotable_variable (
        name                            varchar(32) NOT NULL,
        version_num                     int NULL,
        qvar_type                       varchar(50),
        currency                        _CurrencyCode,
        quotable_name                   _Name,
        rate_index_tenor                _Tenor,
        rate_index_source               _Name NULL,
        currency2                       _CurrencyCode NULL,
        sample_freq                     _FrequencyCode,
        product_id                      _Id,
        CONSTRAINT ct_primarykey PRIMARY KEY CLUSTERED
        (name),
        CONSTRAINT ct_qvar_unique UNIQUE NONCLUSTERED(currency,quotable_name,
                                                  rate_index_tenor,
                                                  rate_index_source,
                                                  sample_freq)
)
go



