DELETE FROM ers_credit_measure_config WHERE identifier like 'FXSwap.%' AND measure = 'Notional'
GO
DELETE FROM ers_credit_measure_config WHERE identifier like 'FXNDFSwap.%' AND measure = 'Notional'
GO