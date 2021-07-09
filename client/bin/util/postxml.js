if (WScript.Arguments.length < 1) 
{
   WScript.echo("HTTP POST Utility\n");
   WScript.echo("usage: postxml uri [options]");
   WScript.echo("  -f inputFile");
   WScript.echo("  -s inputString");
   WScript.echo("  -o outputFile");
   WScript.echo("  -h headerName headerValue");
   WScript.Quit(1);
}
var uri = WScript.Arguments.Item(0);
req = new ActiveXObject("MSXML2.XMLHTTP");
req.Open("POST", uri, false);
var file = null;
var data = "";
var outputFile = "";

if (WScript.Arguments.length > 1)
{
   var i;
   for (i=1; i<WScript.Arguments.length; i++)
   {
      option = WScript.Arguments.Item(i);
      if (option == "-f")
      {
         var inputFile = WScript.Arguments.Item(i+1);
         var fso = new ActiveXObject("Scripting.FileSystemObject");
         file = fso.OpenTextFile(inputFile, 1, false);
      }
      if (option == "-o")
      {
         outputFile = WScript.Arguments.Item(i+1);
      }
      else if (option == "-s")
      {
         data = WScript.Arguments.Item(i+1);
      }
      else if (option == "-h")
      {
         var headerName = WScript.Arguments.Item(i+1);
         var headerValue = WScript.Arguments.Item(i+2);
         req.setRequestHeader(headerName, headerValue);
      }
   }
}

// force Content-Type to 'text/xml'
req.setRequestHeader("Content-Type", "text/xml");


if (file != null)
{
   req.Send(file.ReadAll());
   file.Close();
}
else if (data != "")
   req.Send(data);
else
   req.Send();

if (outputFile != "")
{
   var fso = new ActiveXObject("Scripting.FileSystemObject");
   var txtFile = fso.CreateTextFile(outputFile, true);
   txtFile.WriteLine(req.responseText);
   txtFile.Close();
}
else
  WScript.echo(req.responseText);
