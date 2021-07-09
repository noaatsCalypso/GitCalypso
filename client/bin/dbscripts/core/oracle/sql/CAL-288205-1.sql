declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('PSHEET_STRATEGY_ATTRIBUTE') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table PSHEET_STRATEGY_ATTRIBUTE (strategy_name varchar2(128) not null,
attribute_name  varchar2(128)  not null ,
formula varchar2(1024) not null   ,
type varchar2(32)  not null  ,
output_type varchar2(32) not null  ,
display_type varchar2(32) not null  ,
source_ccy_prop varchar2(128) null ,
target_ccy varchar2(3) null,
attribute_order number not null)';
END IF;
End ;
/
declare 
x number :=0;
BEGIN
begin
select count(*) INTO x FROM user_tables WHERE table_name=UPPER('psheet_strategy_fee_definition') ;
exception
when NO_DATA_FOUND THEN
x:=0;
when others then null;
end;
IF x = 0 THEN
EXECUTE IMMEDIATE 'create table psheet_strategy_fee_definition (strategy_name varchar2(128) not null,
strategy_fee_definition_name varchar2(128) not null,
fee_type varchar2(1024) not null   ,
base_strategy_numbers varchar2(1024) not null   ,
attribute_order number not null)';
END IF;
End ;
/

begin
add_column_if_not_exists ('option_contract','dateformat','number null');
add_column_if_not_exists ('eto_contract','dateformat','number null');
end;
/
begin
add_column_if_not_exists ('pricing_sheet_bundle_config','bundle_config_subtype','varchar2(32)');
end;
/

update option_contract set dateformat = 1 where  dateformat is null
;
update eto_contract set dateformat = 1 where  dateformat is null
;

declare
  x number :=0 ;
begin
	SELECT count(*) INTO x FROM user_tab_columns WHERE table_name=upper('PSHEET_STRATEGY_ATTRIBUTE')
	and column_name=upper('display_type');
	IF x=0 THEN
    execute immediate 'ALTER TABLE PSHEET_STRATEGY_ATTRIBUTE ADD display_type varchar2 (32) NOT NULL';
	END IF;
end;
/

declare
  x number :=0 ;
begin
	SELECT count(*) INTO x FROM user_tables WHERE table_name=upper('psheet_strategy_fee_definition');
	IF x=0 THEN
    execute immediate 'CREATE TABLE psheet_strategy_fee_definition ( strategy_name varchar2 (128) NOT NULL,  
	strategy_fee_definition_name varchar2 (128) NOT NULL,  fee_type varchar2 (1024) NOT NULL,  
	base_strategy_numbers varchar2 (1024) NOT NULL,  attribute_order numeric  NOT NULL )';
	END IF;
end;
/

CREATE OR REPLACE PROCEDURE "PRICING_SHEET_XML_GENERATION" AS

  FUNCTION GET_TRANSLATED_STRATEGY_NAME (product_type VARCHAR2, product_sub_type VARCHAR2, base_product_id NUMBER) RETURN VARCHAR2 IS
  translated_value VARCHAR2(255);
  swap_leg_type VARCHAR(10);
  BEGIN
    IF (product_type = 'FXOption') THEN
      IF (product_sub_type = 'ACCRUAL') THEN
        translated_value := 'Accrual';
      ELSIF(product_sub_type = 'ASIAN') THEN
        translated_value := 'Asian';
      ELSIF(product_sub_type = 'BARRIER') THEN
        translated_value := 'Barrier';
      ELSIF(product_sub_type = 'COMPOUND') THEN
        translated_value := 'Compound';
      ELSIF(product_sub_type = 'DIGITAL') THEN
        translated_value := 'Digital';
      ELSIF(product_sub_type = 'DIGITALWITHBARRIER') THEN
        translated_value := 'Digital With Barrier';
      ELSIF(product_sub_type = 'FWDSTART') THEN
        translated_value := 'FwdStart';
      ELSIF(product_sub_type = 'LOOKBACK') THEN
        translated_value := 'Lookback';
      ELSIF(product_sub_type = 'VOLFWD') THEN
        translated_value := 'VolFwd';
      ELSE
        translated_value := 'Vanilla';
      END IF;
    
    ELSIF (product_type = 'SimpleTransfer') THEN
        translated_value := 'SimpleTransfer';
    ELSIF (product_type = 'StructuredFlows') THEN
    
        FOR leg_info IN (select * from swap_leg where product_id = base_product_id) LOOP
        swap_leg_type := leg_info.leg_type;
        END LOOP;
        
        IF(swap_leg_type = 'Float') THEN
          translated_value := 'Floating Rate';
        ELSE
          translated_value := 'Fixed Rate';
        END IF;
    ELSE 
        translated_value := 'FX';
    END IF;
  
    RETURN translated_value;
  END GET_TRANSLATED_STRATEGY_NAME;
  
  FUNCTION TRANSLATE_LINK_OPERATOR(operator_name VARCHAR2) RETURN VARCHAR2 IS
    translated_value VARCHAR2(255);
  BEGIN
    IF(operator_name = 'ADD') THEN
      translated_value := '+';
    ELSIF(operator_name = 'SUBTRACT') THEN
      translated_value := '-';
    ELSIF(operator_name = 'MULTIPLY') THEN
      translated_value := '*';
    ELSIF(operator_name = 'OPPOSITE_TO') THEN
      translated_value := 'Opposite To';
    ELSIF(operator_name = 'CALCULATE_EXPIRY_DATE') THEN
      translated_value := 'Calculate Expiry Date';
    ELSIF(operator_name = 'CALCULATE_DELIVERY_DATE') THEN
      translated_value := 'Calculate Delivery Date';
    ELSE
      translated_value := '=';
    END IF;
    RETURN translated_value;
  END TRANSLATE_LINK_OPERATOR;
  
  FUNCTION TRANSLATE_BTS(boolean_value NUMERIC) RETURN VARCHAR2 IS
    BEGIN
    IF(boolean_value = 1) THEN
    RETURN 'true';
    ELSE 
    RETURN 'false';
    END IF;
    END TRANSLATE_BTS;
    
    FUNCTION TRANSLATE_FUNCTION_TYPE(original_value VARCHAR2) RETURN VARCHAR2 IS
    translated_value VARCHAR2(255);
    BEGIN
    IF(original_value = 'YIELD') THEN
    RETURN 'Yield';
    ELSIF (original_value = 'USER_EDITABLE') THEN
    RETURN 'User_editable';
    ELSE
    RETURN 'Simple';
    END IF;
    END TRANSLATE_FUNCTION_TYPE;
    
    FUNCTION TRANSLATE_UNIT_TYPE(original_value VARCHAR2) RETURN VARCHAR2 IS
    translated_value VARCHAR2(255);
    BEGIN
    IF(original_value = 'BP') THEN
    translated_value := 'Basis Points';
    ELSIF (original_value = 'PERCENTAGE') THEN
    translated_value := 'Percentage';
    ELSIF (original_value = 'CCY_AMOUNT') THEN
    translated_value := 'Currency Amount';
    ELSE 
      translated_value := 'Decimal';
    END IF;
    RETURN translated_value;
    END TRANSLATE_UNIT_TYPE;
    
  FUNCTION GET_BASE_STRATEGY_NAME(otbStrategyName VARCHAR2) RETURN VARCHAR2 IS
  base_strategy_name VARCHAR(255);
  BEGIN
  base_strategy_name := otbStrategyName;
  IF (otbStrategyName = 'Butterfly' OR otbStrategyName = 'BrokerButterfly' 
  OR otbStrategyName = 'Condor' OR  otbStrategyName = 'Reversal' 
  OR otbStrategyName = 'Spread' OR otbStrategyName = 'Straddle' 
  OR otbStrategyName = 'Strangle' OR otbStrategyName = 'BrokerStrangle') THEN
  base_strategy_name := 'Vanilla';
  ELSIF (otbStrategyName = 'SwapSteepener' OR otbStrategyName = 'SwapButterfly') THEN
  base_strategy_name := 'Swap';
  ELSIF (otbStrategyName = 'FRC') THEN
  base_strategy_name := 'Future Structured Flows';
  END IF;
  return base_strategy_name;
  END GET_BASE_STRATEGY_NAME;
  
  FUNCTION GET_NUMBER_OF_BASE_STRATEGIES(otbStrategyName VARCHAR2) RETURN INTEGER IS
      number_of_strategies INTEGER;
