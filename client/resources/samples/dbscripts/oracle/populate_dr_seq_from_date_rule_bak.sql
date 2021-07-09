/* This script must be run to fix any issues with the date_rule upgrade that
 * was introduced as part of BZ 59837. When the Upgrade_1008_to_1009.sql ran,
 * since the columns were not ordered correctly and because the wrong case for
 * 'none' was used, the columns in date_rule_in_seq was not populated.
 * 
 * However the previous date_rule table was backed up to date_rule_bak.
 * 
 * So, the following commands perform the upgrade again from date_rule_bak.
 *
 * After the initial "insert into" statement completes, 2 additional update
 * statements are executed to:
 * 1) set date_rule_in_seq.is_date = '1' if tenor_type = '[Dates]'
 * 2) set seq_number to correct index of the date rule in the original
 * comma-separated string (see date_rule_bak.date_rules_in_seq)
 */
/* BZ 59837 */
/* create a new table to hold the date rule in sequence mapping */
/* if this fails because table already exists, it is ok */
create table date_rule_in_seq
(
  date_rule_id    integer,
  seq_number      integer,
  num             integer,
  tenor_type      varchar2(64 byte),
  orig_date_rule  integer,
  is_date         integer)
;
alter table date_rule_in_seq add constraint date_rule_in_seq_pk primary key (date_rule_id, seq_number)
;

/* NOTE: this uses date_rule_bak */
/* lets split up our comma-separated list of date_rules_in_seq into seperate rows */
insert into date_rule_in_seq (date_rule_id,seq_number,num,tenor_type,orig_date_rule,is_date) (
select date_rule_id, 
       rownum,
   	   substr (date_rules_in_seq, instr(date_rules_in_seq,  '-', 1, 1) + 1,  instr(date_rules_in_seq, '-', 1, 2) - instr(date_rules_in_seq,  '-', 1, 1) -1 ) num,
	   substr (date_rules_in_seq, instr(date_rules_in_seq,  '-', 1, 2) + 1) tenor_type,
	   substr (date_rules_in_seq, 0, instr(date_rules_in_seq,  '-', 1, 1) - 1) orig_date_rule,
	   0 is_date
       from (select date_rule_id,
                   substr (date_rules_in_seq,
                           instr (date_rules_in_seq, ',', 1, rr.r) + 1,
                             instr (date_rules_in_seq, ',', 1, rr.r + 1)
                           - instr (date_rules_in_seq, ',', 1, rr.r)
                           - 1
                          ) date_rules_in_seq
              from (select date_rule_id, ',' || date_rules_in_seq || ',' date_rules_in_seq,
                             length (date_rules_in_seq)
                           - length (replace (date_rules_in_seq, ',', ''))
                           + 1 cnt
                      from date_rule_bak
                     where date_rules_in_seq is not null and date_rules_in_seq <> 'NONE') date_rule,
                   (select rownum r
                      from all_objects
                     where rownum <= 100) rr
             where rr.r <= date_rule.cnt order by rr.r)
     where date_rules_in_seq is not null and date_rules_in_seq <> 'NONE')
;

/* Update is_date */
update date_rule_in_seq
set is_date = decode(tenor_type, '[Dates]', 1, 0)
;

/* Update seq_number */
update date_rule_in_seq
set seq_number = (select seqs.rank
                 from (select date_rule_id, seq_number, rank() over (partition by date_rule_id order by seq_number) rank
                       from date_rule_in_seq) seqs
                 where seqs.date_rule_id = date_rule_in_seq.date_rule_id and seqs.seq_number = date_rule_in_seq.seq_number)
;

