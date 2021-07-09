/* Removing TraxMessageEventFilter and NotTraxMessageEventFilter */
DELETE FROM ps_event_filter
WHERE event_config_name = 'Back-Office'
      AND engine_name = 'TraxEngine'
      AND event_filter in ('TraxMessageEventFilter', 'NotTraxMessageEventFilter')
;

DELETE FROM domain_values
WHERE name = 'eventFilter'
      AND value in ('TraxMessageEventFilter', 'NotTraxMessageEventFilter')
;

/* Removing sd_filter_element KEYWORD.TRAXRepoEndLegStatus */
DELETE FROM sd_filter_domain
WHERE sd_filter_name = 'TRAX Matched' 
      AND element_name = 'KEYWORD.TRAXRepoEndLegStatus'
;
DELETE FROM sd_filter_element
WHERE sd_filter_name = 'TRAX Matched' 
      AND element_name = 'KEYWORD.TRAXRepoEndLegStatus'
;
