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
// NOPMD: this is generated

package com.calypso.tk.util.parser;

import java_cup.runtime.*;

%%

%class Scanner
%public
%line
%column

//Pseudo-cup directive (replaces sym by Symbols)
%implements java_cup.runtime.Scanner
%function next_token
%type java_cup.runtime.Symbol
%eofval{
  return new java_cup.runtime.Symbol(Symbols.EOF);
%eofval}
%eofclose

%scanerror BadExprException

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

Alpha = [a-zA-Z]
Digit = [0-9]
LineTerminator = \r|\n|\r\n
WhiteSpace = [ \t\f] | {LineTerminator}
PositiveInteger = 0 | [0-9][0-9]*
Double = {PositiveInteger} | {PositiveInteger}? "." "0"* {PositiveInteger} | {PositiveInteger} [eE] "-"? {PositiveInteger} | {PositiveInteger}? "." "0"* {PositiveInteger} [eE] "-"? {PositiveInteger}
ConstantDouble = {PositiveInteger} | {PositiveInteger}? "." "0"* {PositiveInteger}
RatePercent = {ConstantDouble}[%]
BasisPoints = {ConstantDouble}[b][p][s]
Thousands = {ConstantDouble}[k] | {ConstantDouble}[K]
Millions = {ConstantDouble}[m] | {ConstantDouble}[M]
Billions = {ConstantDouble}[b] | {ConstantDouble}[B]
Trillions = {ConstantDouble}[t] | {ConstantDouble}[T]
Identifier = "$" {Alpha}({Alpha} | {Digit} | "_" | "|" | "." | "-" | "/" )* "$" |
             {Alpha} ({Alpha} | {Digit} | "_" | "|")*
Literal = ['] {Identifier} ([,] {Identifier})* [']
Date = [']{Digit}{Digit}[/]{Digit}{Digit}[/]{Digit}{Digit}{Digit}{Digit}[']
%%

// Constants have to be evaluated before variables
<YYINITIAL> {
  [pP][iI]	{ return symbol(Symbols.NUMBER, new ExprDouble(Math.PI)); }
  [eE]		{ return symbol(Symbols.NUMBER, new ExprDouble(Math.E)); }
}

<YYINITIAL> {
  {Double}		{ return symbol(Symbols.NUMBER, new ExprDouble(Double.parseDouble(yytext()))); }
  {BasisPoints}   	{ return symbol(Symbols.NUMBER, new ExprCalypsoDouble(yytext(), ExprCalypsoDouble.BPS)); }
  {RatePercent}	    { return symbol(Symbols.NUMBER, new ExprCalypsoDouble(yytext(), ExprCalypsoDouble.PERCENT)); }
  {Thousands}	    { return symbol(Symbols.NUMBER, new ExprCalypsoDouble(yytext(), ExprCalypsoDouble.THOUSANDS)); }
  {Millions}	    { return symbol(Symbols.NUMBER, new ExprCalypsoDouble(yytext(), ExprCalypsoDouble.MILLIONS)); }
  {Billions}	    { return symbol(Symbols.NUMBER, new ExprCalypsoDouble(yytext(), ExprCalypsoDouble.BILLIONS)); }
  {Trillions}	    { return symbol(Symbols.NUMBER, new ExprCalypsoDouble(yytext(), ExprCalypsoDouble.TRILLIONS)); }
  {Date}		    { return symbol(Symbols.VAR, new ExprLiteral(yytext())); }
  {Literal}		    { return symbol(Symbols.VAR, new ExprLiteral(yytext())); }
  {Identifier}		{ return symbol(Symbols.VAR, new ExprVariable(yytext())); }
  "+"			{ return symbol(Symbols.PLUS); }
  "-"			{ return symbol(Symbols.MINUS); }
  "*"			{ return symbol(Symbols.MULT); }
  "/"			{ return symbol(Symbols.DIV); }
  "("			{ return symbol(Symbols.LPAREN); }
  ")"			{ return symbol(Symbols.RPAREN); }
  "["			{ return symbol(Symbols.LARRAY); }
  "]"			{ return symbol(Symbols.RARRAY); }
  "^"			{ return symbol(Symbols.POW); }
  ","			{ return symbol(Symbols.COMMA); }
  "<"			{ return symbol(Symbols.LT); }
  ">"			{ return symbol(Symbols.GT); }
  "<="			{ return symbol(Symbols.LTE); }
  ">="			{ return symbol(Symbols.GTE); }
  "=="			{ return symbol(Symbols.EQ); }
  "!="			{ return symbol(Symbols.NEQ); }
  "?"			{ return symbol(Symbols.QMARK); }
  ":"			{ return symbol(Symbols.SEMIC); }
  "||"			{ return symbol(Symbols.OR); }
  "&&"			{ return symbol(Symbols.AND); }
  "$"{Identifier}	{ return symbol(Symbols.CONST, new ExprConstantPointer(yytext().substring(1))); }
  [cC][oO][sS]"("	{ return symbol(Symbols.COS); }
  [sS][iI][nN]"("	{ return symbol(Symbols.SIN); }
  [eE][xX][pP]"("	{ return symbol(Symbols.EXP); }
  [lL][oO][gG]"("	{ return symbol(Symbols.LOG); }
  [aA][bB][sS]"("	{ return symbol(Symbols.ABS); }
  [tT][aA][nN]"("	{ return symbol(Symbols.TAN); }
  [mM][iI][nN]"("	{ return symbol(Symbols.MIN); }
  [mM][aA][xX]"("	{ return symbol(Symbols.MAX); }
  [sS][uU][mM]"("	{ return symbol(Symbols.SUM); }
  [aA][cC][oO][sS]"("	{ return symbol(Symbols.ACOS); }
  [aA][sS][iI][nN]"("	{ return symbol(Symbols.ASIN); }
  [aA][tT][aA][nN]"("	{ return symbol(Symbols.ATAN); }
  [sS][qQ][rR][tT]"("	{ return symbol(Symbols.SQRT); }
  [cC][eE][iI][lL]"("	{ return symbol(Symbols.CEIL); }
  [fF][lL][oO][oO][rR]"("  { return symbol(Symbols.FLOOR); }
  [rR][oO][uU][nN][dD]"("  { return symbol(Symbols.ROUND); }
  [gG][aA][uU][sS][sS]"("  { return symbol(Symbols.GAUSS); }
  [gG][aA][uU][sS][sS]2[dD]"("  { return symbol(Symbols.GAUSS2D); }
  [nN][oO][rR][mM][aA][lL][dD]"(" { return symbol(Symbols.NORMALD); }
  [rR][oO][uU][nN][dD][uU][pP]"(" { return symbol(Symbols.ROUNDUP); }
  [rR][oO][uU][nN][dD][dD][oO][wW][nN]"(" { return symbol(Symbols.ROUNDDOWN); }
  [rR][oO][uU][nN][dD][rR][aA][tT][eE]"(" { return symbol(Symbols.ROUNDRATE); }
  [rR][oO][uU][nN][dD][fF][rR][aA][cC]"(" { return symbol(Symbols.ROUNDFRAC); }
  [cC][hH][aA][nN][gG][eE]"(" { return symbol(Symbols.CHANGEOF); }

  {WhiteSpace}  { }
}
