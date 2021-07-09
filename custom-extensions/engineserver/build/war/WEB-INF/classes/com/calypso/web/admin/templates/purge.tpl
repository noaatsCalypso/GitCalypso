<table align="center">
<tr>
<td>
<img src="/e-calypso/html/admin/tab3.gif" border="0" align="top" alt="" usemap="#tabs">
</td>
</tr>
</table>
<br>
<table cellspacing="2" cellpadding="2" border="1" align="center">

<tr>
<td>
<table cellspacing="2" cellpadding="2" border="0">
<tr>
<td colspan=7>&nbsp;</td>
</tr>
<tr>
<td colspan=7>&nbsp;</td>
</tr>
<tr>
    <td><FONT size="+1"><STRONG>Trade:</STRONG></FONT></td>
    <TD></TD>
    <td align="right"><strong>Min</strong></td>
    <td><INPUT name=tmin size="10"></td>
    <td align="right"><strong>Max</strong></td>
    <td><input type="text" name="tmax" size="10"></td>
    <td><INPUT type=submit value=Delete name=tdelete onClick="document.admin.adminAction.value='tdelete'; return true;"></td>
</tr>
<tr>
<td colspan=7>&nbsp;</td>
</tr>
<tr>
    <td><font size="+1"><strong>Events:</strong></font></td>
    <TD></TD>
    <td align="right"><strong>Min</strong></td>
    <td><INPUT name=emin size="10"></td>
    <td align="right"><strong>Max</strong></td>
    <td><INPUT name=emax size="10"></td>
    <td><INPUT type=submit value=Delete name=edelete onClick="document.admin.adminAction.value='edelete'; return true;"></td>
</tr>
<tr>
<td colspan=7>&nbsp;</td>
</tr>
<tr>
    <td rowspan="2"><font size="+1"><strong>Open Quantity:</strong></font></td>
    <TD>&nbsp;</TD>
    <td align="right"><STRONG><FONT size=4>&gt;</FONT></STRONG></td>
    <td colspan="2" nowrap>
<select name="oplDays">
	<option value="0" SELECTED></option>
	<option value="1">1</option>
	<option value="2">2</option>
	<option value="3">3</option>
	<option value="4">4</option>
	<option value="5">5</option>
	<option value="6">6</option>
	<option value="7">7</option>
	<option value="8">8</option>
	<option value="9">9</option>
	<option value="10">10</option>
	<option value="11">11</option>
	<option value="12">12</option>
	<option value="13">13</option>
	<option value="14">14</option>
	<option value="15">15</option>
	<option value="16">16</option>
	<option value="17">17</option>
	<option value="18">18</option>
	<option value="19">19</option>
	<option value="20">20</option>
	<option value="21">21</option>
	<option value="22">22</option>
	<option value="23">23</option>
	<option value="24">24</option>
	<option value="25">25</option>
	<option value="26">26</option>
	<option value="27">27</option>
	<option value="28">28</option>
	<option value="29">29</option>
	<option value="30">30</option>
	<option value="31">31</option>
</select>
<select name="oplMonths">
	<option value="0" SELECTED></option>
	<option value="1" >JAN</option>
	<option value="2">FEB</option>
	<option value="3">MAR</option>
	<option value="4">APR</option>
	<option value="5">MAY</option>
	<option value="6">JUN</option>
	<option value="7">JUL</option>
	<option value="8">AUG</option>
	<option value="9">SEP</option>
	<option value="10">OCT</option>
	<option value="11">NOV</option>
	<option value="12">DEC</option>
</select>
<select name="oplYears">
	<option value="0" SELECTED></option>
	<option value="1995">1995</option>
	<option value="1996">1996</option>
	<option value="1997">1997</option>
	<option value="1998">1998</option>
	<option value="1999">1999</option>
	<option value="2000">2000</option>
	<option value="2001">2001</option>
	<option value="2002">2002</option>
	<option value="2003">2003</option>
	<option value="2004">2004</option>
	<option value="2005">2005</option>
	<option value="2006">2006</option>
 </select>
</td>
    <td rowspan="2"><INPUT type=submit value=Purge name=oppurge onClick="document.admin.adminAction.value='oppurge'; return true;"></td>
    <td rowspan="2"></td>
    
</tr>
<tr>
    <TD></TD>
    <td align="right"><STRONG><FONT size="+1">&lt;</FONT></STRONG></td>
    <td colspan="2" nowrap>
<select name="oprDays">
	<option value="0" SELECTED></option>
	<option value="1" >1</option>
	<option value="2">2</option>
	<option value="3">3</option>
	<option value="4">4</option>
	<option value="5">5</option>
	<option value="6">6</option>
	<option value="7">7</option>
	<option value="8">8</option>
	<option value="9">9</option>
	<option value="10">10</option>
	<option value="11">11</option>
	<option value="12">12</option>
	<option value="13">13</option>
	<option value="14">14</option>
	<option value="15">15</option>
	<option value="16">16</option>
	<option value="17">17</option>
	<option value="18">18</option>
	<option value="19">19</option>
	<option value="20">20</option>
	<option value="21">21</option>
	<option value="22">22</option>
	<option value="23">23</option>
	<option value="24">24</option>
	<option value="25">25</option>
	<option value="26">26</option>
	<option value="27">27</option>
	<option value="28">28</option>
	<option value="29">29</option>
	<option value="30">30</option>
	<option value="31">31</option>
</select>
<select name="oprMonths">
	<option value="0" SELECTED></option>
	<option value="1" >JAN</option>
	<option value="2">FEB</option>
	<option value="3">MAR</option>
	<option value="4">APR</option>
	<option value="5">MAY</option>
	<option value="6">JUN</option>
	<option value="7">JUL</option>
	<option value="8">AUG</option>
	<option value="9">SEP</option>
	<option value="10">OCT</option>
	<option value="11">NOV</option>
	<option value="12">DEC</option>