BEGIN
  number_of_strategies := 1;
  IF (otbStrategyName = 'Butterfly' OR otbStrategyName = 'BrokerButterfly' OR 
  otbStrategyName = 'Condor') THEN
    number_of_strategies := 4;
  ELSIF(otbStrategyName = 'FRC' OR otbStrategyName = 'Reversal' 
  OR otbStrategyName = 'Spread' OR otbStrategyName = 'Straddle' 
  OR otbStrategyName = 'Strangle' OR otbStrategyName = 'BrokerStrangle' OR otbStrategyName = 'SwapSteepener') THEN
    number_of_strategies := 2;
  ELSIF(otbStrategyName = 'SwapButterfly') THEN
    number_of_strategies := 3;
  END IF;
  
  return number_of_strategies;
  END GET_NUMBER_OF_BASE_STRATEGIES;
  
  PROCEDURE CUSTOM_STRATEGY_XML_GENERATION (custom_strategy_name VARCHAR2, isOTB BOOLEAN) AS
  doc xmldom.DOMDocument;
  main_node xmldom.DOMNode;

  root_node xmldom.DOMNode;
  root_elmt xmldom.DOMElement;
  
  legs_node xmldom.DOMNode;
  legs_elmt xmldom.DOMElement;
  
  leg_node xmldom.DOMNode;
  leg_elmt xmldom.DOMElement;
  
  properties_node xmldom.DOMNode;
  properties_elmt xmldom.DOMElement;
  
  dynamic_properties_node xmldom.DOMNode;
  dynamic_properties_elmt xmldom.DOMElement;
  
  link_configuration_node xmldom.DOMNode;
  link_configuration_elmt xmldom.DOMElement;
  
  links_node xmldom.DOMNode;
  links_elmt xmldom.DOMElement;
  
  link_node xmldom.DOMNode;
  link_elmt xmldom.DOMElement;
 
  link_source_leg_id_node xmldom.DOMNode;
  link_source_leg_id_elmt xmldom.DOMElement;
  link_source_leg_id_text xmldom.DOMText;
  
  link_source_property_node xmldom.DOMNode;
  link_source_property_elmt xmldom.DOMElement;
  link_source_property_text xmldom.DOMText;
  
  link_target_leg_id_node xmldom.DOMNode;
  link_target_leg_id_elmt xmldom.DOMElement;
  link_target_leg_id_text xmldom.DOMText;
  
  link_target_property_node xmldom.DOMNode;
  link_target_property_elmt xmldom.DOMElement;
  link_target_property_text xmldom.DOMText;
  
  link_operator_node xmldom.DOMNode;
  link_operator_elmt xmldom.DOMElement;
  link_operator_text xmldom.DOMText;
  
  link_operand_node xmldom.DOMNode;
  link_operand_elmt xmldom.DOMElement;
  link_operand_text xmldom.DOMText;
  
  link_system_defined_node xmldom.DOMNode;
  link_system_defined_elmt xmldom.DOMElement;
  link_system_defined_text xmldom.DOMText;
  
  link_c1c2_state_node xmldom.DOMNode;
  link_c1c2_state_elmt xmldom.DOMElement;
  link_c1c2_state_text xmldom.DOMText;
  
  link_c2c1_state_node xmldom.DOMNode;
  link_c2c1_state_elmt xmldom.DOMElement;
  link_c2c1_state_text xmldom.DOMText;
  
  link_editable_node xmldom.DOMNode;
  link_editable_elmt xmldom.DOMElement;
  link_editable_text xmldom.DOMText;
  
  attributes_node xmldom.DOMNode;
  attributes_elmt xmldom.DOMElement;
  
  attribute_node xmldom.DOMNode;
  attribute_elmt xmldom.DOMElement;
  
  attribute_name_node xmldom.DOMNode;
  attribute_name_elmt xmldom.DOMElement;
  attribute_name_text xmldom.DOMText;
  
  attribute_formula_node xmldom.DOMNode;
  attribute_formula_elmt xmldom.DOMElement;
  attribute_formula_text xmldom.DOMText;
  
  attribute_function_type_node xmldom.DOMNode;
  attribute_function_type_elmt xmldom.DOMElement;
  attribute_function_type_text xmldom.DOMText;
  
  attribute_display_type_node xmldom.DOMNode;
  attribute_display_type_elmt xmldom.DOMElement;
  attribute_display_type_text xmldom.DOMText;
  
  attribute_unit_type_node xmldom.DOMNode;
  attribute_unit_type_elmt xmldom.DOMElement;
  attribute_unit_type_text xmldom.DOMText;
  
  attribute_source_ccy_node xmldom.DOMNode;
  attribute_source_ccy_elmt xmldom.DOMElement;
  attribute_source_ccy_text xmldom.DOMText;
  
  attribute_target_ccy_node xmldom.DOMNode;
  attribute_target_ccy_elmt xmldom.DOMElement;
  attribute_target_ccy_text xmldom.DOMText;
  
  feeDefinitions_node xmldom.DOMNode;
  feeDefinitions_elmt xmldom.DOMElement;
  
  fee_definition_node xmldom.DOMNode;
  fee_definition_elmt xmldom.DOMElement;
  
  fee_definition_name_node xmldom.DOMNode;
  fee_definition_name_elmt xmldom.DOMElement;
  fee_definition_name_text xmldom.DOMText;
  
  fee_definition_type_node xmldom.DOMNode;
  fee_definition_type_elmt xmldom.DOMElement;
  fee_definition_type_text xmldom.DOMText;
  
  fee_base_strategy_numbers_node xmldom.DOMNode;
  fee_base_strategy_numbers_elmt xmldom.DOMElement;
  fee_base_strategy_numbers_text xmldom.DOMText;
  
  bundle_configs_node xmldom.DOMNode;
  bundle_configs_elmt xmldom.DOMElement;
  
  bundle_config_node xmldom.DOMNode;
  bundle_config_elmt xmldom.DOMElement;
  
  bundle_type_node xmldom.DOMNode;
  bundle_type_elmt xmldom.DOMElement;
  
  config_type VARCHAR2(255);
  config_subtype VARCHAR2(255);
  
  header_clob CLOB;
  xml_clob CLOB;
  final_clob CLOB;
  BEGIN
  doc := xmldom.newDOMDocument;
  main_node := xmldom.makeNode(doc);
  root_elmt := xmldom.createElement(doc, 'custom-strategy');
  xmldom.setAttribute(root_elmt, 'name', custom_strategy_name);
  root_node := xmldom.appendChild(main_node, xmldom.makeNode(root_elmt));
  legs_elmt := xmldom.createElement(doc, 'legs');
  legs_node := xmldom.appendChild(root_node, xmldom.makeNode(legs_elmt));
  
  IF(isOTB) THEN
  FOR i IN 1..GET_NUMBER_OF_BASE_STRATEGIES(custom_strategy_name) LOOP
  leg_elmt := xmldom.createElement(doc, 'leg');
  leg_node := xmldom.appendChild(legs_node, xmldom.makeNode(leg_elmt));
  xmldom.setAttribute(leg_elmt, 'strategy', GET_BASE_STRATEGY_NAME(custom_strategy_name));
  properties_elmt := xmldom.createElement(doc, 'properties');
  properties_node := xmldom.appendChild(leg_node, xmldom.makeNode(properties_elmt));
  dynamic_properties_elmt := xmldom.createElement(doc, 'dynamicProperties');
  dynamic_properties_node := xmldom.appendChild(leg_node, xmldom.makeNode(dynamic_properties_elmt));
  END LOOP;
  ELSE 
  FOR description IN (SELECT * FROM product_desc WHERE product_id IN (select basic_product_id from basic_product where product_id = 
  (select product_id from template_product where template_name = custom_strategy_name))) LOOP
  leg_elmt := xmldom.createElement(doc, 'leg');
  leg_node := xmldom.appendChild(legs_node, xmldom.makeNode(leg_elmt));
  xmldom.setAttribute(leg_elmt, 'strategy', GET_TRANSLATED_STRATEGY_NAME(description.product_type, description.product_sub_type, description.product_id));
  properties_elmt := xmldom.createElement(doc, 'properties');
  properties_node := xmldom.appendChild(leg_node, xmldom.makeNode(properties_elmt));
  dynamic_properties_elmt := xmldom.createElement(doc, 'dynamicProperties');
  dynamic_properties_node := xmldom.appendChild(leg_node, xmldom.makeNode(dynamic_properties_elmt));
  END LOOP;
  END IF;
  
  link_configuration_elmt := xmldom.createElement(doc, 'linkConfiguration');
  link_configuration_node := xmldom.appendChild(root_node, xmldom.makeNode(link_configuration_elmt));
  xmldom.setAttribute(link_configuration_elmt, 'iterative-leglink-calculation', 'false');
  
  links_elmt := xmldom.createElement(doc, 'links');
  links_node := xmldom.appendChild(root_node, xmldom.makeNode(links_elmt));
  
  FOR leg_links IN (SELECT * FROM psheet_leg_link where strategy = custom_strategy_name) LOOP
  link_elmt := xmldom.createElement(doc, 'link');
  link_node := xmldom.appendChild(links_node, xmldom.makeNode(link_elmt));
  link_source_leg_id_elmt := xmldom.createElement(doc, 'source-leg-id');
  link_source_leg_id_node := xmldom.appendChild(link_node, xmldom.makeNode(link_source_leg_id_elmt));
  link_source_leg_id_text := xmldom.createTextNode(doc, leg_links.ref_id);
  link_source_leg_id_node := xmldom.appendChild(link_source_leg_id_node, xmldom.makeNode(link_source_leg_id_text));
  link_source_property_elmt := xmldom.createElement(doc, 'source-property');
  link_source_property_node := xmldom.appendChild(link_node, xmldom.makeNode(link_source_property_elmt));
  link_source_property_text := xmldom.createTextNode(doc, leg_links.ref_prop_name);
  link_source_property_node := xmldom.appendChild(link_source_property_node, xmldom.makeNode(link_source_property_text));
  link_target_leg_id_elmt := xmldom.createElement(doc, 'target-leg-id');
  link_target_leg_id_node := xmldom.appendChild(link_node, xmldom.makeNode(link_target_leg_id_elmt));
  link_target_leg_id_text := xmldom.createTextNode(doc, leg_links.selected_id);
  link_target_leg_id_node := xmldom.appendChild(link_target_leg_id_node, xmldom.makeNode(link_target_leg_id_text));
  link_target_property_elmt := xmldom.createElement(doc, 'target-property');
  link_target_property_node := xmldom.appendChild(link_node, xmldom.makeNode(link_target_property_elmt));
  link_target_property_text := xmldom.createTextNode(doc, leg_links.prop_name);
  link_target_property_node := xmldom.appendChild(link_target_property_node, xmldom.makeNode(link_target_property_text));
  link_operator_elmt := xmldom.createElement(doc, 'operator');
  link_operator_node := xmldom.appendChild(link_node, xmldom.makeNode(link_operator_elmt));
  link_operator_text := xmldom.createTextNode(doc, TRANSLATE_LINK_OPERATOR(leg_links.operator));
  link_operator_node := xmldom.appendChild(link_operator_node, xmldom.makeNode(link_operator_text));
  link_operand_elmt := xmldom.createElement(doc, 'operand');
  link_operand_node := xmldom.appendChild(link_node, xmldom.makeNode(link_operand_elmt));
  IF(leg_links.operand IS NULL) THEN
    link_operand_text := xmldom.createTextNode(doc, '0.0');
  ELSE 
    link_operand_text := xmldom.createTextNode(doc, leg_links.operand);
  END IF;
  link_operand_node := xmldom.appendChild(link_operand_node, xmldom.makeNode(link_operand_text));
  link_system_defined_elmt := xmldom.createElement(doc, 'system-defined');
  link_system_defined_node := xmldom.appendChild(link_node, xmldom.makeNode(link_system_defined_elmt));
  link_system_defined_text := xmldom.createTextNode(doc, TRANSLATE_BTS(leg_links.system_defined));
  link_system_defined_node := xmldom.appendChild(link_system_defined_node, xmldom.makeNode(link_system_defined_text));
  link_c1c2_state_elmt := xmldom.createElement(doc, 'cell1-to-cell2-link-state');
  link_c1c2_state_node := xmldom.appendChild(link_node, xmldom.makeNode(link_c1c2_state_elmt));
  link_c1c2_state_text := xmldom.createTextNode(doc, leg_links.cell1_to_cell2_link_state);
  link_c1c2_state_node := xmldom.appendChild(link_c1c2_state_node, xmldom.makeNode(link_c1c2_state_text));
  link_c2c1_state_elmt := xmldom.createElement(doc, 'cell2-to-cell1-link-state');
  link_c2c1_state_node := xmldom.appendChild(link_node, xmldom.makeNode(link_c2c1_state_elmt));
  link_c2c1_state_text := xmldom.createTextNode(doc, leg_links.cell2_to_cell1_link_state);
  link_c2c1_state_node := xmldom.appendChild(link_c2c1_state_node, xmldom.makeNode(link_c2c1_state_text));
  link_editable_elmt := xmldom.createElement(doc, 'editable');
  link_editable_node := xmldom.appendChild(link_node, xmldom.makeNode(link_editable_elmt));
  link_editable_text := xmldom.createTextNode(doc, TRANSLATE_BTS(leg_links.is_editable));
  link_editable_node := xmldom.appendChild(link_editable_node, xmldom.makeNode(link_editable_text));
  END LOOP;
  
  attributes_elmt := xmldom.createElement(doc, 'attributes');
  attributes_node := xmldom.appendChild(root_node, xmldom.makeNode(attributes_elmt));
  
  FOR strategy_attribute IN (SELECT * FROM psheet_strategy_attribute where strategy_name = custom_strategy_name ORDER BY attribute_order) LOOP
  attribute_elmt := xmldom.createElement(doc, 'attribute');
  attribute_node := xmldom.appendChild(attributes_node, xmldom.makeNode(attribute_elmt));
  attribute_name_elmt := xmldom.createElement(doc, 'name');
  attribute_name_node := xmldom.appendChild(attribute_node, xmldom.makeNode(attribute_name_elmt));
  attribute_name_text := xmldom.createTextNode(doc, strategy_attribute.attribute_name);
  attribute_name_node := xmldom.appendChild(attribute_name_node, xmldom.makeNode(attribute_name_text));
  attribute_formula_elmt := xmldom.createElement(doc, 'formula');
  attribute_formula_node := xmldom.appendChild(attribute_node, xmldom.makeNode(attribute_formula_elmt));
  attribute_formula_text := xmldom.createTextNode(doc, strategy_attribute.formula);
  attribute_formula_node := xmldom.appendChild(attribute_formula_node, xmldom.makeNode(attribute_formula_text));
  attribute_function_type_elmt := xmldom.createElement(doc, 'function-type');
  attribute_function_type_node := xmldom.appendChild(attribute_node, xmldom.makeNode(attribute_function_type_elmt));
  attribute_function_type_text := xmldom.createTextNode(doc, TRANSLATE_FUNCTION_TYPE(strategy_attribute.type));
  attribute_function_type_node := xmldom.appendChild(attribute_function_type_node, xmldom.makeNode(attribute_function_type_text));
  attribute_display_type_elmt := xmldom.createElement(doc, 'display-type');
  attribute_display_type_node := xmldom.appendChild(attribute_node, xmldom.makeNode(attribute_display_type_elmt));
  IF (strategy_attribute.display_type = 'PRICER_MEASURE') THEN
  attribute_display_type_text := xmldom.createTextNode(doc, 'Pricer Measure');
  ELSE 
  attribute_display_type_text := xmldom.createTextNode(doc, 'Property');
  END IF;
  attribute_display_type_node := xmldom.appendChild(attribute_display_type_node, xmldom.makeNode(attribute_display_type_text));
  attribute_unit_type_elmt := xmldom.createElement(doc, 'output-unit-type');
  attribute_unit_type_node := xmldom.appendChild(attribute_node, xmldom.makeNode(attribute_unit_type_elmt));
  attribute_unit_type_text := xmldom.createTextNode(doc, TRANSLATE_UNIT_TYPE(strategy_attribute.output_type));
  attribute_unit_type_node := xmldom.appendChild(attribute_unit_type_node, xmldom.makeNode(attribute_unit_type_text));
  attribute_source_ccy_elmt := xmldom.createElement(doc, 'source-ccy-prop');
  attribute_source_ccy_node := xmldom.appendChild(attribute_node, xmldom.makeNode(attribute_source_ccy_elmt));
  attribute_source_ccy_text := xmldom.createTextNode(doc, strategy_attribute.source_ccy_prop);
  attribute_source_ccy_node := xmldom.appendChild(attribute_source_ccy_node, xmldom.makeNode(attribute_source_ccy_text));
  attribute_target_ccy_elmt := xmldom.createElement(doc, 'target_ccy');
  attribute_target_ccy_node := xmldom.appendChild(attribute_node, xmldom.makeNode(attribute_target_ccy_elmt));
  attribute_target_ccy_text := xmldom.createTextNode(doc, strategy_attribute.target_ccy);
  attribute_target_ccy_node := xmldom.appendChild(attribute_target_ccy_node, xmldom.makeNode(attribute_target_ccy_text)); 
  END LOOP;
  
  feeDefinitions_elmt := xmldom.createElement(doc, 'feeDefinitions');
  feeDefinitions_node := xmldom.appendChild(root_node, xmldom.makeNode(feeDefinitions_elmt));
  
  FOR fee_definition IN (SELECT * FROM psheet_strategy_fee_definition where strategy_name = custom_strategy_name ORDER BY attribute_order) LOOP
  fee_definition_elmt := xmldom.createElement(doc, 'fee-definition');
  fee_definition_node := xmldom.appendChild(feeDefinitions_node, xmldom.makeNode(fee_definition_elmt));
  fee_definition_name_elmt := xmldom.createElement(doc, 'name');
  fee_definition_name_node := xmldom.appendChild(fee_definition_node, xmldom.makeNode(fee_definition_name_elmt));
  fee_definition_name_text := xmldom.createTextNode(doc, fee_definition.strategy_fee_definition_name);
  fee_definition_name_node := xmldom.appendChild(fee_definition_name_node, xmldom.makeNode(fee_definition_name_text));
  fee_definition_type_elmt := xmldom.createElement(doc, 'fee-definition-type');
  fee_definition_type_node := xmldom.appendChild(fee_definition_node, xmldom.makeNode(fee_definition_type_elmt));
  fee_definition_type_text := xmldom.createTextNode(doc, fee_definition.fee_type);
  fee_definition_type_node := xmldom.appendChild(fee_definition_type_node, xmldom.makeNode(fee_definition_type_text));
  fee_base_strategy_numbers_elmt := xmldom.createElement(doc, 'base-strategy-numbers');
  fee_base_strategy_numbers_node := xmldom.appendChild(fee_definition_node, xmldom.makeNode(fee_base_strategy_numbers_elmt));
  fee_base_strategy_numbers_text := xmldom.createTextNode(doc, fee_definition.base_strategy_numbers);
  fee_base_strategy_numbers_node := xmldom.appendChild(fee_base_strategy_numbers_node, xmldom.makeNode(fee_base_strategy_numbers_text));
  END LOOP;
  
  bundle_configs_elmt := xmldom.createElement(doc, 'bundle-configurations');
  bundle_configs_node := xmldom.appendChild(root_node, xmldom.makeNode(bundle_configs_elmt));
  
  
  FOR bundle_config IN (select * from pricing_sheet_bundle_config where (user_name = 'PricingSheet' 
  and strategy_name = custom_strategy_name) or (user_name = 'PricingSheet' and strategy_name = custom_strategy_name || ' Strip') ORDER BY strategy_name, bundle_config_subtype) LOOP
  IF (config_type IS NULL OR bundle_config.strategy_name <> config_type 
  OR (config_subtype IS NULL AND bundle_config.bundle_config_subtype IS NOT NULL)
  OR (config_subtype IS NOT NULL AND bundle_config.bundle_config_subtype IS NULL)
  OR (config_subtype IS NOT NULL AND bundle_config.bundle_config_subtype IS NOT NULL AND 
  bundle_config.bundle_config_subtype <> config_subtype)) THEN
  bundle_type_elmt := xmldom.createElement(doc, 'bundle-configuration');
  bundle_type_node := xmldom.appendChild(bundle_configs_node, xmldom.makeNode(bundle_type_elmt));
  config_type := bundle_config.strategy_name;
  config_subtype := bundle_config.bundle_config_subtype;
    IF (SUBSTR(bundle_config.strategy_name, LENGTH(custom_strategy_name) + 2) = 'Strip') THEN
      xmldom.setAttribute(bundle_type_elmt, 'type', 'Strip');
    ELSE 
      xmldom.setAttribute(bundle_type_elmt, 'type', 'Strategy');
    END IF;

    IF (bundle_config.bundle_config_subtype IS NOT NULL) THEN
      xmldom.setAttribute(bundle_type_elmt, 'subtype', bundle_config.bundle_config_subtype);
    END IF;
    xmldom.setAttribute(bundle_type_elmt, 'attribute', 'Bundle Type');
    xmldom.setAttribute(bundle_type_elmt, 'value', bundle_config.bundle_type);
  END IF;
  
  bundle_config_elmt := xmldom.createElement(doc, 'bundle-configuration');
  bundle_config_node := xmldom.appendChild(bundle_configs_node, xmldom.makeNode(bundle_config_elmt));
  IF (SUBSTR(bundle_config.strategy_name, LENGTH(custom_strategy_name) + 2) = 'Strip') THEN
    xmldom.setAttribute(bundle_config_elmt, 'type', 'Strip');
  ELSE 
    xmldom.setAttribute(bundle_config_elmt, 'type', 'Strategy');
  END IF;

  IF (bundle_config.bundle_config_subtype IS NOT NULL) THEN
    xmldom.setAttribute(bundle_config_elmt, 'subtype', bundle_config.bundle_config_subtype);
  END IF;
  xmldom.setAttribute(bundle_config_elmt, 'attribute', bundle_config.attr_name);
  xmldom.setAttribute(bundle_config_elmt, 'value', TRANSLATE_BTS(bundle_config.is_attr_value_b));
  
  END LOOP;
  
  dbms_lob.createTemporary(xml_clob, TRUE);
  dbms_lob.createTemporary(header_clob, TRUE);
  dbms_lob.createTemporary(final_clob, TRUE);
  xmldom.writeToClob(doc, xml_clob);
  dbms_lob.append(header_clob, '<?xml version="1.0" encoding="utf-8"?>' || chr(10));
  final_clob := header_clob || xml_clob;
  INSERT INTO PSHEET_CUSTOM_STRATEGIES_XML (name,xml_data) VALUES (custom_strategy_name, final_clob);
  dbms_lob.freeTemporary(xml_clob);
  dbms_lob.freeTemporary(header_clob);
  dbms_lob.freeTemporary(final_clob);
  xmldom.freeDocument(doc);
  END;
  
  PROCEDURE PROFILE_XML_GENERATION (profile_name VARCHAR2) AS
  doc xmldom.DOMDocument;
  main_node xmldom.DOMNode;

  root_node xmldom.DOMNode;
  root_elmt xmldom.DOMElement;
  
  associate_names_node xmldom.DOMNode;
  associate_names_elmt xmldom.DOMElement;
  
  associate_name_node xmldom.DOMNode;
  associate_name_elmt xmldom.DOMElement;
  
  menu_node xmldom.DOMNode;
  menu_elmt xmldom.DOMElement;
  
  menu_element_group_node xmldom.DOMNode;
  menu_element_group_elmt xmldom.DOMElement;
  
  menu_element_node xmldom.DOMNode;
  menu_element_elmt xmldom.DOMElement;

  properties_layout_node xmldom.DOMNode;
  properties_layout_elmt xmldom.DOMElement;
  
  property_layout_node xmldom.DOMNode;
  property_layout_elmt xmldom.DOMElement;
  
  strategy_properties_node xmldom.DOMNode;
  strategy_properties_elmt xmldom.DOMElement;

  strategy_property_node xmldom.DOMNode;
  strategy_property_elmt xmldom.DOMElement;
  
  associated_strategies_node xmldom.DOMNode;
  associated_strategies_elmt xmldom.DOMElement;
  
  associated_strategy_node xmldom.DOMNode;
  associated_strategy_elmt xmldom.DOMElement;
  
  properties_editability_node xmldom.DOMNode;
  properties_editability_elmt xmldom.DOMElement;
  
  property_editability_node xmldom.DOMNode;
  property_editability_elmt xmldom.DOMElement;
  
  dot_location NUMBER;
  strategy_name VARCHAR2(64);
  group_name VARCHAR2(64);
  new_group_name VARCHAR2(64);
  
  header_clob CLOB;
  xml_clob CLOB;
  final_clob CLOB;
  BEGIN
  doc := xmldom.newDOMDocument;
  main_node := xmldom.makeNode(doc);
  root_elmt := xmldom.createElement(doc, 'profile');
  xmldom.setAttribute(root_elmt, 'name', profile_name);
  root_node := xmldom.appendChild(main_node, xmldom.makeNode(root_elmt));
  
  associate_names_elmt := xmldom.createElement(doc, 'associated-names');
  associate_names_node := xmldom.appendChild(root_node, xmldom.makeNode(associate_names_elmt));
  
  FOR profiles IN (select * from psheet_profiles where profile = profile_name) LOOP
  associate_name_elmt := xmldom.createElement(doc, 'associated-name');
  xmldom.setAttribute(associate_name_elmt, 'name', profiles.associated_name);
  
  IF (profiles.is_group = 1) THEN
    xmldom.setAttribute(associate_name_elmt, 'type', 'Group');
  ELSE
    xmldom.setAttribute(associate_name_elmt, 'type', 'User');
  END IF;
  associate_name_node := xmldom.appendChild(associate_names_node, xmldom.makeNode(associate_name_elmt));
  END LOOP;
  
  menu_elmt := xmldom.createElement(doc, 'menu');
  menu_node := xmldom.appendChild(root_node, xmldom.makeNode(menu_elmt));
  
  FOR menu IN (select * from user_viewer_column where uv_usage = 'DEAL_ENTRY/FAVORITE_STRATEGIES' and user_name = profile_name order by column_position) LOOP
  IF(INSTR(menu.column_name, 'g_') = 1) THEN
    dot_location := INSTR(menu.column_name, '.');
    strategy_name := SUBSTR(menu.column_name, dot_location + 1);
    new_group_name := SUBSTR(menu.column_name, 3, dot_location - 3);
    
    IF(group_name IS NULL OR group_name <> new_group_name) THEN
      group_name := new_group_name;
      menu_element_group_elmt := xmldom.createElement(doc, 'menu-element');
      menu_element_group_node := xmldom.appendChild(menu_node, xmldom.makeNode(menu_element_group_elmt));
      xmldom.setAttribute(menu_element_group_elmt, 'name', group_name);
      xmldom.setAttribute(menu_element_group_elmt, 'type', 'Separator');
    END IF;
    menu_element_elmt := xmldom.createElement(doc, 'menu-element');
    menu_element_node := xmldom.appendChild(menu_node, xmldom.makeNode(menu_element_elmt));
    xmldom.setAttribute(menu_element_elmt, 'name', strategy_name);
    xmldom.setAttribute(menu_element_elmt, 'type', 'Strategy');
    xmldom.setAttribute(menu_element_elmt, 'group', group_name);
    ELSE
    menu_element_elmt := xmldom.createElement(doc, 'menu-element');
    menu_element_node := xmldom.appendChild(menu_node, xmldom.makeNode(menu_element_elmt));
    xmldom.setAttribute(menu_element_elmt, 'name', menu.column_name);
    xmldom.setAttribute(menu_element_elmt, 'type', 'Strategy');
  END IF;
  END LOOP;
  
  properties_layout_elmt := xmldom.createElement(doc, 'properties-layout');
  properties_layout_node := xmldom.appendChild(root_node, xmldom.makeNode(properties_layout_elmt));
  
  FOR property IN (select distinct property_name, display_color, display_group, property_order from psheet_strategy_prop where user_name = profile_name order by property_order) LOOP
  property_layout_elmt := xmldom.createElement(doc, 'property-layout');
  property_layout_node := xmldom.appendChild(properties_layout_node, xmldom.makeNode(property_layout_elmt));
  xmldom.setAttribute(property_layout_elmt, 'name', property.property_name);
  xmldom.setAttribute(property_layout_elmt, 'color', property.display_color);
  xmldom.setAttribute(property_layout_elmt, 'group', property.display_group);
  xmldom.setAttribute(property_layout_elmt, 'autoExpand', 'false');
  END LOOP;
  
  strategy_properties_elmt := xmldom.createElement(doc, 'strategy-properties');
  strategy_properties_node := xmldom.appendChild(root_node, xmldom.makeNode(strategy_properties_elmt));
  
  FOR property IN (select distinct property_name, property_order from psheet_strategy_prop where user_name = profile_name order by property_order) LOOP
  strategy_property_elmt := xmldom.createElement(doc, 'strategy-property');
  strategy_property_node := xmldom.appendChild(strategy_properties_node, xmldom.makeNode(strategy_property_elmt));
  xmldom.setAttribute(strategy_property_elmt, 'name', property.property_name);
  
  associated_strategies_elmt := xmldom.createElement(doc, 'associated-strategies');
  associated_strategies_node := xmldom.appendChild(strategy_property_node, xmldom.makeNode(associated_strategies_elmt));
  
  
  FOR strategy_property IN (select strategy_name, property_name from psheet_strategy_prop where user_name = profile_name and property_name = property.property_name) LOOP
    associated_strategy_elmt := xmldom.createElement(doc, 'associated-strategy');
    associated_strategy_node := xmldom.appendChild(associated_strategies_node, xmldom.makeNode(associated_strategy_elmt));
    xmldom.setAttribute(associated_strategy_elmt, 'name', strategy_property.strategy_name);
    xmldom.setAttribute(associated_strategy_elmt, 'visible', 'true');
    
    properties_editability_elmt := xmldom.createElement(doc, 'properties-editability');
    properties_editability_node := xmldom.appendChild(associated_strategy_node, xmldom.makeNode(properties_editability_elmt));
    
    FOR editable_property IN (select * from psheet_strategy_prop_edit where psheet_strategy_prop_edit.strategy_name = strategy_property.strategy_name 
    and psheet_strategy_prop_edit.property_name = strategy_property.property_name) LOOP
        property_editability_elmt := xmldom.createElement(doc, 'property-editability');
        property_editability_node := xmldom.appendChild(properties_editability_node, xmldom.makeNode(property_editability_elmt));
        xmldom.setAttribute(property_editability_elmt, 'editable', TRANSLATE_BTS(editable_property.is_editable));
        xmldom.setAttribute(property_editability_elmt, 'leg', editable_property.leg + 1);
    END LOOP;
  END LOOP;
  END LOOP;
  
  dbms_lob.createTemporary(xml_clob, TRUE);
  dbms_lob.createTemporary(header_clob, TRUE);
  dbms_lob.createTemporary(final_clob, TRUE);
  xmldom.writeToClob(doc, xml_clob);
  dbms_lob.append(header_clob, '<?xml version="1.0" encoding="utf-8"?>' || chr(10));
  final_clob := header_clob || xml_clob;
  INSERT INTO PSHEET_PROFILES_XML(name, xml_data) VALUES (profile_name, final_clob);
  dbms_lob.freeTemporary(xml_clob);
  dbms_lob.freeTemporary(header_clob);
  dbms_lob.freeTemporary(final_clob);
  xmldom.freeDocument(doc);
  END;
