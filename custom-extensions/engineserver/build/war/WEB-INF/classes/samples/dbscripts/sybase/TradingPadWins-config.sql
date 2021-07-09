DELETE trd_win_cl_config where config_name = 'TradingPadWins'
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FX','ALL','tradingPadNew.fx.TPCompTradeFX')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FXForward','ALL','tradingPadNew.fx.TPCompTradeFXFwd')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FXNDF','ALL','tradingPadNew.fx.TPCompTradeFXNDF')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FXOptionForward','ALL','tradingPadNew.fx.TPCompTradeFXOptFwd')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FXTakeUp','ALL','tradingPadNew.fx.TPCompTradeFXTakeUp')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FXTTM','ALL','tradingPadNew.fx.TPCompTradeFXTTM')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FXSpotReserve','ALL','tradingPadNew.fx.TPCompTradeFXSpotRes')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FXSwap','ALL','tradingPadNew.fx.TPCompTradeFXSwap')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FXOption','ALL','tradingPadNew.fxOpt.TPCompTradeFXOpt')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FXOptionStrip','ALL','tradingPadNew.fxOpt.TPCompTradeFXOptStrip')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FXCompoundOption','ALL','tradingPadNew.fxOpt.TPCompTradeCompoundFXOpt')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','SimpleMM','ALL','tradingPadNew.mm.TPCompTradeSimpleMM')
go

INSERT INTO trd_win_cl_config (config_name,product_type,product_sub_type,class_name) VALUES('TradingPadWins','FutureFX','ALL','tradingPadNew.futureFX.TPCompTradeFutureFX')
go
