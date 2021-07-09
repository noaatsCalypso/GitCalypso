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

package com.calypso.tk.bo.formatter;

import java_cup.runtime.*;

%%


%class Lexer
%unicode
%cup
%line
%column
%integer
%eofval{
  return null;
%eofval}
%eof{
  getFormatterParser().addLine(null);
%eof}
%eofclose
//%debug

%{
  StringBuffer string = new StringBuffer();

  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
  
  FormatterParser formatterParser = null;
  
  public void setFormatterParser(FormatterParser fp) {
      formatterParser = fp;
  }
  public FormatterParser getFormatterParser() {
      return formatterParser;
  }

%}


%state CALYPSO
%state IGNORE
%state GENERATED



LineTerminator = \r|\n|\r\n
WhiteSpace = [ \t\f] | {LineTerminator}
Letter = [:jletter:]
LetterDigit = [:jletterdigit:]
PositiveInteger = 0 | [1-9][0-9]*
Integer = -?{PositiveInteger}
Double = {Integer} | {Integer}? "." "0"* {Integer} | {Integer} [eE] "-"? {Integer} | {Integer}? "." "0"* {Integer} [eE] "-"? {Integer}
String = "\"" ([^\"] | "\\\"")* "\""
Function = {LetterDigit}* "/"
Parameter = "#" ([^\#\|])*
Identifier = {Function}* {Letter} {LetterDigit}* {Parameter}*
StartCalypso = "<" "!--"? [cC][aA][lL][yY][pP][sS][oO] ":r"? ">"
EndCalypso = "</"[cC][aA][lL][yY][pP][sS][oO] "--"? ">"
StartIgnore = "<!--"[iI][gG][nN][oO][rR][eE]"-->"
EndIgnore = "<!--/"[iI][gG][nN][oO][rR][eE]"-->"
StartGenerated = "<!--generatedStart-->"
EndGenerated = "<!--generatedEnd-->"

Year = (19 | 20)[0-9][0-9]
Month = 0?[1-9] | 10 | 11 | 12
Day = 0?[1-9] | [1-2][0-9] | 30 | 31
Date = {Month}"/"{Day}"/"{Year}

%%

<YYINITIAL> {
  {StartIgnore}			  	  {
  					      yybegin(IGNORE);
  					  }  				                                          
  
  {StartGenerated}			  {
  					      
                                              yybegin(GENERATED);
                                              getFormatterParser().startGenerated();
  					  }
  {StartCalypso}  	  		  { 
                                              boolean regenerate = yytext().contains(":r");
                                              if (regenerate) getFormatterParser().addOriginalLine("<!--generatedStart-->");
                                              getFormatterParser().startCalypsoLevel();
                                              getFormatterParser().start(yytext()); 
                                              yybegin(CALYPSO); 
                                              return symbol( regenerate ? sym.START_REGEN : sym.START);
                                          }
  !(![^\n\r] | {StartIgnore} | {StartGenerated} | {StartCalypso})	  { 
                                              getFormatterParser().addLine(yytext());
                                          }
  
  {LineTerminator}			  {
  						getFormatterParser().addLine("\n");
  					  }                                          

}


<CALYPSO> {
  {EndCalypso}			  	  {
                                              yybegin(YYINITIAL); 
                                              getFormatterParser().endCalypsoLevel();
                                              return symbol(sym.END);
                                              
                                          }
}
<GENERATED> {
  {EndGenerated}			  {
                                              boolean end = getFormatterParser().endGenerated();
                                              if (end) yybegin(YYINITIAL); 
                                          }
  
  {StartGenerated}			  {
                                              getFormatterParser().startGenerated();
                                          }
  ~({EndGenerated}|{StartGenerated})	  {
                                              String s = yytext();
                                              int endIndex = s.lastIndexOf("<!--");
                                              boolean isStart = s.endsWith("<!--generatedStart-->");
                                              getFormatterParser().collectGenerated(s.substring(0, endIndex));
                                              
                                              boolean end = isStart ? false : getFormatterParser().endGenerated();
                                              
                                              if (end) yybegin(YYINITIAL);
                                          }
}

<IGNORE> {
  ~{EndIgnore}			  	  {
                                              yybegin(YYINITIAL); 
                                          }
}



/*
 * --- Keywords ---
 */

<CALYPSO>"if"		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.IF); }
<CALYPSO>"iterator"     { getFormatterParser().echoCalypso(yytext()); return symbol(sym.ITERATOR); }
<CALYPSO>"else"		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.ELSE); }
<CALYPSO>"include"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.INCLUDE); }
<CALYPSO>"inline"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.INLINE); }
<CALYPSO>"set"		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.SET); }
<CALYPSO>[Tt]"rue"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.TRUE); }
<CALYPSO>[Ff]"alse"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.FALSE); }
<CALYPSO>[Tt]"rade"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.TRADE); }
<CALYPSO>[Tt]"ransfer"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.TRANSFER); }
<CALYPSO>[Mm]"essage"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.MESSAGE); }
<CALYPSO>[Ss]"ender"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.SENDER); }
<CALYPSO>[Rr]"eceiver"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.RECEIVER); }
<CALYPSO>[Pp]"roduct"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.PRODUCT); }


