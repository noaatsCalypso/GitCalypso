sp_rename 'calypso_cache.cache_limit','cache_limit_bck'
go
sp_rename 'calypso_cache.limit','cache_limit'
go
alter table calypso_cache drop cache_limit_bck
go