BEGIN
    FOR rec IN (SELECT * FROM psheet_custom_strategies WHERE NOT EXISTS 
    (select name from psheet_custom_strategies_xml where psheet_custom_strategies.name = psheet_custom_strategies_xml.name)) LOOP
    CUSTOM_STRATEGY_XML_GENERATION(rec.name, false);
    END LOOP;
    
    FOR rec IN (SELECT DISTINCT strategy_name FROM pricing_sheet_bundle_config WHERE user_name = 'PricingSheet' AND SUBSTR(strategy_name, -5) <> 'Strip' AND NOT EXISTS 
    (select name from psheet_custom_strategies_xml where pricing_sheet_bundle_config.strategy_name = psheet_custom_strategies_xml.name)) LOOP
    CUSTOM_STRATEGY_XML_GENERATION(rec.strategy_name, true);
    END LOOP;
    
    FOR rec IN (SELECT DISTINCT strategy FROM psheet_leg_link WHERE strategy <> 'OTB' AND NOT EXISTS 
    (select name from psheet_custom_strategies_xml where psheet_leg_link.strategy = psheet_custom_strategies_xml.name)) LOOP
    CUSTOM_STRATEGY_XML_GENERATION(rec.strategy, true);
    END LOOP;
    
    FOR rec IN (SELECT DISTINCT strategy_name FROM psheet_strategy_attribute WHERE NOT EXISTS 
    (select name from psheet_custom_strategies_xml where psheet_strategy_attribute.strategy_name = psheet_custom_strategies_xml.name)) LOOP
    CUSTOM_STRATEGY_XML_GENERATION(rec.strategy_name, true);
    END LOOP;
    
    FOR rec IN (SELECT DISTINCT strategy_name FROM psheet_strategy_fee_definition WHERE NOT EXISTS 
    (select name from psheet_custom_strategies_xml where psheet_strategy_fee_definition.strategy_name = psheet_custom_strategies_xml.name)) LOOP
    CUSTOM_STRATEGY_XML_GENERATION(rec.strategy_name, true);
    END LOOP;
   
    FOR rec IN (SELECT DISTINCT profile FROM psheet_profiles WHERE NOT EXISTS 
    (select name from psheet_profiles_xml where psheet_profiles.profile = psheet_profiles_xml.name)) LOOP
    PROFILE_XML_GENERATION(rec.profile);
    END LOOP;
