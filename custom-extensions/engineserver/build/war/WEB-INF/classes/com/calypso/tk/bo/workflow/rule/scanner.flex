/*
 *
 * Copyright (c) 2000 by Calypso Technology, Inc.
 * 595 Market Street, Suite 1980, San Francisco, CA  94105, U.S.A.
 * All rights reserved.
 *
 * This software is the confidential and proprietary information
 * of Calypso Technology, Inc. ("Confidential Information").  You
 * shall not disclose such Confidential Information and shall use
 * it only in accordance with the terms of the license agreement
 * you entered into with Calypso Technology.
 *
 */
// use with JFlex version 1.3.5 or later
// NOPMD: this is generated

package com.calypso.tk.bo.workflow.rule;

import java_cup.runtime.*;

%%

%class RuleScanner
%public
%line
%column

%cupsym RuleSymbols
%cup
// If you want to use %cupdebug, be careful to replace in the generated
// scanner file "sym." by "RuleSymbols." (this comes from a bug of JFlex)
// cupdebug doesn't take into account the %cupsym argument.
// %cupdebug

%scanerror BadRuleException

%{
    private Symbol symbol(int type) {
	//System.out.println(Integer.toString(type) + " - no value");
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
	//System.out.println(Integer.toString(type) + " - " + value.toString());
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

Alpha = [a-zA-Z_]
Num = [0-9]
LineTerminator = \r|\n|\r\n
WhiteSpace = [ \t\f] | {LineTerminator}
PositiveInteger = 0 | [1-9][0-9]*
Double = {PositiveInteger} | {PositiveInteger}? "." "0"* {PositiveInteger} | {PositiveInteger} [eE] "-"? {PositiveInteger} | {PositiveInteger}? "." "0"* {PositiveInteger} [eE] "-"? {PositiveInteger}
Word = ({Alpha} | {Num} | [+-])+
String = "\"" ~"\""

Year = (19 | 20)[0-9][0-9]
Month = 0?[1-9] | 10 | 11 | 12
Day = 0?[1-9] | [1-2][0-9] | 30 | 31
Hour = [0-1][0-9] | 2[0-3]
Hour12 = {Month}
Minute = [0-5][0-9]
Date = {Month}"/"{Day}"/"{Year}
TimeStamp = {Hour}:{Minute} | {Hour12}:{Minute}([Aa][Mm] | [Pp][Mm])

%%

// Constants have to be evaluated before variables
<YYINITIAL> {
  [pP][iI]	{ return symbol(RuleSymbols.NUMBER, new RuleToken(Math.PI)); }
  [eE]		{ return symbol(RuleSymbols.NUMBER, new RuleToken(Math.E)); }
}

<YYINITIAL> {
  {Double}		{ return symbol(RuleSymbols.NUMBER, new RuleToken(Double.parseDouble(yytext()))); }
  {String}		{ return symbol(RuleSymbols.STRING, new RuleToken(yytext().substring(1, yytext().length()-1))); }
  {Word}"()"		{ return symbol(RuleSymbols.RULEREF, new RuleReference(yytext())); }
  {TimeStamp}		{ return symbol(RuleSymbols.TIME, new RuleTimeOfDay(yytext())); }
  {Date}		{ return symbol(RuleSymbols.DATE, new RuleDate(yytext())); }

  "+"			{ return symbol(RuleSymbols.PLUS); }
  "-"			{ return symbol(RuleSymbols.MINUS); }
  "*"			{ return symbol(RuleSymbols.MULT); }
  "/"			{ return symbol(RuleSymbols.DIV); }
  "("			{ return symbol(RuleSymbols.LPAREN); }
  ")"			{ return symbol(RuleSymbols.RPAREN); }
  "^"			{ return symbol(RuleSymbols.POW); }
  "<"			{ return symbol(RuleSymbols.LT); }
  ">"			{ return symbol(RuleSymbols.GT); }
  "<="			{ return symbol(RuleSymbols.LTE); }
  ">="			{ return symbol(RuleSymbols.GTE); }
  "=="			{ return symbol(RuleSymbols.EQ); }
  "!="			{ return symbol(RuleSymbols.NEQ); }
  "?"			{ return symbol(RuleSymbols.QMARK); }
  ":"			{ return symbol(RuleSymbols.SEMIC); }
  "||"			{ return symbol(RuleSymbols.OR); }
  "&&"			{ return symbol(RuleSymbols.AND); }
  "!"			{ return symbol(RuleSymbols.NOT); }
  [aA][bB][sS]"("	{ return symbol(RuleSymbols.ABS); }
  [mM][iI][nN]"("	{ return symbol(RuleSymbols.MIN); }
  [mM][aA][xX]"("	{ return symbol(RuleSymbols.MAX); }
  [cC][eE][iI][lL]"("	{ return symbol(RuleSymbols.CEIL); }
  [fF][lL][oO][oO][rR]"("  { return symbol(RuleSymbols.FLOOR); }
  [rR][oO][uU][nN][dD]"("  { return symbol(RuleSymbols.ROUND); }
  [Tt][Rr][Uu][Ee]	{ return symbol(RuleSymbols.BOOLEAN, new RuleToken(true)); }
  [Ff][Aa][Ll][Ss][Ee]	{ return symbol(RuleSymbols.BOOLEAN, new RuleToken(false)); }
  [Tt][Rr][Aa][Dd][Ee].{Word}	{ return symbol(RuleSymbols.TRADETOKEN, new TradeToken(yytext().substring(yytext().indexOf(".")+1))); }
  [Mm][Ee][Ss][Ss][Aa][Gg][Ee].{Word}	{ return symbol(RuleSymbols.MESSAGETOKEN, new MessageToken(yytext().substring(yytext().indexOf(".")+1))); }
  [Tt][Rr][Aa][Nn][Ss][Ff][Ee][Rr].{Word}	{ return symbol(RuleSymbols.TRANSFERTOKEN, new TransferToken(yytext().substring(yytext().indexOf(".")+1))); }
  ([Ss][Tt][Aa][Tt][Ii][Cc][Dd][Aa][Tt][Aa])?[Ff][Ii][Ll][Tt][Ee][Rr].{Word} { return symbol(RuleSymbols.FILTER, new RuleFilter(yytext().substring(yytext().indexOf(".")+1))); }
  {Word}.{Word} { return symbol(RuleSymbols.CUSTOMTOKEN, CustomToken.createCustomToken(yytext().substring(0, yytext().indexOf(".")), yytext().substring(yytext().indexOf(".")+1))); }
  {WhiteSpace}  { }
}
