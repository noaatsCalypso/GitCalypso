IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_job') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_job 
SET creation_user = CASE WHEN m.user_info not in (select m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_job t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_job') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_job set 
creation_date = CASE WHEN m.date_info not in (select m.date_info FROM entity_modif_metadata m )
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
END
from ersc_job t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_job') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_job set 
last_update_user = CASE WHEN m.user_info not in (SELECT m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_job t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_job') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_job set 
last_update_date = CASE WHEN m.date_info not in (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
END
from ersc_job t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_rule 
SET creation_user = CASE WHEN m.user_info not in (select m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_rule t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_rule set 
creation_date = CASE WHEN m.date_info not in (select m.date_info FROM entity_modif_metadata m )
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
END
from ersc_rule t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_rule set 
last_update_user = CASE WHEN m.user_info not in (SELECT m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_rule t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('UPDATE ersc_rule set 
last_update_date = CASE WHEN m.date_info not in (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
END
from ersc_rule t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_check') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_check 
SET creation_user = CASE WHEN m.user_info not in (select m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_rule_check t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_check') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_check set 
creation_date = CASE WHEN m.date_info not in (select m.date_info FROM entity_modif_metadata m )
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
END
from ersc_rule_check t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_check') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_check set 
last_update_user = CASE WHEN m.user_info not in (SELECT m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_rule_check t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_check') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_check set 
last_update_date = CASE WHEN m.date_info not in (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
END
from ersc_rule_check t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO


IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_check_result')
BEGIN
EXEC('
UPDATE ersc_rule_check_result SET 
creation_user = ''00112233-4455-6677-8899-aabbccddeeff'',
creation_date = 0,
last_update_user = ''00112233-4455-6677-8899-aabbccddeeff'',
last_update_date = 0')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_portfolio') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_portfolio 
SET creation_user = CASE WHEN m.user_info not in (select m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_rule_portfolio t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_portfolio') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_portfolio set 
creation_date = CASE WHEN m.date_info not in (select m.date_info FROM entity_modif_metadata m )
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
END
from ersc_rule_portfolio t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_portfolio') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_portfolio set 
last_update_user = CASE WHEN m.user_info not in (SELECT m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_rule_portfolio t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_portfolio') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_portfolio set 
last_update_date = CASE WHEN m.date_info not in (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
END
from ersc_rule_portfolio t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_result') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_result 
SET creation_user = CASE WHEN m.user_info not in (select m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_rule_result t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_result') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_result set 
creation_date = CASE WHEN m.date_info not in (select m.date_info FROM entity_modif_metadata m )
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
END
from ersc_rule_result t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_result') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_result set 
last_update_user = CASE WHEN m.user_info not in (SELECT m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_rule_result t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_result') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_result set 
last_update_date = CASE WHEN m.date_info not in (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
END
from ersc_rule_result t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_data_revision') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_data_revision 
SET creation_user = CASE WHEN m.user_info not in (select m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_data_revision t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_data_revision') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_data_revision set 
creation_date = CASE WHEN m.date_info not in (select m.date_info FROM entity_modif_metadata m )
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
END
from ersc_data_revision t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_data_revision') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_data_revision set 
last_update_user = CASE WHEN m.user_info not in (SELECT m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_data_revision t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_data_revision') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_data_revision set 
last_update_date = CASE WHEN m.date_info not in (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
END
from ersc_data_revision t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_sanction_item') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_sanction_item 
SET creation_user = CASE WHEN m.user_info not in (select m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_sanction_item t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_sanction_item') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_sanction_item set 
creation_date = CASE WHEN m.date_info not in (select m.date_info FROM entity_modif_metadata m )
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
END
from ersc_sanction_item t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO


IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_sanction_item') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_sanction_item set 
last_update_user = CASE WHEN m.user_info not in (SELECT m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_sanction_item t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_sanction_item') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_sanction_item set 
last_update_date = CASE WHEN m.date_info not in (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
END
from ersc_sanction_item t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_result_trade') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_result_trade 
SET creation_user = CASE WHEN m.user_info not in (select m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_rule_result_trade t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_result_trade') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_result_trade set 
creation_date = CASE WHEN m.date_info not in (select m.date_info FROM entity_modif_metadata m )
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.created_meta_data_id)
END
from ersc_rule_result_trade t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_result_trade') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_result_trade set 
last_update_user = CASE WHEN m.user_info not in (SELECT m.user_info FROM entity_modif_metadata m )
THEN ''00112233-4455-6677-8899-aabbccddeeff''
ELSE (SELECT m.user_info FROM entity_modif_metadata m)
END
from ersc_rule_result_trade t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

IF EXISTS(SELECT 1 FROM sysobjects WHERE name='ersc_rule_result_trade') AND EXISTS(SELECT 1 FROM sysobjects WHERE name='entity_modif_metadata')
BEGIN
EXEC('
UPDATE ersc_rule_result_trade set 
last_update_date = CASE WHEN m.date_info not in (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
THEN 0
ELSE (SELECT m.date_info FROM entity_modif_metadata m WHERE m.id = t.updated_meta_data_id)
END
from ersc_rule_result_trade t ,entity_modif_metadata m WHERE m.id = t.created_meta_data_id')
END
GO