END;
/

BEGIN
 PRICING_SHEET_XML_GENERATION;
END;
/
drop procedure PRICING_SHEET_XML_GENERATION
;

CREATE OR REPLACE PROCEDURE MIGRATE_LEGLINK_DIRECTION AS
xml_data_Clob CLOB;
new_xml_Clob CLOB;
xml_parser DBMS_XMLPARSER.parser;
xml_doc DBMS_XMLDOM.domdocument;
all_link_noes DBMS_XMLDOM.DOMNodeList;
link_childs DBMS_XMLDOM.DOMNodeList;
link_node DBMS_XMLDOM.DOMNode;
leg_node DBMS_XMLDOM.DOMNode;
leg_id DBMS_XMLDOM.DOMNode;
leg_property DBMS_XMLDOM.DOMNode;
v_target_leg VARCHAR2(3);
v_source_leg VARCHAR2(3);
v_target_property VARCHAR2(48);
v_source_property VARCHAR2(48);
strategyName VARCHAR2(64);
CURSOR c1 is
SELECT name, xml_data FROM psheet_custom_strategies_xml;
BEGIN
xml_parser := DBMS_XMLPARSER.newparser();
DBMS_XMLPARSER.setvalidationmode(xml_parser, FALSE);
DBMS_XMLPARSER.setpreservewhitespace(xml_parser, FALSE);
OPEN c1;
LOOP
FETCH c1 INTO strategyName, xml_data_Clob;
EXIT WHEN c1%NOTFOUND;
DBMS_XMLPARSER.parseclob(xml_parser, xml_data_Clob);
xml_doc := DBMS_XMLPARSER.getdocument(xml_parser);
all_link_noes := DBMS_XMLDOM.GetElementsByTagName(xml_doc, 'link');
FOR i IN 0 .. (DBMS_XMLDOM.getLength(all_link_noes) - 1) LOOP
link_node := DBMS_XMLDOM.Item(all_link_noes, i);
DBMS_XSLPROCESSOR.valueOf(link_node, 'target-leg-id', v_target_leg);
DBMS_XSLPROCESSOR.valueOf(link_node, 'source-leg-id', v_source_leg);
DBMS_XSLPROCESSOR.valueOf(link_node, 'target-leg-id', v_target_leg);
DBMS_XSLPROCESSOR.valueOf(link_node, 'source-leg-id', v_source_leg);
DBMS_XSLPROCESSOR.valueOf(link_node, 'source-property', v_source_property);
DBMS_XSLPROCESSOR.valueOf(link_node, 'target-property', v_target_property);
link_childs := DBMS_XMLDOM.GETCHILDNODES(link_node);
FOR i IN 0 .. dbms_xmldom.getLength(link_childs) - 1 LOOP
leg_node := DBMS_XMLDOM.item(link_childs, i);
IF (DBMS_XMLDOM.GETNODENAME(leg_node) = 'source-leg-id') then
leg_id := DBMS_XMLDOM.getFirstChild(leg_node);
DBMS_XMLDOM.setNodeValue(leg_id, v_target_leg);
END IF;
IF (DBMS_XMLDOM.GETNODENAME(leg_node) = 'target-leg-id') then
leg_id := DBMS_XMLDOM.getFirstChild(leg_node);
DBMS_XMLDOM.setNodeValue(leg_id, v_source_leg);
END IF;
IF (DBMS_XMLDOM.GETNODENAME(leg_node) = 'source-property') then
leg_property := DBMS_XMLDOM.getFirstChild(leg_node);
DBMS_XMLDOM.setNodeValue(leg_property, v_target_property);
END IF;
IF (DBMS_XMLDOM.GETNODENAME(leg_node) = 'target-property') then
leg_property := DBMS_XMLDOM.getFirstChild(leg_node);
DBMS_XMLDOM.setNodeValue(leg_property, v_source_property);
END IF;
END LOOP;
END LOOP;
DBMS_LOB.createTemporary(new_xml_Clob, cache => FALSE);
DBMS_LOB.Open(new_xml_Clob, DBMS_LOB.lob_readwrite);
DBMS_XMLDOM.writeToCLob(xml_doc, new_xml_Clob);
UPDATE psheet_custom_strategies_xml set xml_data = new_xml_clob where name = strategyName;
DBMS_LOB.freeTemporary(new_xml_clob);
DBMS_XMLDOM.freeDocument(xml_doc);
END LOOP;
CLOSE c1;
COMMIT;
END MIGRATE_LEGLINK_DIRECTION;
/
begin
MIGRATE_LEGLINK_DIRECTION;
end;
/
drop procedure MIGRATE_LEGLINK_DIRECTION
/