/*
 * --- Operators ---
 */

<CALYPSO>"("			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.LPAREN); }
<CALYPSO>")"			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.RPAREN); }
<CALYPSO>"<"			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.LT); }
<CALYPSO>">"			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.GT); }
<CALYPSO>"<="			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.LTE); }
<CALYPSO>">="			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.GTE); }
<CALYPSO>"="			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.EQ); }
<CALYPSO>"=="			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.EQEQ); }
<CALYPSO>"!="			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.NEQ); }
<CALYPSO>"=~"			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.MAT); }
<CALYPSO>"!~"			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.NMAT); }
<CALYPSO>"||"			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.OR); }
<CALYPSO>"&&"			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.AND); }
<CALYPSO>"!"			{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.NOT); }
<CALYPSO>"EMPTY"|"empty"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.EMPTY); }
<CALYPSO>"NOTEMPTY"|"notempty"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.NOTEMPTY); }
<CALYPSO>"LIKE"|"like"		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.LIKE); }
<CALYPSO>"IN"|"in"		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.IN); }
<CALYPSO>"NOTIN"|"notin"	{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.NOTIN); }


/*
 * --- Punctuation ---
 */
 
<CALYPSO>"."		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.PERIOD); }
<CALYPSO>","		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.COMMA); }
<CALYPSO>"{"		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.LBLOCK); }
<CALYPSO>"}"		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.RBLOCK); }
<CALYPSO>";"		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.SEMIC); }
<CALYPSO>"|"		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.KEYWORD_DELIM); }

<CALYPSO> {

  /*
   * --- Identifiers ---
   */
  {Identifier}		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.IDENTIFIER, yytext()); }

  /*
   * --- Literals ---
   */
  {Double}		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.NUMBER, new Double(yytext())); }
  {String}		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.STRING, yytext().substring(1, yytext().length()-1)); }
  {Date}		{ getFormatterParser().echoCalypso(yytext()); return symbol(sym.DATE); }

  {WhiteSpace}		{ getFormatterParser().echoCalypso(yytext()); }
  
  /*
   * Ignore standard HTML tags in code that may have been
   * added by HTML editor
   */
  "<"[Bb][Rr]">"	{ getFormatterParser().echoCalypso(yytext()); getFormatterParser().addLine("<br>"); }
  "<"[Pp]">"		{ getFormatterParser().echoCalypso(yytext()); getFormatterParser().addLine("<p>"); }
  "</"[Pp]">"		{ getFormatterParser().echoCalypso(yytext()); getFormatterParser().addLine("</p>"); }
  "<"[Bb][Rr]"/>"	{ getFormatterParser().echoCalypso(yytext()); getFormatterParser().addLine("<br/>"); }
  "</"[Bb][Rr]">"	{ getFormatterParser().echoCalypso(yytext()); getFormatterParser().addLine("</br>"); }
  "<span>"		{ getFormatterParser().echoCalypso(yytext()); getFormatterParser().addLine("<span>"); }
  "</span>"		{ getFormatterParser().echoCalypso(yytext()); getFormatterParser().addLine("</span>"); }
  "<SPAN>"		{ getFormatterParser().echoCalypso(yytext()); getFormatterParser().addLine("<span>"); }
  "</SPAN>"		{ getFormatterParser().echoCalypso(yytext()); getFormatterParser().addLine("</span>"); }
}