</select>
<select name="oprYears">
	<option value="0" SELECTED></option>
	<option value="1995">1995</option>
	<option value="1996">1996</option>
	<option value="1997">1997</option>
	<option value="1998">1998</option>
	<option value="1999">1999</option>
	<option value="2000">2000</option>
	<option value="2001">2001</option>
	<option value="2002">2002</option>
	<option value="2003">2003</option>
	<option value="2004">2004</option>
	<option value="2005">2005</option>
	<option value="2006">2006</option>
 </select>
</td>
    
</tr>

<tr>
<td colspan=7>&nbsp;</td>
</tr>

<tr>
    <td rowspan="2"><font size="+1"><strong>Inventory Pos.:</strong></font></td>
    <TD>&nbsp;</TD>
    <td align="right"><STRONG><FONT size=4>&gt;</FONT></STRONG></td>
    <td colspan="2" nowrap>
<select name="iplDays">
	<option value="0" SELECTED></option>
	<option value="1">1</option>
	<option value="2">2</option>
	<option value="3">3</option>
	<option value="4">4</option>
	<option value="5">5</option>
	<option value="6">6</option>
	<option value="7">7</option>
	<option value="8">8</option>
	<option value="9">9</option>
	<option value="10">10</option>
	<option value="11">11</option>
	<option value="12">12</option>
	<option value="13">13</option>
	<option value="14">14</option>
	<option value="15">15</option>
	<option value="16">16</option>
	<option value="17">17</option>
	<option value="18">18</option>
	<option value="19">19</option>
	<option value="20">20</option>
	<option value="21">21</option>
	<option value="22">22</option>
	<option value="23">23</option>
	<option value="24">24</option>
	<option value="25">25</option>
	<option value="26">26</option>
	<option value="27">27</option>
	<option value="28">28</option>
	<option value="29">29</option>
	<option value="30">30</option>
	<option value="31">31</option>
</select>
<select name="iplMonths">
	<option value="0" SELECTED></option>
	<option value="1" >JAN</option>
	<option value="2">FEB</option>
	<option value="3">MAR</option>
	<option value="4">APR</option>
	<option value="5">MAY</option>
	<option value="6">JUN</option>
	<option value="7">JUL</option>
	<option value="8">AUG</option>
	<option value="9">SEP</option>
	<option value="10">OCT</option>
	<option value="11">NOV</option>
	<option value="12">DEC</option>
</select>
<select name="iplYears">
	<option value="0" SELECTED></option>
	<option value="1995">1995</option>
	<option value="1996">1996</option>
	<option value="1997">1997</option>
	<option value="1998">1998</option>
	<option value="1999">1999</option>
	<option value="2000">2000</option>
	<option value="2001">2001</option>
	<option value="2002">2002</option>
	<option value="2003">2003</option>
	<option value="2004">2004</option>
	<option value="2005">2005</option>
	<option value="2006">2006</option>
 </select>
</td>
    <td rowspan="2"><INPUT type=submit value=Purge name=ippurge onClick="document.admin.adminAction.value='ippurge'; return true;"></td>
    <td rowspan="2"></td>
    
</tr>
<tr>
    <TD></TD>
    <td align="right"><STRONG><FONT size="+1">&lt;</FONT></STRONG></td>
    <td colspan="2" nowrap>
<select name="iprDays">
	<option value="0" SELECTED></option>
	<option value="1" >1</option>
	<option value="2">2</option>
	<option value="3">3</option>
	<option value="4">4</option>
	<option value="5">5</option>
	<option value="6">6</option>
	<option value="7">7</option>
	<option value="8">8</option>
	<option value="9">9</option>
	<option value="10">10</option>
	<option value="11">11</option>
	<option value="12">12</option>
	<option value="13">13</option>
	<option value="14">14</option>
	<option value="15">15</option>
	<option value="16">16</option>
	<option value="17">17</option>
	<option value="18">18</option>
	<option value="19">19</option>
	<option value="20">20</option>
	<option value="21">21</option>
	<option value="22">22</option>
	<option value="23">23</option>
	<option value="24">24</option>
	<option value="25">25</option>
	<option value="26">26</option>
	<option value="27">27</option>
	<option value="28">28</option>
	<option value="29">29</option>
	<option value="30">30</option>
	<option value="31">31</option>
</select>
<select name="iprMonths">
	<option value="0" SELECTED></option>
	<option value="1" >JAN</option>
	<option value="2">FEB</option>
	<option value="3">MAR</option>
	<option value="4">APR</option>
	<option value="5">MAY</option>
	<option value="6">JUN</option>
	<option value="7">JUL</option>
	<option value="8">AUG</option>
	<option value="9">SEP</option>
	<option value="10">OCT</option>
	<option value="11">NOV</option>
	<option value="12">DEC</option>
</select>
<select name="iprYears">
	<option value="0" SELECTED></option>
	<option value="1995">1995</option>
	<option value="1996">1996</option>
	<option value="1997">1997</option>
	<option value="1998">1998</option>
	<option value="1999">1999</option>
	<option value="2000">2000</option>
	<option value="2001">2001</option>
	<option value="2002">2002</option>
	<option value="2003">2003</option>
	<option value="2004">2004</option>
	<option value="2005">2005</option>
	<option value="2006">2006</option>
 </select>
</td>
    
</tr>


<tr>
<td colspan=7>&nbsp;</td>
</tr>
<tr>
<td colspan=7>&nbsp;</td>
</tr>
</table>

</td>
</tr>
</table>