create or replace procedure update_pl_config_year_end
as  
begin
    declare
    date_lang varchar2(64);
    current_date_lang varchar2(64);  
    l_single_quote CHAR(1) := '''';
    datatype varchar2(30);
    sql_stmt  VARCHAR2(200); 
    x number;
	  y number;
    begin 
		begin  
			 select value  into  current_date_lang from   v$nls_parameters where  parameter = 'NLS_DATE_LANGUAGE';
		exception
			when others then
			date_lang:=l_single_quote||'NLS_DATE_LANGUAGE =ENGLISH'||l_single_quote;
        end;
        begin      
			select count(*) into y from user_tables where table_name='OFFICIAL_PL_CONFIG';
			select count(*) INTO x FROM user_tab_columns WHERE table_name='OFFICIAL_PL_CONFIG' and column_name='YEAR_END_MONTH';
        exception
				when NO_DATA_FOUND THEN
					x:=0;
				when others then
					null;
        end;      
        IF x = 1 and y = 1 THEN
			select data_type into datatype from user_tab_columns  WHERE table_name='OFFICIAL_PL_CONFIG' and column_name='YEAR_END_MONTH';       
			IF datatype <> 'NUMBER' THEN
				EXECUTE IMMEDIATE 'create table official_pl_config_back15 as select * from OFFICIAL_PL_CONFIG';
				EXECUTE IMMEDIATE 'alter table OFFICIAL_PL_CONFIG  add  TEMP NUMERIC'; 
				if current_date_lang is not null then
					date_lang:=l_single_quote||' NLS_DATE_LANGUAGE ='||current_date_lang||l_single_quote;    
				else
					date_lang:=l_single_quote||'NLS_DATE_LANGUAGE =ENGLISH'||l_single_quote;
				end if;  
         
				begin	        
					sql_stmt :='UPDATE  OFFICIAL_PL_CONFIG set TEMP =TO_NUMBER(TO_CHAR(TO_DATE(year_end_month,'||chr(39)||'Month'||chr(39)||'),'||chr(39)||'MM'||chr(39)|| ','||date_lang ||' ))'; 
         
					EXECUTE IMMEDIATE sql_stmt ;
					EXECUTE IMMEDIATE 'ALTER TABLE OFFICIAL_PL_CONFIG DROP COLUMN YEAR_END_MONTH';
					EXECUTE IMMEDIATE 'ALTER TABLE OFFICIAL_PL_CONFIG  RENAME COLUMN TEMP TO YEAR_END_MONTH';
				exception
					when others then
						EXECUTE IMMEDIATE 'ALTER TABLE OFFICIAL_PL_CONFIG  drop  COLUMN TEMP';
				end;
			end if;  
		end if;  
		exception
			when others then
			null;
    end;   
	exception
		when others then
		null;
end;
/
begin
update_pl_config_year_end;
end;
/
drop procedure update_pl_config_year_end
;
UPDATE calypso_info
    SET major_version=15,
        minor_version=0,
        sub_version=0,
        patch_version='005',
        version_date=TO_DATE('01/07/2016','DD/MM/YYYY')
;
