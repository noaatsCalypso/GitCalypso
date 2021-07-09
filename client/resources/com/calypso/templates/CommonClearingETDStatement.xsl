<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:stmt="urn:com:calypso:clearing:statement:etd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">


    <xsl:template name="statementStyle">
        <style type="text/css">

            body {
            text-align: justify;
            font-family: "Lucida Console", Monaco, monospace;
            }

            div.SECTION {
            padding-top: 10px;
            padding-left: 50px;
            padding-right: 50px;
            padding-bottom: 10px;
            }

            p.FOOTER {
            text-align: center;
            font-size: 8px;
            }

            p.TITLE {
            text-align: center;
            font-size: 1.5em;
            text-decoration: underline;
            }

            p.SECTION_TITLE {
            text-align: center;
            font-size: 1.25em;
            background-color: #1A237E; /* Indigo 900 */
            color: white;
            padding: 5px;
            }

            table {
            font-size: 0.7em;
            border-collapse: collapse;
            }

            table.FULL_WIDTH {
            font-size: 0.7em;
            width: 100%;
            }

            table.TITLE {
            font-size: 1.2em;
            width: 100%;
            }

            table.FINANCIAL_SUMMARY {
            font-size: 0.8em;
            width: 80%;
            }                        

            th.FINANCIAL_SUMMARY {
            font-weight: bold;
            border-bottom: 0px;
            font-size: 1.05em;       
            }

            th.TITLE {
            padding-top: 5px;
            padding-left: 0px;
            padding-right: 5px;
            padding-bottom: 0px;
            border-bottom-width: 2px;
            border-bottom-color: #1A237E;
            border-bottom-style: solid;            
            }

            th.SUB_SECTION_TITLE {
            text-align: left;
            font-size: 1.5em;
            color: #1A237E;
            padding-top: 20px;
            padding-bottom: 10px;
            padding-left: 0px;
            text-transform: uppercase;
            border-bottom: 0px;
            }

            th.TITLE_TEXT {
            color: #1A237E;
            text-transform: uppercase;
            font-weight: bold;
            width:1%;
            white-space:nowrap;
            }

            td.SECTION_COMMENT {    
            opacity: 0.54;
            font-size: .65em;
            padding-bottom: 10px;
            }
            
            td.COMMENT_20 {
            width: 20%;
            }

            th {
            white-space: nowrap;
            text-align: left;
            padding: 0.45em;
            padding-bottom: 0.00em;
            border-bottom: 1px solid black;
            vertical-align: bottom;            
            }

            th.ALIGN_RIGHT {
            text-align: right;
            }

            td {
            white-space: nowrap;
            text-align: left;
            padding: 0.45em;
            }

            td.NO_PADDING {
            padding: 0.0em;
            }
            
            tr.EVEN_ROW {
            //background-color: #E0F2F1; /* Teal 50 */
            }
            
            tr.EVEN_ROW_FINSUM {
            background-color: #E8EAF6; /* Indigo 50 */
            }

            tr.EVEN_ROW_SUBTOTAL {
            background-color: #C5CAE9; /* Indigo 100 */
            font-weight: bold;
            }

            td.ALIGN_RIGHT {
            text-align: right;
            }

			td.ALIGN_RIGHT_BOLD {
            text-align: right;
            font-weight: bold;
            }
            
            td.FONT_BOLD {
            font-weight: bold;
            }
            
            th.ALIGN_CENTER,td.ALIGN_CENTER {
            text-align: center;
            }
            
            .CONTRACT_DESCRIPTION {
            text-align: left;
            }

            td.SYMBOL {
            font-weight: bolder;
            text-align: center;
            color: white;
            }

            .BOXED {
            display: inline-block;
            width: 85%;
            padding-left: 3px;
            padding-right: 3px;
            font-weight: 900;
            font-size: 1.10em;
            font-family: sans-serif;
            color: white;
            background-color: #1A237E; /* Indigo 900 */
            }

            td.SUB_TOTAL {
            font-weight: bold;            
            }
            
            td.LARGER_SUB_TOTAL {
            font-weight: bold;
            font-size: 1.05em;
            }

            .FINANCIAL_SUMMARY:first-child {
            width: 15%;
            }

            div.EMPTY_SECTION_COMMENT { 
            opacity: 0.54;
            font-size: 1.2em;
            text-align: center;
            padding: 25px;
            }

            .DEBIT_CREDIT {
            width: 10%;
            }
            
            .MARKET_VALUE {
            width: 10%;
            }

            .CURRENCY {
            width: 3%;
            text-align: center;
            }

            .CURRENCY-bold {
            width: 3%;
            text-align: center;
            font-weight: bold;
            }

            .wrappable {
            white-space: pre-line;
            }
            
            .wrappable-bold {
            white-space: pre-line;
            font-weight: bold;
            }

        </style>
    </xsl:template>

    <xsl:template name="footer">
        <p class="FOOTER">
            Statement generated by Calypso Technology, 2017.
        </p>
    </xsl:template>

    <xsl:template name="logo">
        <p>
            <img src="https://www.calypso.com/images/logo.gif" alt="Logo" />
        </p>
    </xsl:template>
</xsl:stylesheet>